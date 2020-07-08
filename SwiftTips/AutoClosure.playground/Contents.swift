import UIKit

// @autoclosure 做的事情就是把一句表達式，自動封裝成一個閉包(closure)，
//　這樣有時候在語法上看起來就會非常漂亮

// 比如我們有一個方法接受一個閉包，當閉包執行結果為true的時候print("True")
func logIfTrue(_ predicate: () -> Bool) {
    if predicate() {
        print("True")
    }
}

// 在調用的時候我們需要寫這樣的代碼
logIfTrue({return 2 > 1})

// 當然在swift中對閉包的方法我們可以進行一些簡化，在這種情況下我們可以省略掉return
logIfTrue({ 2 > 1})

// 還可以更進一步，因為這個閉包是最後一個參數，所以可以使用尾隨閉包(trailing closure)的方式
// 把大括號拿出來，然後省略括號
logIfTrue{2 > 1}

// 但是不管那種方式，要嘛寫法來十分麻煩、要嘛表達上不太清，於是@autoclosure登場了
func logIfTrueAutoClosure(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("True")
    }
}

// 這時候我們可以直接寫
logIfTrueAutoClosure(2 > 1)

// @autoclosure並不⽀持攜帶輸⼊參數的寫法，也就是說只有形如（）
// 也就是說只有形如（）-> T的參數才能使它這個特性進⾏簡化。
// 另外，因為調用者往往很容易忽略@autoclosure這個特性，
// 所以在寫接受@autoclosure的⽅法時還請特別⼩⼼，如果在容易產⽣歧義或者誤解的時候，
// 還是使前端完整的閉包寫法會⽐更好

//@autoclosure 和普通的敘述式最大的差別就是，普通的敘述式在傳入參數時，就會馬上被執行，然後將執行後的值作為參數傳入函式中。而使用 @autoclosure 標注的閉包，雖然呼叫的時候還是傳入一個敘述，但是這個敘述並不會馬上被執行，而是在函式內才決定具體的執行時間。

// 使用@autoclosure的特性
//　1. 傳入的參數不一定會執行
//　2. 傳入的參數延後執行(Lazy Evaluation)
//　3. 可以和 `@escaping` 結合
//　4. 搭配的function型別必須沒有參數
