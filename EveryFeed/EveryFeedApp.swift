//
//  EveryFeedApp.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/16.
//

import SwiftUI

@main
struct EveryFeedApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Bmob.register(withAppKey: "1531724bdac69601ef45715991ecd1fe")
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                print(path!)
            }
        }
    }
}
