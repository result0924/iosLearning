# iOS Test App

### Some Refer

- [OneV's Den](https://onevcat.com/)
- [老司機週報](https://github.com/SwiftOldDriver/iOS-Weekly/releases)
- [13的開發者週報](https://ethanhuang13.substack.com/)
- [iOS摸魚週報](https://zhangferry.com/)
- [戴銘的博客](https://ming1016.github.io/)
- [肘子的Swift記事本](https://www.fatbobman.com/)
- [SwfitGG](https://swift.gg/)
- [整理XCode空間](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E5%88%AA%E9%99%A4xcode%E4%BD%94%E6%93%9A%E7%A1%AC%E7%A2%9F%E5%A4%A7%E9%87%8F%E7%A9%BA%E9%96%93%E7%9A%84derived-data-190c85eba79)
- [想成為iOS高階開發者](https://www.gushiciku.cn/pl/a6wC/zh-tw)
- [iOS coder review](https://newsletter.ioscodereview.com/)
- [swiftlyrushy](https://swiftlyrush.curated.co/)
- [圖解方式、教學使用XCode快速鍵](https://xcode.tips/)
- [swift new](https://theswiftdev.com/news/)
- [swift vincent](https://www.swiftwithvincent.com/tips)
### Unit Test
- [UIView test](https://benoitpasquier.com/unit-testing-uiview-action-gesture-swift/)
- [Unit testing asynchronous Swift code](https://www.swiftbysundell.com/articles/unit-testing-asynchronous-swift-code/)
- [MVVM + Dependency Injection + test](https://www.youtube.com/watch?v=Q1sjLDQMNzU&ab_channel=iCode)
- [A complete list of articles on Unit Testing with Swift from 2017](https://medium.com/@koromikoneo/a-complete-list-of-articles-on-unit-testing-with-swift-from-2017-9be8f046ef25)
### Inter View
- [iOS inter-view-question](https://github.com/onthecodepath/iOS-Interview-Questions)
- [linkedin-quizzes-swift](https://github.com/Ebazhanov/linkedin-skill-assessments-quizzes/blob/master/swift/swift-quiz.md)
- [iOS inter-view-question-and-answer](https://www.raywenderlich.com/762435-swift-interview-questions-and-answers)
- [interview the best](https://lazarevzubov.medium.com/interviewing-the-best-5da59e7176b2)

- [2022 awesome newsletters](https://blog.eidinger.info/awesome-newsletters-for-ios-and-swift-developers-in-2022?utm_campaign=SwiftlyRush%2BMonthly&utm_medium=web&utm_source=SwiftlyRush_Monthly_34)

### Git Hub
- [AR 100 Days](https://github.com/satoshi0212/AR_100Days)
- [Combine Playground](https://github.com/AvdLee/CombineSwiftPlayground)
- [in app debug](https://github.com/FLEXTool/FLEX)
- [Xcode Tips](https://github.com/Xcode-Tips/xcode-tips.github.io)

### Core Data
- [repository pattern](https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/)
- [transformable](https://danielbernal.co/coredata-transformable-and-nssecurecoding-in-ios-13/)

### GCD
- [GCD 教學](https://github.com/ming1016/study/wiki/%E7%BB%86%E8%AF%B4GCD%EF%BC%88Grand-Central-Dispatch%EF%BC%89%E5%A6%82%E4%BD%95%E7%94%A8)

### Memory
- [檢測和診斷應用程序內存問題](https://mp.weixin.qq.com/s?__biz=MzI2NTAxMzg2MA==&mid=2247492779&idx=1&sn=a371a10a3bcf58acd5593a1a38d6f1db&scene=21#wechat_redirect)

### Design Patteren
- https://daddycoding.com/design-pattern/

### Some thing
- [Bash腳本資料教學](https://wangdoc.com/bash/intro.html)
- [Use string print Data](https://gist.github.com/jkereako/606cda72f3f8aa5c6c8eb5ec8ce227a1)
- [Record your screen](https://github.com/wulkano/kap)

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

### tools
- [Diagram] (https://app.diagrams.net/)
