//
//  DataManager.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/16.
//

import SwiftUI

class DataManager:ObservableObject {
    
    // static let share = DataManager()
    
    let userDefaults = UserDefaults.standard
    
    let appId = "1531724bdac69601ef45715991ecd1fe"
    let getUser = [
        "384d30672948": ("EveryCheck", 2),
        "83de161a427u": ("EveryFeed", 2),
    ]
    
    
    
    @Published var feedApp = [String]()
    @Published var notFinishCount = [Int]()
    @Published var account = [[String]]()
    
    init(){
        feedApp = (userDefaults.array(forKey: "feedApp")) as? Array<String> ?? [String]()
        notFinishCount = (userDefaults.array(forKey: "notFinishCount")) as? Array<Int> ?? [Int]()
        account = (userDefaults.array(forKey: "account")) as? [[String]] ?? [[String]]()
    }
    
    func setFeedApp(name:String) {
        var count = 0
        for item in feedApp {
            if item == name {
                notFinishCount[count] += 1
                userDefaults.setValue(notFinishCount, forKey: "notFinishCount")
                userDefaults.synchronize()
                return
            }
            count += 1
        }
        feedApp.append(name)
        notFinishCount.append(1)
        userDefaults.setValue(feedApp, forKey: "feedApp")
        userDefaults.setValue(notFinishCount, forKey: "notFinishCount")
        userDefaults.synchronize()
    }
    
    func saveFeedBack(appName:String, isBug:Bool, title: String, body: String, rates:Int?, influences:Bool?, url:String?, canHelp:Bool?, email:String?) -> Bool {
        
        if title == "" || body == "" {
            return false
        }
        
        
        if isBug {
            
            let gamescore:BmobObject = BmobObject(className: appName)
            gamescore.setObject(title, forKey: "title")
            gamescore.setObject(body, forKey: "body")
            gamescore.setObject(rates!, forKey: "rates")
            gamescore.setObject(influences!, forKey: "influences")
            gamescore.setObject(Date(), forKey: "date")
            gamescore.setObject(true, forKey: "isBug")
            
            gamescore.saveInBackground()
            setFeedApp(name: appName)
            updateId(appName: appName)
            
            let item = messageBox(isBug: true, title: title, body: body, date: Date(), rate: rates, major: influences, url: nil, canHelp: nil, mail: nil, canReply: false)
            
            saveMessageBox(name: appName, saveItem: item)
            return true
        } else {
            let gamescore:BmobObject = BmobObject(className: appName)
            gamescore.setObject(title, forKey: "title")
            gamescore.setObject(body, forKey: "body")
            gamescore.setObject(url!, forKey: "url")
            if canHelp ?? false {
                gamescore.setObject(true, forKey: "help")
                gamescore.setObject(email!, forKey: "email")
            } else {
                gamescore.setObject(false, forKey: "help")
                gamescore.setObject("", forKey: "email")
            }
            gamescore.setObject(Date(), forKey: "date")
            gamescore.setObject(false, forKey: "isBug")
            
            gamescore.saveInBackground()
            setFeedApp(name: appName)
            updateId(appName: appName)
            
            let item = messageBox(isBug: false, title: title, body: body, date: Date(), rate: nil, major: nil, url: url, canHelp: canHelp, mail: email, canReply: false)
            
            saveMessageBox(name: appName, saveItem: item)
            return true
        }
        
    }
    
    func updateId(appName: String) {
        let query:BmobQuery = BmobQuery(className: appName + "Id")
        query.findObjectsInBackground { (array, error) in
            if array?.count ?? 0 > 0 {
                print("Use")
                let obj = array?[0] as! BmobObject
                let id = obj.object(forKey: "id") as! Int
                print("updateId \(id + 1)")
                let gamescore:BmobObject = BmobObject(outDataWithClassName: appName + "Id", objectId: obj.objectId)
                gamescore.deleteInBackground({ ok, _ in
                    print("Use Delete \(ok)")
                })
                let gamescore2:BmobObject = BmobObject(className: appName + "Id")
                gamescore2.setObject((id + 1), forKey: "id")
                gamescore2.saveInBackground()
            } else {
                let gamescore:BmobObject = BmobObject(className: appName + "Id")
                gamescore.setObject(1, forKey: "id")
                gamescore.saveInBackground()
            }
        }
    }
    
    func getMessageBox(name:String) -> [messageBox] {
        let decoder = JSONDecoder()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let fileName = path! + "/" + name + ".plist"
        // print(fileName)
        // print(NSArray(contentsOfFile: fileName)?.count)
        let allItems = NSArray(contentsOfFile: fileName) as? Array<Data>
        var array = [messageBox]()
        var count = 0
        if let items = allItems {
            for item in items {
                var box = try! decoder.decode(messageBox.self, from: item)
                box.id = count
                array.append(box)
                count += 1
            }
        }
        return array.reversed()
    }
    
    func getTimeStringArray(items: [messageBox]) -> Array<String> {
        var title = ""
        var array = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for item in items {
            print(dateFormatter.string(from: item.date))
            if title != dateFormatter.string(from: item.date) {
                title = dateFormatter.string(from: item.date)
                array.append(title)
            }
        }
        return array
    }
    
    func saveMessageBox(name:String, saveItem:messageBox) {
        var boxArray = getMessageBox(name: name)
        boxArray.append(saveItem)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let fileName = path! + "/" + name + ".plist"
        encoder(items: boxArray).write(toFile: fileName, atomically: true)
    }
    
    func encoder(items: [messageBox]) -> NSArray {
        let encoder = JSONEncoder()
        var array = [Data]()
        for item in items {
            array.append(try! encoder.encode(item))
        }
        return array as NSArray
    }
    
    func addAccount(number:String) -> Bool {
        for (itemNumber, t) in getUser {
            if itemNumber == number {
                account.append([t.0, "\(t.1)"])
                userDefaults.set(account, forKey: "account")
                userDefaults.synchronize()
                return true
            }
        }
        return false
    }
    
}

struct messageBox:Codable, Identifiable {
    let isBug:Bool
    let title:String
    let body:String
    let date:Date
    let rate:Int?
    let major:Bool?
    let url:String?
    let canHelp:Bool?
    let mail:String?
    var canReply = false
    
    var replyBox = [String]()
    
    var id:Int = 0
}
