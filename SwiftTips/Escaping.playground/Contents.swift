import UIKit

// Swift 的語法⾮常適合函數式編程的使⽤，⽽閉包 (closure) 正是函數式編程的核⼼概念之⼀。
// Swift 中我們可以定義⼀個接受函數作為參數的函數，⽽在調⽤時，使⽤閉包的⽅式來傳遞這個參
// 數是常⻅⼿段：

func doWork(block: () -> ()) {
    block()
}

doWork {
    print("work")
}

// 這種最簡單的形式的閉包其實還默認隱藏了⼀個假設，那就是參數中 block 的內容會在 doWork
// 返回前就完成。也就是說，對於 block 的調⽤是同步⾏為。如果我們改變⼀下代碼，將 block 放
// 到⼀個 Dispatch 中去，讓它在 doWork 返回後被調⽤的話，我們就需要在 block 的類型前加上
// @escaping 標記來表明這個閉包是會“逃逸”出該⽅法的：

func doWorkAsync(block: @escaping ()->()) {
    DispatchQueue.main.async {
        block()
    }
}

// 在使⽤閉包調⽤這個兩個⽅法時，也會有⼀些⾏為的不同。我們知道，閉包是可以捕獲其中的變
// 量的。對於 doWork 參數⾥這樣的沒有逃逸⾏為的閉包，因為閉包的作⽤域不會超過函數本身，所
// 以我們不需要擔⼼在閉包內持有 self 等。 ⽽接受 @escaping 的 doWorkAsync 則有所不同。由於需
// 要確保閉包內的成員依然有效，如果在閉包內引⽤了 self 及其成員的話，Swift 將強制我們明確
// 地寫出 self 。對⽐下⾯的兩個⽤例的不同之處：

class S {
    var foo = "foo"

    func method1() {
        print(foo)
        foo = "bar"
    }

    func method2() {
        doWorkAsync {
            print(self.foo)
        }
        foo = "bar2"
    }

    func method3() {
        doWorkAsync {
            [weak self] in
            print(self?.foo ?? "nil")
        }

        foo = "bar3"
    }
}

S().method1()
S().method2()

// 顯然， method1 中調⽤者不需要考慮 self.foo 的持有情況，使⽤起來相當直接。對 foo 的打印
// 輸出的是原始值 foo 。 ⽽ method2 中由於閉包可逃逸，Swift 強制我們寫明 self ，以起到提醒作
// ⽤，我們就需要考慮 self 的持有情況。在這個例⼦中，我們讓閉包持有了 self ，打印的值是
// method2 最後對 foo 賦值後的內容 bar 。如果我們不希望在閉包中持有 self ，
// 可以使⽤ [weak self] 的⽅式來表達：

S().method3()
