# iOS Test App

### Some Refer

- [老司機週報](https://github.com/SwiftOldDriver/iOS-Weekly/releases)
- [13的開發者週報](https://ethanhuang13.substack.com/)
- [整理XCode空間](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E5%88%AA%E9%99%A4xcode%E4%BD%94%E6%93%9A%E7%A1%AC%E7%A2%9F%E5%A4%A7%E9%87%8F%E7%A9%BA%E9%96%93%E7%9A%84derived-data-190c85eba79)

### Inter View
- [iOS inter-view-question](https://github.com/onthecodepath/iOS-Interview-Questions)
- [linkedin-quizzes-swift](https://github.com/Ebazhanov/linkedin-skill-assessments-quizzes/blob/master/swift/swift-quiz.md)

### Some thing

- Unit test import project
```
@testable import project
```

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
### reinstall
- [Terminal open vscode](https://stackoverflow.com/questions/30065227/run-open-vscode-from-mac-terminal)
- [Terminal open gitx](https://stackoverflow.com/questions/11625836/make-gitx-open-via-terminal-for-the-repo-laying-at-the-current-path)
- zsh add alias
```
vim ~/.zshrc
source ~/.zshrc
```
