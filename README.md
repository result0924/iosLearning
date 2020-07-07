# iOS Test App

### Some Refer

- [老司機週報](https://github.com/SwiftOldDriver/iOS-Weekly/releases)
- [13的開發者週報](https://ethanhuang13.substack.com/)
- [Good Share](https://juejin.im/post/5ee6f0b1e51d4578762019af)

- Entry device's system page from app
```
if let url = URL(string:UIApplicationOpenSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
```
https://www.jianshu.com/p/5fd0ac245e85

- ActionSheet for iPad
```
if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
```
