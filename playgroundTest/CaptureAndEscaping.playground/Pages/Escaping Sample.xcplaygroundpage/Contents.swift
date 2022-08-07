//: [Previous](@previous)
/*:
 ### Escaping closure: 會跳出被建立的地方，獨立存在的closure
 - 當參數標上@escaping時是提醒呼叫端這個closure會產生強連結
 */
import _Concurrency
import Foundation

let numbers = [1, 2, 3]

// Non-escaping
numbers.forEach { number in
    print("number")
}

// Escaping: 被一個變數儲存的時候
struct A {
    var closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
}

A.init {}

// Escaping: 被另一個 escaping closure capture的時候

func doSomething(action: @escaping () -> Void) {
    Task.init{
        action()
    }
}

//: [Next](@next)
