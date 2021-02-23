# Doucument

## Get app code
> In the settings, click the plus sign and enter the application code to add an application
1. Send email to **zhuhaoyu0909@icloud.com**
2. State your **app name** (*If there are duplicates, we will explain to you*)
3. We will provide you with two sets of activation codes (*Divided into observers and administrators*)
4. In the **next update of the app**, you can enter the app code to get app feedback qualification
5. You can **distribute activation codes** to get your team involved

## Integrated into your app

```swift
let url = URL(string: "everyfeed://feedback?appName=<your app name>")
if UIApplication.shared.canOpenURL(url!) {
    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
} else {
    let aler = UIAlertController(title: "Downloud EveryFeed", message: "Go to the store to download Every Feed", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    aler.addAction(cancel)
    let downloud = UIAlertAction(title: "Downloud", style: .default, handler: nil)
    aler.addAction(downloud)
    self.present(aler, animated: true, completion: nil)
}
```
