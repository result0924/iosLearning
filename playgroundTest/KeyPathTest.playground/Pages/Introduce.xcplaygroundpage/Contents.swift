import UIKit

/*:
### KeyPath
 - [Refer](https://www.youtube.com/watch?v=QkF3_gnh8Dg&t=688s&ab_channel=ChaoCode)
 - 什麼是KeyPath
   - 不需要實例就能表示「屬性位置&類型」
   - 解釋在一個資料中，那個位置有什麼類型的東西
 - 用途：
   - 語法糖
   - 確保快速單純的使用
 - 寫法：\.Root.Value
 - 讀取：rootObject[keyPath: path]

 - literal expression
 ```
 struct Cat {
     let name
 }

 \Cat.name
 \ + 類型名稱 + . + 屬性名稱
 \ + Root + . + Value

 KeyPath<Cat, String>

 "" -> String
 [] -> Array
 ```
 - 用下標存取object[keyPath: path]
 ```
 let cat = Cat(name: "Amy")
 cat.name == cat[keyPath: \.name]
 如果已經知道實例是什麼swfit就可以省略實例、直接使用＼.Value
 ```
 - 可轉換成Closures `(Root) -> Value`
 ```
 let cats = [Cat(name: "Amy"), Cat(name: "Tony")]
 print(cats.map(\.name))

 替換(Root) -> Value
 - Literal expression 可以被判斷成 KeyPath 或( Root) -> Value
 literal expression在無法轉換成keypath時、會嘗試把它轉成Closures
 ```
 - KeyPath都是Hashable、表示都是一個字典的Key或可以把它存在Set裡面
 */

//: [Next](@next)
