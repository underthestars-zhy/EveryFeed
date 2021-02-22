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
            gamescore.setObject(false, forKey: "isRead")
            gamescore.setObject(false, forKey: "canReply")
            gamescore.setObject([String](), forKey: "reply")
            setFeedApp(name: appName)
            
            gamescore.saveInBackground {[weak gamescore] (_, _) in
                if let game = gamescore {
                    let item = messageBox(isBug: true, title: title, body: body, date: Date(), rate: rates, major: influences, url: nil, canHelp: nil, mail: nil, canReply: false, isRead: false, objectid: game.objectId, replyBox: [String]())
                    
                    self.saveMessageBox(name: appName, saveItem: item)
                }
            }
            
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
            gamescore.setObject(false, forKey: "isRead")
            gamescore.setObject(false, forKey: "canReply")
            gamescore.setObject([String](), forKey: "reply")
            setFeedApp(name: appName)
            
            gamescore.saveInBackground {[weak gamescore] (_, _) in
                if let game = gamescore {
                    let item = messageBox(isBug: false, title: title, body: body, date: Date(), rate: nil, major: nil, url: url, canHelp: canHelp, mail: email, canReply: false, isRead: false, objectid: game.objectId, replyBox: [String]())
                    
                    self.saveMessageBox(name: appName, saveItem: item)
                }
            }
            
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
        return array.sorted {
            return $0.date > $1.date
        }
    }
    
    func getMessageBox(date:String, appName:String) -> [messageBox] {
        var array = [messageBox]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let items = appItem[appName] {
            for item in items {
                if dateFormatter.string(from: item.date) == date {
                    array.append(item)
                }
            }
        }
        return array.sorted {
            return $0.date > $1.date
        }
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
    
    func readMessageBox(box:messageBox, name:String) {
        if let items = appItem[name] {
            var count = 0
            for item in items {
                if item.objectid == box.objectid {
                    appItem[name]?[count].isRead = true
                    let query:BmobQuery = BmobQuery(className: name)
                    query.getObjectInBackground(withId: item.objectid) { (obj, error) in
                        if error == nil {
                            if let game = obj {
                                game.setObject(true, forKey: "isRead")
                                game.updateInBackground()
                            }
                        }
                    }
                }
                count += 1
            }
        }
    }
    
    @Published var loudBox = messageBox(isBug: true, title: "", body: "", date: Date(), rate: nil, major: nil, url: nil, canHelp: nil, mail: nil, canReply: false, isRead: false, objectid: "", replyBox: [String]())
    var canLoud = false
    
    func updateMessageBox(name:String, box:messageBox) {
        print(box.objectid)
        let query:BmobQuery = BmobQuery(className: name)
        query.getObjectInBackground(withId: box.objectid) { (obj, error) in
            if error == nil {
                if let game = obj{
                    if self.canLoud {
                        print("Uesd")
                        self.loudBox.isRead = game.object(forKey: "isRead") as! Bool
                        self.loudBox.replyBox = game.object(forKey: "reply") as! [String]
                        self.loudBox.canReply = game.object(forKey: "canReply") as! Bool
                        self.updateMessageBoxInFile(box: self.loudBox, name: name)
                    }
                }
            }
        }
    }
    
    func addMessageToBox(name:String, reply:String, isRoot:Bool) {
        let query:BmobQuery = BmobQuery(className: name)
        // print(loudBox.objectid)
        self.loudBox.replyBox.append(reply)
        query.getObjectInBackground(withId: loudBox.objectid) { (obj, error) in
            if error == nil {
                if let game = obj{
                    game.setObject(isRoot, forKey: "canReply")
                    game.setObject(self.loudBox.replyBox, forKey: "reply")
                    game.updateInBackground()
                }
            }
        }
    }
    
    func updateMessageBoxInFile(box:messageBox, name:String) {
        var count = 0
        var boxArray = getMessageBox(name: name)
        for item in boxArray {
            if item.objectid == box.objectid {
                boxArray.remove(at: count)
                boxArray.insert(box, at: count)
                break
            }
            count += 1
        }
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let fileName = path! + "/" + name + ".plist"
        encoder(items: boxArray).write(toFile: fileName, atomically: true)
    }
    
    func setBox(box:messageBox) {
        self.loudBox = messageBox(isBug: box.isBug, title: box.title, body: box.body, date: box.date, rate: box.rate, major: box.major, url: box.url, canHelp: box.canHelp, mail: box.mail, canReply: box.canReply, isRead: box.isRead, objectid: box.objectid, replyBox: box.replyBox)
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
    
    func deleteAccount(name: String, _  i:String) {
        var count = 0
        for itemArray in account {
            if itemArray[0] == name && itemArray[1] == i {
                account.remove(at: count)
                userDefaults.set(account, forKey: "account")
                userDefaults.set(0, forKey: "\(name)Finish")
                userDefaults.set(0, forKey: "\(name)Loud")
                userDefaults.synchronize()
                return
            }
            count += 1
        }
    }
    
    @Published var appItem = [String:[messageBox]]()
    
    func startGetAppItem(appName:String) {
        let query2:BmobQuery = BmobQuery(className: appName)
        query2.findObjectsInBackground { (array, error) in
            var tArray = [messageBox]()
            if let items = array {
                for item in items {
                    let boxObjc = item as! BmobObject
                    if boxObjc.object(forKey: "isBug") as! Bool {
                        let box = messageBox(isBug: true, title: boxObjc.object(forKey: "title") as! String, body: boxObjc.object(forKey: "body") as! String, date: boxObjc.createdAt, rate: boxObjc.object(forKey: "rates") as? Int, major: boxObjc.object(forKey: "influences") as? Bool, url: nil, canHelp: nil, mail: nil, canReply: boxObjc.object(forKey: "canReply") as! Bool, isRead: boxObjc.object(forKey: "isRead") as! Bool, objectid: boxObjc.objectId, replyBox: boxObjc.object(forKey: "reply") as! [String])
                        tArray.append(box)
                    } else {
                        let box = messageBox(isBug: false, title: boxObjc.object(forKey: "title") as! String, body: boxObjc.object(forKey: "body") as! String, date: boxObjc.createdAt, rate: nil, major: nil, url: boxObjc.object(forKey: "url") as? String, canHelp: boxObjc.object(forKey: "help") as? Bool, mail: boxObjc.object(forKey: "email") as? String, canReply: boxObjc.object(forKey: "canReply") as! Bool, isRead: boxObjc.object(forKey: "isRead") as! Bool, objectid: boxObjc.objectId, replyBox: boxObjc.object(forKey: "reply") as! [String])
                        tArray.append(box)
                    }
                }
            }
            var count = 0
            for boxItem in tArray.sorted(by: { item1, item2 in
                return item1.date > item2.date
            }) {
                var tBox = messageBox(isBug: boxItem.isBug, title: boxItem.title, body: boxItem.title, date: boxItem.date, rate: boxItem.rate, major: boxItem.major, url: boxItem.url, canHelp: boxItem.canHelp, mail: boxItem.mail, canReply: boxItem.canReply, isRead: boxItem.isRead, objectid: boxItem.objectid, replyBox: boxItem.replyBox)
                tBox.id = count
                if self.appItem[appName] == nil {
                    self.appItem[appName] = [messageBox]()
                    self.appItem[appName]?.append(tBox)
                }else {
                    self.appItem[appName]?.append(tBox)
                }
                count += 1
            }
        }
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
    var canReply:Bool
    var isRead:Bool
    let objectid:String
    
    var replyBox: [String]
    
    var id:Int = 0
}
