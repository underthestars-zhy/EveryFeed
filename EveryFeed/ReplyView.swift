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
    let rootReply = ["Checking...", "Unable to reproduce", "We have found the problem"]
    let userReply = ["Wait", "This problem only occurred once"]
    @EnvironmentObject var data:DataManager
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reply")) {
                    TextEditor(text: $input)
                        .frame(height: 200)
                }
                Section(header: Text("Common words")) {
                    if self.isRoot {
                        ForEach(0..<self.rootReply.count) {count in
                            Button(action: {
                                self.data.addMessageToBox(name: self.name, reply: self.rootReply[count], isRoot: isRoot)
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text(self.rootReply[count])
                                    .foregroundColor(Color.init(UIColor.label.cgColor))
                            })
                        }
                    } else {
                        ForEach(0..<self.userReply.count) {count in
                            Button(action: {
                                self.data.addMessageToBox(name: self.name, reply: self.userReply[count], isRoot: isRoot)
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text(self.userReply[count])
                                    .foregroundColor(Color.init(UIColor.label.cgColor))
                            })
                        }
                    }
                }
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
