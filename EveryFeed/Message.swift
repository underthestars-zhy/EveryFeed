//
//  Message.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/16.
//

import SwiftUI

struct Message: View {
    @EnvironmentObject var data:DataManager
    
    @State private var selectedItem: String?
    @State private var listViewId = UUID()
    
    let name:String
    var body: some View {
        Form {
            ForEach(0..<data.getTimeStringArray(items: data.getMessageBox(name: name)).count) { count in
                Section(header: Text(data.getTimeStringArray(items: data.getMessageBox(name: name))[count])) {
                    ForEach(data.getMessageBox(name: name)) {item in
                        NavigationLink(
                            destination: messageBoxView(box: item, name: name, isRoot: false),
                            label: {
                                Label(item.title, systemImage: item.isBug ? "ladybug.fill" : "seal.fill")
                            })
//                        NavigationLink(
//                            destination: messageBoxView(box: item),
//                            tag: "\(item.id)",
//                            selection: self.$selectedItem,
//                            label: {
//                                Label(item.title, systemImage: item.isBug ? "ladybug.fill" : "seal.fill")
//                            })
//                            .id(listViewId)
//                            .onAppear {
//                                if selectedItem != nil {
//                                    selectedItem = nil
//                                    listViewId = UUID()
//                                }
//                            }
                    }
                }
            }
        }
        .navigationBarTitle(Text(name), displayMode: .inline)
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message(name: "EveryFeed")
    }
}
