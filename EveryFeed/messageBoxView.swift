//
//  messageBoxView.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/20.
//

import SwiftUI

struct messageBoxView: View {
    var box:messageBox
    let name:String
    @EnvironmentObject var data:DataManager
    @State var showModal = false
    var isRoot:Bool
    var body: some View {
        if isRoot {
            messageBoxForm(box: box, name: name, isRoot: isRoot).environmentObject(data)
                .navigationBarItems(trailing: Menu {
                    Button(action: {showModal = true}, label: {Text("Reply")})
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }.sheet(isPresented: self.$showModal) {
                    ReplyView(isRoot: self.isRoot, name: name).environmentObject(data)
                })
        } else {
            messageBoxForm(box: box, name: name, isRoot: isRoot).environmentObject(data)
                .navigationBarItems(trailing: Button(action: {
                    showModal = true
                }, label: {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                }).disabled(!data.loudBox.canReply)).sheet(isPresented: self.$showModal) {
                    ReplyView(isRoot: self.isRoot, name: name).environmentObject(data)
                }
        }
    }
}

struct messageBoxForm: View {
    var box:messageBox
    let name:String
    var isRoot:Bool
    @State var canShow = false
    @EnvironmentObject var data:DataManager
    var body: some View {
        Form {
            if canShow {
                Group {
                    Section(header: Text("title")) {
                        Text(data.loudBox.title)
                    }
                    Section(header: Text("body")) {
                        Text(data.loudBox.body)
                            .padding(4)
                    }
                }
                
                Group {
                    if data.loudBox.isBug {
                        Section(header: Text("Info")) {
                            HStack {
                                Text("Frequency")
                                Spacer()
                                Text("\(data.loudBox.rate!)")
                                    .foregroundColor({
                                        switch self.box.rate ?? 1 {
                                        case 1...3:
                                            return Color.blue
                                        case 4...6:
                                            return Color.pink
                                        case 7...10:
                                            return Color.red
                                        default:
                                            return Color.blue
                                        }
                                    }())
                            }
                            if data.loudBox.major ?? false {
                                Text("Extremely disturbing")
                                    .foregroundColor(.red)
                            }
                        }
                    } else {
                        if data.loudBox.url != "" || data.loudBox.canHelp! {
                            Section(header: Text("Resources")) {
                                if data.loudBox.url != "" {
                                    if !data.loudBox.url!.hasPrefix("https://") && !data.loudBox.url!.hasPrefix("http://") {
                                        Link(destination: URL.init(string: "https://" + data.loudBox.url!)!) {
                                            Text("https://" + data.loudBox.url!)
                                        }
                                    } else {
                                        Link(destination: URL.init(string: data.loudBox.url!)!) {
                                            Text(data.loudBox.url!)
                                        }
                                    }
                                }
                                if data.loudBox.canHelp! {
                                    Link(destination: URL.init(string: data.loudBox.mail!)!) {
                                        Text(data.loudBox.mail!)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if !isRoot {
                    Section(header: Text("status")) {
                        if data.loudBox.isRead {
                            Text("already received!")
                                .foregroundColor(.green)
                        } else {
                            Text("Processing...")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                if data.loudBox.replyBox.count != 0 {
                    ForEach(0..<data.loudBox.replyBox.count) { count in
                        Section(header: Text("Message #\(count + 1)")) {
                            Text(data.loudBox.replyBox[count])
                                .foregroundColor({
                                    if self.isRoot {
                                        if count % 2 == 0 {
                                            return .blue
                                        } else {
                                            return Color.init(UIColor.label.cgColor)
                                        }
                                    } else {
                                        if count % 2 != 0 {
                                            return .blue
                                        } else {
                                            return Color.init(UIColor.label.cgColor)
                                        }
                                    }
                                }())
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            print("Appear")
            data.setBox(box: self.box)
            data.canLoud = true
            self.canShow = true
            if self.isRoot && !self.box.isRead {
                data.readMessageBox(box: box, name: name)
            } else if !self.isRoot {
                data.updateMessageBox(name: name, box: self.box)
            }
            
        })
        .onDisappear(perform: {
            print("DisAppear")
            data.canLoud = false
        })
        .navigationBarTitle(Text(box.title), displayMode: .inline)
    }
}

//struct messageBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        messageBoxView(box: messageBox())
//    }
//}
