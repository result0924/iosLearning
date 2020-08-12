import UIKit

// 我們經常會對 Array 類型使用 map 方法，這個方法能對數組中的所有元素應用某個規則，
// 然後返回一個新的數組。我們可以在 CollectionType 的 extension 中找到這個方法的定義:
//  extension CollectionType {
//    public func map<T>(@noescape transform:
//      (Self.Generator.Element) -> T) -> [T]
//      //...
//  }

// 舉個簡單的使用例子:

let arr = [1, 2, 3]
let doubled = arr.map {
    $0 * 2
}

print(doubled)

// 這很方便，而且在其他一些語言裡 map 可以說是很常見也很常用的一個語言特性了。
// 因此當這個 特性出現在 Swift 中時，也贏得了 iOS/Mac 開發者們的歡迎。
// 現在假設我們有個需求，要將某個 Int? 乘 2。
// 一個合理的策略是如果這個 Int? 有值的話，就取 出值進行乘 2 的操作，
// 如果是 nil 的話就直接將 nil 賦給結果。依照這個策略，我們可以寫出 如下代碼:

let num: Int? = 3
var result: Int?

if let realNum = num {
    result = realNum * 2
} else {
    result = nil
}

// 其實我們有更優雅簡潔的方式，那就是使用 Optional 的 map 。
// 對的，不僅在 Array 或者說 CollectionType 裡可以用 map ，
// 如果我們仔細看過 Optional 的聲明的話，會發現它也有一個 map 方法:

// public enum Optional<T> : _Reflectable, NilLiteralConvertible {
//    //...
//    /// If `self == nil`, returns `nil`. Otherwise, returns `f(self!)`.
//    public func map<U>(@noescape f: (T) -> U) -> U? //...
// }

// 這個方法能讓我們很方便地對一個 Optional 值做變化和操作，而不必進行手動的解包工作。
// 輸入會被自動用類似 Optinal Binding 的方式進行判斷，如果有值，則進入 f 的閉包進行變換，並返 回一個 U? ;
// 如果輸入就是 nil 的話，則直接返回值為 nil 的 U? 。
// 有了這個方法，上面的代碼就可以大大簡化，而且 result 甚至可以使用常量值:

let num2: Int? = 3
let result2 = num2.map{$0 * 2}
print(result2 ?? "nil")

// 如果您了解過一些函數式編程的概念，可能會知道這正符合函子 (Functor) 的概念。
// 不論是 Array 還是 Optional ，它們擁有一個同樣名稱的 map 函數並不是命名上的偶然。
// 函子指的是可以被某個函數作用，並映射為另一組結果，而這組結果也是函子的值。
// 在我們的例子裡， Array 的 map 和 Optional 的 map 都滿足這個概念，
// 它們分別將 [Self.Generator.Element] 映射為 [T] 以及 T? 映 射為 U?
