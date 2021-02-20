//
//  ContentView.swift
//  EveryRead
//
//  Created by 朱浩宇 on 2021/2/16.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var data = DataManager()
    
    var body: some View {
        TabView {
            MeesageView()
                .environmentObject(data)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Message")
                }
            FeedBackView()
                .environmentObject(data)
                .tabItem {
                    Image(systemName: "ladybug.fill")
                    Text("FeedBack")
                }
            SettingView()
                .environmentObject(data)
                .tabItem{
                Image(systemName: "gearshape.fill")
                Text("Seeting")
                }
        }
    }
    
    
}

struct MeesageView: View {
    @EnvironmentObject var data:DataManager
    var body: some View {
        NavigationView {
            Form {
                if data.account.count != 0 {
                    Section(header: Text("App")) {
                        ForEach(0..<data.account.count) {count in
                            NavigationLink(destination: MyApp()) {
                                Text(data.account[count])
                            }
                        }
                    }
                }
                if data.feedApp.count != 0 {
                    Section(header: Text("User")) {
                        ForEach(0..<data.feedApp.count) {count in
                            NavigationLink.init(
                                destination: Message(name: data.feedApp[count]).environmentObject(data),
                                label: {
                                    Text(data.feedApp[count])
                                    Spacer()
                                    Text(getNotFinishNum(count: count))
                                        .foregroundColor(.gray)
                                })
                        }
                    }
                } else {
                    Section(header: Text("Message")) {
                        Text("Sorry No Message")
                    }
                }
            }
            .navigationTitle("Message")
        }
    }
    
    func getNotFinishNum(count:Int) -> String{
        guard data.notFinishCount.count > count else {
            return ""
        }
        guard data.notFinishCount[count] != 0 else {
            return ""
        }
        return "\(data.notFinishCount[count])"
    }
}


struct FeedBackView: View {
    @EnvironmentObject var data:DataManager
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Zhu Haoyu")) {
                    NavigationLink(destination: FeedBack(appName: "EveryCheck").environmentObject(self.data)) {
                        Text("EveryCheck")
                    }
                    NavigationLink(destination: FeedBack(appName: "EveryFeed").environmentObject(self.data)) {
                        Text("EveryFeed")
                    }
                }
            }
            .navigationBarTitle(Text("FeedBack"), displayMode: .automatic)
        }
    }
}

struct SettingView: View {
    @EnvironmentObject var data:DataManager
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    if data.account.count == 0 {
                        Label("No Account", systemImage: "xmark.octagon.fill")
                            .listItemTint(.red)
                    } else {
                        ForEach(0..<data.account.count) {count in
                            NavigationLink(destination: MyApp()) {
                                Text(data.account[count])
                            }
                        }
                    }
                }
                
                Section(header: Text("Author")) {
                    Label("By Zhu Haoyu", systemImage: "person.circle")
                    Link(destination: URL.init(string: "https://github.com/underthestars-zhy")!) {
                        Label("See me on GitHub", systemImage: "hands.sparkles.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Other")) {
                    Link(destination: URL.init(string: "https://github.com/underthestars-zhy")!) {
                        Label("Document", systemImage: "doc")
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
