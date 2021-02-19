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
    let getUser = ["384d30672948": "EveryCheck", "83de161a42": "EveryFeed"]
    
    
    
    @Published var feedApp = [String]()
    @Published var notFinishCount = [Int]()
    @Published var account = [String]()
    
    init(){
        Bmob.register(withAppKey: "1531724bdac69601ef45715991ecd1fe")
        feedApp = (userDefaults.array(forKey: "feedApp")) as? Array<String> ?? [String]()
        notFinishCount = (userDefaults.array(forKey: "notFinishCount")) as? Array<Int> ?? [Int]()
        account = (userDefaults.array(forKey: "account")) as? Array<String> ?? [String]()
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
    
}
