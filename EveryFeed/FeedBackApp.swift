//
//  FeedBackApp.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/21.
//

import SwiftUI

struct FeedBackApp: View {
    let name:String
    let isRoot:Bool
    @EnvironmentObject var data:DataManager
    @State var showRloud = false
    var body: some View {
        Form {
            if showRloud {
                Text("Louding ...")
            } else {
                if data.appItem[name] != nil && data.appItem[name]?.count != 0 {
                    ForEach(0..<data.getTimeStringArray(items: data.appItem[name] ?? []).count) { count in
                        Section(header: Text(data.getTimeStringArray(items: data.appItem[name] ?? [])[count])) {
                            ForEach(data.getMessageBox(date: data.getTimeStringArray(items: data.appItem[name] ?? [])[count], appName: name)) {item in
                                NavigationLink(
                                    destination: messageBoxView(box: item, name: name, isRoot: isRoot).environmentObject(data),
                                    label: {
                                        Label(item.title, systemImage: item.isBug ? "ladybug.fill" : "seal.fill")
                                    })
                            }
                        }
                    }
                } else {
                    Text("No Message, wait...")
                }
            }
        }
        .onDisappear(perform: {
            data.appItem[name] = []
            data.startGetAppItem(appName: name)
        })
        .navigationBarItems(trailing: Button(action: {
            showRloud = true
            data.appItem[name] = []
            data.startGetAppItem(appName: name)
            DispatchQueue.global().async {
                while true {
                    if data.appItem[name]?.count != 0 {
                        showRloud = false
                        break
                    }
                }
            }
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath")
        }))
        .navigationBarTitle(Text(name), displayMode: .inline)
        
    }
}

struct FeedBackApp_Previews: PreviewProvider {
    static var previews: some View {
        FeedBackApp(name: "", isRoot: false)
    }
}
