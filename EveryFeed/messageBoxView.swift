//
//  messageBoxView.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/20.
//

import SwiftUI

struct messageBoxView: View {
    var box:messageBox
    var body: some View {
        Form {
            Section(header: Text("title")) {
                Text(box.title)
            }
            Section(header: Text("body")) {
                Text(box.body)
                    .padding(4)
            }
            
            if box.isBug {
                Section(header: Text("Info")) {
                    HStack {
                        Text("Frequency")
                        Spacer()
                        Text("\(box.rate!)")
                            .foregroundColor({
                                switch self.box.rate! {
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
                    if box.major ?? false {
                        Text("Extremely disturbing")
                            .foregroundColor(.red)
                    }
                }
            } else {
                if box.url != "" || box.canHelp! {
                    Section(header: Text("Resources")) {
                        if box.url != "" {
                            if !box.url!.hasPrefix("https://") && !box.url!.hasPrefix("http://") {
                                Link(destination: URL.init(string: "https://" + box.url!)!) {
                                    Text("https://" + box.url!)
                                }
                            } else {
                                Link(destination: URL.init(string: box.url!)!) {
                                    Text(box.url!)
                                }
                            }
                        }
                        if box.canHelp! {
                            Link(destination: URL.init(string: box.mail!)!) {
                                Text(box.mail!)
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Message")) {
                if box.replyBox.count == 0 {
                    Text("No reply, processing...")
                        .foregroundColor(.red)
                } else {
                    
                }
            }
        }
        .navigationBarTitle(Text(box.title), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Image(systemName: "arrowshape.turn.up.left.fill")
        }).disabled(!box.canReply))
    }
}

//struct messageBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        messageBoxView(box: messageBox())
//    }
//}
