//
//  MyApp.swift
//  EveryFeed
//
//  Created by 朱浩宇 on 2021/2/16.
//

import SwiftUI

struct MyApp: View {
    let appArray:[String]
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data:DataManager
    @State var showAlert = false
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Label(appArray[0], systemImage: "app")
            }
            Section(header: Text("Authority")) {
                if appArray[1] == "1" {
                    Label("Observer", systemImage: "eye")
                } else {
                    Label("administrator", systemImage: "person")
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            showAlert = true
        }, label: {
            Image(systemName: "trash")
                .foregroundColor(.red)
        })
        .alert(isPresented: $showAlert) {
                Alert(title: Text("Delete"), message: Text("Sure to continue"),
                      primaryButton: .destructive(Text("Delete"), action: {
                        data.deleteAccount(name: appArray[0], appArray[1])
                        self.presentationMode.wrappedValue.dismiss()
                      }),
                      secondaryButton: .cancel(Text("Cencel")))
            })
        .navigationBarTitle(Text(appArray[0]), displayMode: .inline)
    }
}

//struct MyApp_Previews: PreviewProvider {
//    static var previews: some View {
//        MyApp()
//    }
//}
