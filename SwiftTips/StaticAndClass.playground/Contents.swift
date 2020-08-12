import UIKit

// Swift 中表示 “類型範圍作用域” 這一概念有兩個不同的關鍵字，它們分別是 static 和 class 。
// 這兩個關鍵字確實都表達了這個意思，但是在其他一些語言，包括 Objective-C 中，
// 我們並不會特別地區分類變量/類方法和靜態變量/靜態函數。
// 但是在 Swift 的早期版本中，這兩個關鍵字卻是不能用混的。
// 在非 class 的類型上下文中，我們統一使用 static 來描述類型作用域。
// 這包括在 enum 和 struct 中表述類型方法和類型屬性時。在這兩個值類型中，
// 我們可以在類型範圍內聲明並使用存儲屬性，計算屬性和方法。 static 適用的場景有這些:

struct Point {
    let x: Double
    let y: Double
    
    // 存儲屬性
    static let zero = Point(x: 0, y: 0)
    
    //　計算屬性
    static var ones: [Point] {
        return [Point(x: 1, y: 1),
                Point(x: -1, y: 1),
                Point(x: 1, y: -1),
                Point(x: -1, y: -1)]
    }
    
    // 類型方法
    static func add(p1: Point, p2: Point) -> Point {
        return Point(x: p1.x + p2.x, y: p1.y + p2.y)
    }
}


// enum 的情況與這個十分類似，就不再列舉了。
// class 關鍵字相比起來就明白許多，是專門用在 class 類型的上下文中的，
// 可以用來修飾類方法 以及類的計算屬性。但是有一個例外， class 中現在是不能出現 class 的存儲屬性的，
// 我們如果寫類似這樣的代碼的話:

class Bar {
    //
}
// This is wrong
//class MyClass {
//    class var bar: Bar?
//}

// 在 Swift 1.2 及之後，我們可以在 class 中使用 static 來聲明一個類作用域的變量。也即:

class MyClass2 {
    static var bar: Bar?
}

// 的寫法是合法的。有了這個特性之後，像單例的寫法就可以回歸到我們所習慣的方式了。
// 有一個比較特殊的是 protocol 。在 Swift 中 class／struct／enum 都是可以實現某個 protocol 的。
//　那麼如果我們想在 protocol 裡定義一個類型域上的方法或者計算屬性的話，應該用哪個關鍵字呢?
//　答案是使用 static 進行定義。在使用的時候， struct 或 enum 中仍然使用 static ，
//　而在class 裡我們既可以使用 class 關鍵字，也可以用 static ，它們的結果是相同的:

protocol MyProtocol {
    static func foo() -> String
}

struct MyStruct: MyProtocol {
    static func foo() -> String {
        return "MyStruct"
    }
}

class MyEnum: MyProtocol {
    static func foo() -> String {
        return "MyEnum"
    }
}

class MyClass3: MyProtocol {
    // 在class中可以使用class
    class func foo() -> String {
        return "MyClass.foo()"
    }
    // 也可以使用static
    static func bar() -> String {
        return "MyClass.bar()"
    }
    
}

// 類別的型別方法也可以被繼承覆寫，但是當你用 static宣告時，是不能覆寫的。
// 如果想把被覆寫的開關打開，請用 class 宣告。

//  this is wrong
//class Baby {
//    static func getMaxAge() -> Int {
//        return 100
//    }
//}

//class SuperBaby: Baby {
//    override static func getMaxAge() -> Int {
//        return 1000
//    }
//}

class Baby2 {
    class func getMaxAge() -> Int {
        return 100
    }
}

class SuperBaby2: Baby2 {
    override class func getMaxAge() -> Int {
        return 1000
    }
}

SuperBaby2.getMaxAge()

// Swift 裡面的 static 跟 dynamic 關鍵字分別有特殊的意義。
// static 是讓某 type member 不用被初始化成 instance 就可以用，
// 而之所以叫做「static」是因為 compiler 在編譯時就會知道該 type member 是屬於誰（也就是 type 本身），並且它的實際內容是什麼。
// dynamic 則是強制讓某 instance member 透過 Objective-C Runtime 去動態派發。
