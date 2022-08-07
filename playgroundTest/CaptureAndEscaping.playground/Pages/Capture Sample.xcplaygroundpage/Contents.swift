//: [Previous](@previous)

/*:
 ### Capture List: 把需要的外部變數建立成local變數
 - 只能在closure expression使用
 - 搭配Value Type時等同複製
 - 搭配Reference Type時可以設定弱連結
 

 */

import _Concurrency
import Darwin

class Wallet {
    var money: Int = 100
    
//    func buySomething(cost: Int){
//        money -= cost
//        print("花了\(cost), 剩下\(money)")
//    }
    // []就是Capture List
    // 可以在裡面寫上要被Capture的東西
    // 被寫在裡面的東西會被用複制的方式儲存
    // 比方說可以寫self、就是複制了一份self
    // 不過這樣並沒有解決問題只是再多了一個強連結而
    // 必須搭配unowned or weak來變成弱連結
    lazy var buySomething: (Int) -> Void = { [weak self] cost in
        guard let self = self else {
            print("no wallet can use")
            return
        }
        self.money -= cost
        print("花了\(cost), 剩下\(self.money)")
    }
    
    // 如果沒有要改變屬性可以直接capture屬性就好、
    // 這樣等於直接複制屬性、
    // 所以裡面的moeny和外面的money已經是沒有任何關系
    lazy var buySomething2: (Int) -> Void = { [money] cost in
        print("剩下\(money)")
    }
    
    func buyLatter(amount: Int) {
        Task { [weak self] in
            try! await Task.sleep(seconds: 3)
            guard let self = self else {
                print("buy latter wallet bye bye")
                return
            }
            self.money -= amount
            print("付了\(amount) 剩下\(self.money)元")
        }
    }
    
    deinit {
        print("wallet bye bye")
    }
}

var wallet: Wallet? = Wallet()
wallet?.buySomething(20)
var buySomething = wallet?.buySomething
wallet?.buySomething2(30)
wallet?.money = 200
wallet?.buySomething2(30)
wallet?.buyLatter(amount: 50)
wallet = nil
//如果設為unowned的話、不把buySomethin也設為nil會有error
//buySomething = nil
buySomething?(30)

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

//: [Next](@next)
