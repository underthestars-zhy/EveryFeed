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
                            NavigationLink(destination: FeedBackApp()) {
                                Text(data.account[count][0])
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
                        Text("Sorry No User Message")
                    }
                }
            }
            .navigationTitle("Message")
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
    @State var alertIsPresented = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    if data.account.count == 0 {
                        Label("No Account", systemImage: "xmark.octagon.fill")
                            .listItemTint(.red)
                    } else {
                        ForEach(0..<data.account.count) {count in
                            NavigationLink(destination: MyApp(appArray: data.account[count]).environmentObject(data)) {
                                Text(data.account[count][0])
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
            .navigationBarItems(trailing: Button(action: {
                alert()
            }){
                Image(systemName: "plus")
            })
            .navigationTitle("Setting")
        }
    }
    
    private func alert() {
        let alert = UIAlertController(title: "Account", message: "Need verification to add", preferredStyle: .alert)
        var theTextFiled = UITextField()
        alert.addTextField() { textField in
            textField.placeholder = "Enter confirmation code"
            theTextFiled = textField
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if data.addAccount(number: theTextFiled.text ?? "") {
                print("OK")
            } else {
                print("Not OK")
            }
        })
        showAlert(alert: alert)
    }

    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }

    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
