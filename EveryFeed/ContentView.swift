//
//  ContentView.swift
//  EveryRead
//
//  Created by 朱浩宇 on 2021/2/16.
//

import SwiftUI

struct ContentView: View {
    @State var showDetail = false
    
    var body: some View {
        TabView {
            Button(action: {}, label: {
                Text("Button")
            })
            .tabItem {
                Image(systemName: "message.fill")
                Text("Message")
            }
            NavigationView {
                Form {
                    Section(header: Text("Zhu Haoyu")) {
                        NavigationLink(destination: FeedBack(appName: "EveryCheck")) {
                            Text("EveryCheck")
                        }
                        NavigationLink(destination: FeedBack(appName: "EveryRead")) {
                            Text("EveryRead")
                        }
                        NavigationLink(destination: FeedBack(appName: "EveryReed")) {
                            Text("EveryFeed")
                        }
                    }
                }
                .navigationTitle("FeedBack")
            }
            .tabItem {
                Image(systemName: "ladybug.fill")
                Text("FeedBack")
            }
            NavigationView {
                Form {
                    
                }
                .navigationTitle("Setting")
            }
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text("Seeting")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
