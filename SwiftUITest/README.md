### SwiftUI Test
===
### Refer
- https://github.com/FradSer/30-days-of-swiftui
- https://www.appcoda.com.tw/swiftui-introduction/
- https://github.com/ivanvorobei/SwiftUI
- [Why use `some` keyword](https://medium.com/@PhiJay/whats-this-some-in-swiftui-34e2c126d4c4)
- https://onevcat.com/2019/06/swift-ui-firstlook/

### Note
- Can't support before iOS13 version
- SwiftUI write view use code
- XCode -> Edit -> Covas 預覽模式(option + command + enter)
假如你沒有看到預覽畫面，請點擊預覽視窗中的`Resume`
- Preview layout in different devices
- (Option + Command + P) 刷新 preview 
```

#if DEBUG
struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      Group {
         ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")

         ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")
      }
   }
}
#endif
```