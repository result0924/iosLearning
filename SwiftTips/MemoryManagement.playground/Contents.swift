import UIKit

// 不管在什麼語言裡，內存管理的內容都很重要，所以我打算花上比其他 tip 長一些的篇幅仔細地說說這塊內容。
// Swift 是自動管理內存的，這也就是說，我們不再需要操心內存的申請和分配。
// 當我們通過初始化 創建一個對象時，Swift 會替我們管理和分配內存。
// 而釋放的原則遵循了自動引用計數 (ARC) 的規則:當一個對像沒有引用的時候，其內存將會被自動回收。
// 這套機制從很大程度上簡化了我們的編碼，我們只需要保證在合適的時候將引用置空
// (比如超過作用域，或者手動設為 nil 等)，就可 以確保內存使用不出現問題。
// 但是，所有的自動引用計數機制都有一個從理論上無法繞過的限制，那就是循環引用 (retain cycle) 的情況。

// 什麼是循環引用
// 雖然我覺得循環引用這樣的概念介紹不太應該出現在這本書中，
// 但是為了更清晰地解釋 Swift 中的循環引用的一般情況，這裡還是簡單進行說明。
// 假設我們有兩個類 A 和 B ， 它們之中分別有一個存儲屬性持有對方:

class A: NSObject {
    let b: B
    override init() {
        b = B()
        super.init()
        b.a = self
    }
    
    deinit {
        print("A deinit")
    }
}

class B: NSObject {
    var a: A? = nil
    
    deinit {
        print("B deinit")
    }
}

// 在 A 的初始化方法中，我們生成了一個 B 的實例並將其存儲在屬性中。然後我們又將 A 的實例賦值給了 b.a 。
// 這樣 a.b 和 b.a 將在初始化的時候形成一個引用循環。現在當有第三方的調用初始化了 A ，
// 然後即使立即將其釋放， A 和 B 兩個類實例的 deinit 方法也不會被調用，說明它們並沒有被釋放。

var obj: A? = A()
obj = nil
// not show `A deinit` so not release

// 因為即使 obj 不再持有 A 的這個對象，b 中的 b.a 依然引用著這個對象，
// 導致它無法釋放。而進一步，a 中也持有著 b，導致 b 也無法釋放。
// 在將 obj 設為 nil 之後，我們在代碼裡再也拿不到對於這個對象的引用了，
// 所以除非是殺掉整個進程，我們已經永遠也無法將它釋放了。多麼悲傷的故事啊..

// 在 Swift 裡防止循環引用
// 為了防止這種人神共憤的悲劇的發生，我們必須給編譯器一點提示，表明我們不希望它們互相持有。
// 一般來說我們習慣希望 "被動" 的一方不要去持有 "主動" 的一方。
// 在這裡 b.a 裡對 A 的實例的持有是由 A 的方法設定的，我們在之後直接使用的也是 A 的實例，
// 因此認為 b 是被動的一方。可以將上面的 class B 的聲明改為:

class A2: NSObject {
    let b: B2
    override init() {
        b = B2()
        super.init()
        b.a = self
    }
    
    deinit {
        print("A2 deinit")
    }
}

class B2: NSObject {
    weak var a: A2? = nil
    
    deinit {
        print("B2 deinit")
    }
}

var obj2: A2? = A2()
obj2 = nil
// show `A2 deinit` `B2 deini` so release

// 在 var a 前面加上了 weak ，向編譯器說明我們不希望持有 a。這時，
// 當 obj 指向 nil 時，整個環境中就沒有對 A 的這個實例的持有了，於是這個實例可以得到釋放。
// 接著，這個被釋放的實例上對 b 的引用 a.b 也隨著這次釋放結束了作用域，所以 b 的引用也將歸零，得到釋放。

// 可能有心的朋友已經註意到，在 Swift 中除了 weak 以外，還有另一個衝著編譯器叫喊著類似的 "不要引用我" 的標識符，
// 那就是 unowned 。它們的區別在哪裡呢?如果您是一直寫 Objective-C 過 來的，
// 那麼從表面的行為上來說 unowned 更像以前的 unsafe_unretained ，而 weak 就是以前的 weak 。
// 用通俗的話說，就是unowned 設置以後即使它原來引用的內容已經被釋放了，
// 它仍然會保持對被已經釋放了的對象的一個"無效的" 引用，它不能是Optional 值，也不會被指向nil 。
// 如果你嘗試調用這個引用的方法或者訪問成員屬性的話，程序就會崩潰。
// 而 weak 則友好一些，在引 用的內容被釋放後，標記為 weak 的成員將會自動地變成 nil
// (因此被標記為 @ weak 的變量一定 需要是 Optional 值)。
// 關於兩者使用的選擇，Apple 給我們的建議是如果能夠確定在訪問時不會已被釋放的話，
// 盡量使用 unowned ，如果存在被釋放的可能，那就選擇用 weak 。

// 我們結合實際編碼中的使用來看看選擇吧。日常工作中一般使用弱引用的最常見的場景有兩個:
// 1. 設置 delegate 時
// 2. 在 self 屬性存儲為閉包時，其中擁有對 self 引用時

// maybe you can refer
// https://medium.com/flawless-app-stories/you-dont-always-need-weak-self-a778bec505ef
