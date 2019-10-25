import SwiftUI

// Error
//func createView() -> View {
//
//}
//
//// Success
//func createView<T: View>() -> T {
//
//}

// Error
//struct ContentView: View {
//    var body: View {
//        Text("Hello World")
//    }
//}

// Success
//struct ContentView: View {
//    var body: Text {
//        Text("Hello World")
//    }
//}

//當然我們可以明確指定出 body 的類型，但是這帶來一些麻煩：
//
//1. 每次修改 body 的返回時我們都需要手動去更改相應的類型。
//2. 新建一個 View 的時候，我們都需要去考慮會是什麼類型。
//3. 其實我們只關心返回的是不是一個 View，而對實際上它是什麼類型並不感興趣。
//some View 這種寫法使用了 Swift 5.1 的 Opaque return types 特性。它向編譯器作出保證，每次 body 得到的一定是某一個確定的，遵守 View 協議的類型，但是請編譯器“網開一面”，不要再細究具體的類型。

//返回類型確定單一這個條件十分重要

let someCondition: Bool = true

// Error: Function declares an opaque return type,
// but the return statements in its body do not have
// matching underlying types.
var body: some View {
    ZStack {
        if someCondition {
            // 这个分支返回 Text
            Text("Hello World")
        } else {
            // 这个分支返回 Button，和 if 分支的类型不统一
            Button(action: {}) {
                Text("Tap me")
            }
        }
    }
}
