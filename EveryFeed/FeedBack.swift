//
//  FeedBack.swift
//  EveryRead
//
//  Created by 朱浩宇 on 2021/2/16.
//

import SwiftUI

struct FeedBack: View {
    var appName = ""
    @State var pickerValue = 0
    var pickerOptions = ["Bug", "Suggest"]
    
    @State var title = ""
    @State var sTitle = ""
    @State var bodyText = ""
    @State var sBodyText = ""
    @State var stepperValue = 1
    @State var toggleValue = false
    @State var url = ""
    @State var canHelp = false
    @State var email = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Type")) {
                Picker("Picker", selection: $pickerValue) {
                    ForEach(0..<pickerOptions.count) { index in
                        Text(pickerOptions[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Title")){
                TextField("title", text: pickerValue == 0 ? $title : $sTitle)
            }
            
            Section(header: Text("Body")){
                TextEditor(text: pickerValue == 0 ? $bodyText : $sBodyText)
                    .frame(height: 200)
            }
            
            if pickerValue == 0 {
                Section(header: Text("Info")) {
                    Stepper("Frequency: \(stepperValue)", value: $stepperValue, in: 1...10)
                    Toggle("Great influence", isOn: $toggleValue)
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                }
            } else {
                Section(header: Text("Resources")) {
                    TextField("url", text: $url)
                    Toggle("Can Help", isOn: $canHelp)
                    if canHelp {
                        TextField("email", text: $email)
                    }
                }
                
            }
        }
        .navigationTitle(appName)
        .navigationBarItems(
            trailing:
                Button(action: {
                    showAlert = true
                }) {
                    Text("Submit")
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text("You will receive a reply later."),
                        dismissButton: .default(Text("OK"), action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    )
                }
        )
    }
}

//struct FeedBack_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedBack()
//    }
//}
