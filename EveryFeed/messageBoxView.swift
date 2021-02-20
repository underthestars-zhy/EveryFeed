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
