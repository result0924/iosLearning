import UIKit

// Swift 2 中引入了一個非常重要的特性，那就是 protocol extension。
// 在 Swift 1.x 中，extension 僅只能作用在實際的類型上 (也就是 class , struct 等等)，而不能擴展一個 protocol。
// 在 Swift 中，標準庫的功能基本都是基於 protocol 來實現的，舉個最簡單的例子，
// 我們每天使用的 Array 就是 遵守了 CollectionType 這個 protocol 的。
// CollectionType 可以說是 Swift 中非常重要的協議，除了Array 以外，
// 像是 Dictionary 和 Set 也都實現了這個協議所定義的內容。
// 在 protocol 不能被擴展的時候，當我們想要為實現了某個協議的所有類型添加一些另外的共通的功能時，會非常麻煩。
// 一個很好的例子是 Swift 1.x 時像是 map 或者 filter 這樣的函數。
// 大體來說，我們有兩種思路進行添加:第一種方式是在協議中定義這個方法，
// 然後在所有實現了這個協議的類型中都去實現一遍。每有一個這樣的類型，我們就需要寫一份類似甚至相同的方法，
// 這顯然是不可取的，不僅麻煩，而且完全沒有可維護性。
// 另一種方法是在全局範圍實現一個接受該protocol的實例的方法，相比於前一種方式，我們只需要維護一份代碼，顯然要好不少，
// 但是缺點在於在全局作用域中引入了只和特定protocol 有關的東⻄，這並不符合代碼設計的美學。
// 作為妥協，Apple 在Swift 1.x 中採用的是後一種，也就是全局方法，如果你嘗試尋找的話，
// 可以在Swift 1.x 的標準庫的全局scope 中找到像是map 和filter 這樣的方法。
// 在 Swift 2 中這個問題被徹底解決了。現在我們可以對一個已有的 protocol 進行擴展，
// 而擴展中實現的方法將作為實現擴展的類型的默認實現。也就是說，假設我們有下面的 protocol 聲明，以及一個對該協議的擴展:

protocol MyProtocol {
    func method()
}

extension MyProtocol {
    func method() {
        print("Called")
    }
}

// 在具體的實現這個協議的類型中，即使我們什麼都不寫，也可以編譯通過。進行調用的話，會直接使用 extension 中的實現:

struct MyStruct: MyProtocol {}
MyStruct().method()

// 當然，如果我們需要在類型中進行其他實現的話，可以像以前那樣在具體類型中添加這個方法:

struct MyStruct2: MyProtocol {
    func method() {
        print("Stuct called")
    }
}

MyStruct2().method()

// 也就是說，protocol extension 為 protocol 中定義的方法提供了一個默認的實現。
// 有了這個特性以後，之前被放在全局環境中的接受 CollectionType 的 map 方法，就可以被移動到 CollectionType 的協議擴展中去了

// extension CollectionType {
//     public func map<T>(@noescape transform: (Self.Generator.Element) -> T) -> [T] //...
// }

// 在日常開發中，另一個可以用到 protocol extension 的地方是 optional 的協議方法。
// 通過提供 protocol 的 extension，我們為 protocol 提供了默認實現，
// 這相當於變相將 protocol 中的方法設定為了 optional。關於這個，我們在可選協議和協議擴展一節中已經講述過，就不再重複了。
// 對於 protocol extension 來說，有一種會非常讓人迷惑的情況，
// 就是在協議的擴展中實現了協議裡沒有定義的方法時的情況。舉個例子，比如我們定義了這樣的一個協議和它的一個擴展:

protocol A1 {
    func method1() -> String
}

struct B1: A1 {
    func method1() -> String {
        return "hello"
    }
}

// 在使用的時候，無論我們將實例的類型為 A1 還是 B1，因為實現只有一個，所以沒有任何疑問， 調用方法時的輸出都是 “hello”:
let b1 = B1()
b1.method1()

let a1: A1 = B1()
a1.method1()

// 但是如果在協議裡只定義了一個方法，而在協議擴展中實現了額外的方法的話，事情就變得有趣 起來了。考慮下面這組協議和它的擴展:

protocol A2 {
    func method1() -> String
}

extension A2 {
    func method1() -> String {
        return "hi"
    }
    
    func method2() -> String {
        return "hi"
    }
}

// 擴展中除了實現協議定義的 method1 之外，還定義了一個協議中不存在的方法 method2。我們嘗試來實現這個協議:

struct B2: A2 {
    func method1() -> String {
        return "hello"
    }
    
    func method2() -> String {
        return "hello"
    }
}

// B2 中實現了 method1 和 method2 。接下來，我們嘗試初始化一個 B2 對象，然後對這兩個方法進行調用:

let b2 = B2()

b2.method1()
b2.method1()

// 結果在我們的意料之中，雖然在 protocol extension 中已經實現了這兩個方法，
// 但是它們只是默認的實現，我們在具體實現協議的類型中可以對默認實現進行覆蓋，這非常合理。
// 但是如果我們稍作改變，在上面的代碼後面繼續添加:

let a2 = b2 as A2
a2.method1()
a2.method2()

// a2 和 b2 是同一個對象，只不過我們通過 as 告訴編譯器我們在這裡需要的類型是 A2 。
// 但是這時候在這個同樣的對像上調用同樣的方法調用卻得到了不同的結果，發生了什麼?
// 我們可以看到，對 a2 調用 method2 實際上是協議擴展中的方法被調用了，而不是 a2 實例中的方法被調用。
// 我們不妨這樣來理解:對於 method1 ，因為它在 protocol 中被定義了，
// 因此對於一個被聲明為遵守協議的類型的實例 (也就是對於 a2 ) 來說，可以確定實例必然實現了 method1
// 我們可以放心大膽地用動態派發的方式使用最終的實現(不論它是在類型中的具體實現，還是在協議擴展中的默認實現);
// 但是對於 method2 來說，我們只是在協議擴展中進行了定義，沒有任何規定說它必須在最終的類型中被實現。
// 在使用時，因為 a2 只是一個符合 A2 協議的實例，編譯器對 method2 唯一能確定的只是在協議擴展中有一個默認實現，
// 因此在調用時，無法確定安全，也就不會去進行動態派發，而是轉而編譯期間就確定的默認實現。

// 也許在這個例子中你會覺得無所謂，因為實際中估計並不會有人將一個已知類型實例轉回協議類型。
// 但是要考慮到如果你的一些泛型API中有類似的直接拿到一個協議類型的結果的時候，
// 調用它的擴展方法時就需要特別小心了:一般來說，如果有這樣的需求的話，
// 我們可以考慮將這個協議類型再轉回實際的類型，然後進行調用。

// 整理一下相關的規則的話:
//    如果類型推斷得到的是實際的類型那麼類型中的實現將被調用;
//    如果類型中沒有實現的話，那麼協議擴展中的默認實現將被使用
// 如果類型推斷得到的是協議，而不是實際類型
//    並且方法在協議中進行了定義，那麼類型中的實現將被調用;如果類型中沒有實現，那麼協議擴展中的默認實現被使用
//    否則(也就是方法沒有在協議中定義)，擴展中的默認實現將被調用
