//
//  ReplyView.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/22.
//

import SwiftUI

struct ReplyView: View {
    var isRoot:Bool
    @State var input = ""
    var name:String
    @EnvironmentObject var data:DataManager
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reply")) {
                    TextEditor(text: $input)
                        .frame(height: 200)
                }
//                Section(header: Text("Common words")) {
//
//                }
            }
            .navigationTitle("Reply")
            .navigationBarItems(trailing: Button(action: {
                self.data.addMessageToBox(name: self.name, reply: self.input, isRoot: isRoot)
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "paperplane.fill")
                    .disabled(!(input != ""))
            })
        }
    }
}

//struct ReplyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReplyView()
//    }
//}
