import UIKit

// 屬性觀察 (Property Observers) 是 Swift 中一個很特殊的特性，
// 利用屬性觀察我們可以在當前類型內監視對於屬性的設定，並作出一些響應。
// Swift 中為我們提供了兩個屬性觀察的方法，它們分別 是 willSet 和 didSet 。
// 使用這兩個方法十分簡單，我們只要在屬性聲明的時候添加相應的代碼塊，
// 就可以對將要設定的值和已經設置的值進行監聽了:

class MyClass {
    var date: NSDate {
        willSet {
            let d = date
            print("即將將日期從 \(d) 設定至 \(newValue)")
        }
        
        didSet {
            print("已經將日期從 \(oldValue) 設定至 \(date)")
        }
    }
    
    init() {
        date = NSDate()
    }
}

let foo = MyClass()
foo.date = foo.date.addingTimeInterval(10086)

// 在 willSet 和 didSet 中我們分別可以使用 newValue 和 oldValue 來獲取將要設定的和已經設定的值。
// 屬性觀察的一個重要用處是作為設置值的驗證，比如上面的例子中我們不希望 date 超過當前時間的一年以上的話，
// 我們可以將 didSet 修改一下:

class MyClass2 {
    let oneYearInSecond: TimeInterval = 365 * 24 * 60 * 60
    var date: NSDate {
        willSet {
            let d = date
            print("即將將日期從 \(d) 設定至 \(newValue)")
        }
        
        didSet {
            if date.timeIntervalSinceNow > oneYearInSecond {
                print("設定的時間太晚了")
                date = NSDate().addingTimeInterval(oneYearInSecond)
            }
            print("已經將日期從 \(oldValue) 設定至 \(date)")
        }
    }
    
    init() {
        date = NSDate()
    }
}

// 365 * 24 * 60 * 60 = 31536000
let foo2 = MyClass2()
foo2.date = foo2.date.addingTimeInterval(100000000)

// 我們知道，在 Swift 中所聲明的屬性包括存儲屬性和計算屬性兩種。
// 其中存儲屬性將會在內存中實際分配地址對屬性進行存儲，而計算屬性則不包括背後的存儲，
// 只是提供 set 和 get 兩種方法。在同一個類型中，屬性觀察和計算屬性是不能同時共存的。
// 也就是說，想在一個屬性定義中同時出現 set 和 willSet 或 didSet 是一件辦不到的事情。
// 計算屬性中我們可以通過改寫 set 中的內容來達到和 willSet 及 didSet 同樣的屬性觀察的目的。
// 如果我們無法改動這個類，又想要通過屬性觀察做一些事情的話，可能就需要子類化這個類，並且重寫它的屬性了。
// 重寫的屬性並不知道父類屬性的具體實現情況，而只從父類屬性中繼承名字和類型，
// 因此在子類的重載屬性中我們是可以對父類的屬性任意地添加屬性觀察的，而不用在意父類中到底是存儲屬性還是計算屬性:

class A {
    var number: Int {
        get {
            print("get")
            return 1
        }
        set {print("set")}
    }
}

class B: A {
    override var number: Int {
        willSet {print("will set")}
        didSet {print("did set")}
    }
}

let b = B()
b.number = 0

// set 和對應的屬性觀察的調用都在我們的預想之中。這裡要注意的是 get 首先被調用了一次。
// 這是因為我們實現了 didSet ， didSet 中會用到 oldValue ，而這個值需要在整個 set 動作之前進行獲取並存儲待用，
// 否則將無法確保正確性。如果我們不實現 didSet 的話，這次 get 操作也將不存在。

class ClassDog {
   var name: String
   init(name: String) {
      self.name = name
   }
}

struct StructDog {
   var name: String
}

struct Baby {
    var structDog = StructDog(name: "史努比") {
        didSet {
            print("struct 小狗變了")
        }
    }
    
    var classDog = ClassDog(name: "史努比2") {
        didSet {
            print("class 小狗變了")
        }
    }
}
var cuteBaby = Baby()

// cuteBaby.dog.name = "布丁狗" 將觸發 didSet，
// 因為 Dog 是 value type，所以設定 Dog 的任何一個 property 都代表 property dog 改變了。
cuteBaby.structDog.name = "布丁狗"

// didSet 不會觸發。
// 因為 Dog 是 reference type，所以 cuteBaby.dog 儲存的是小狗物件的記憶體位置，
// cuteBaby.classDog.name = "布丁狗" 改變的是 小狗物件的 name，而不是寶寶物件的 dog。
cuteBaby.classDog.name = "布丁狗"


// Final

// final 關鍵字可以用在 class ， func 或者 var 前面進行修飾，
// 表示不允許對該內容進行繼承或者重寫操作。這個關鍵字的作用和 C# 中的 sealed 相同，
// 而 sealed 其實在 C# 算是一個飽受爭議的關鍵字。有一派程序員認為，類似這樣的禁止繼承和重寫的做法是非常有益的，
// 它可以更好地對代碼進行版本控制，得到更佳的性能，以及使代碼更安全。因此他們甚至認為語言應當是默認不允許繼承的，
// 只有在顯式地指明可以繼承的時候才能子類化。
// 在這裡我不打算對這樣的想法做出判斷或者評價，雖然上面列舉的優點都是事實，但是另一個事實是不論是Apple或者微軟，
// 以及世界上很多其他語言都沒有作出默認不讓繼承和重寫的決定。帶著“這不是一個可以濫用的特性”的觀點，我們來看看在寫 Swift 的時候可能會在什麼情況下使用final。

// 權限控制
// 給一段代碼加上final就意味著編譯器向你作出保證，這段代碼不會再被修改;
// 同時，這也意味著你認為這段代碼已經完備並且沒有再被進行繼承或重寫的必要，因此這往往會是一個需要深思熟慮的決定。
// 在Cocoa 開發中app開發是一塊很大的內容，對於大多數我們自己完成的面向app開發代碼，
// 其實不太會提供給別人使用，這種情況下即使是將所有自己寫的代碼標記為final 都是一件無可厚非的事情(但我並不是在鼓勵這麼做)
// 因為在需要的任何時候你都可以將這個關鍵字去掉以恢復其可繼承性。而在開發給其他開發者使用的庫時，
// 就必須更深入地考慮各種使用場景和需求了。
// 一般來說，不希望被繼承和重寫會有這幾種情況:

// 1. 類或者方法的功能確實已經完備了
// 對於很多的輔助性質的工具類或者方法，可能我們會考慮加上 final 。
// 這樣的類有一個比較大的特點，是很可能只包含類方法而沒有實例方法。
// 比如我們很難想到一種情況需要繼承或重寫一個負責計算一段字符串的 MD5 或者 AES加密解密的工具類。
// 這種工具類和方法的算法是經過完備驗證和固定的，使用者只需要調用，而相對來說不可能有繼承和重寫的需求。
// 這種情況很多時候遵循的是以往經驗和主觀判斷，而單個的開發者的判斷其實往往並不可靠。
// 遇到希望把某個自己開發的類或者方法標為 final 的時候，去找幾個富有經驗的開發者，
// 問問他們 的意⻅或者看法，應該是一個比較靠譜的做法。

// 2. 子類繼承和修改是一件危險的事情
// 在子類繼承或重寫某些方法後可能做一些破壞性的事情，導致子類或者父類部分也無法正常工作的情況。
// 舉個例子，在某個公司管理的系統中我們對員工按照一定規則進行編號，這樣通過編號我們能迅速找到任一員工。
// 而假如我們在子類中重寫了這個編號方法，很可能就導致基類中的依賴員工編號的方法失效。在這類情況下，
// 將編號方法標記為 final 以確保穩定，可能是一種更好的做法。

// 3. 為了父類中某些代碼一定會被執行
// 有時候父類中有一些關鍵代碼是在被繼承重寫後必須執行的 (比如狀態配置，認證等等)，否則將導致運行時候的錯誤。
// 而在一般的方法中，如果子類重寫了父類方法，是沒有辦法強制子類方法 一定去調用相同的父類方法的。
// 在 Objective-C 的時候我們可以通過指定
// __attribute__((objc_requires_super))這樣的屬性來讓編譯器在子類沒有調用父類方法時拋出警告。
// 在Swift 中對原來的很多attribute 的支持現在還缺失中，為了達到類似的目的，
// 我們可以使用一個 final 的方法，在其中進行一些必要的配置，然後再調用某個需要子類實現的方法，以確保正常運行:

class Parent {
    final func method() {
        print("開始配置")
        methodImpl()
        print("結束配置")
    }
    
    func methodImpl() {
        fatalError("子類必須實做這個方法")
    }
}

class Child: Parent {
    override func methodImpl() {
        print("不實做會crash")
    }
}

let child = Child()
child.method()

//　這樣，無論如何我們如何使用 method ，都可以保證需要的代碼一定被運行過，而同時又給了子類繼承和重寫自定義具體實現的機會。

// ４. 性能考慮
// 使用 final 的另一個重要理由是可能帶來的性能改善。因為編譯器能夠從 final 中獲取額外的信息，
// 因此可以對類或者方法調用進行額外的優化處理。但是這個優勢在實際表現中可能帶來的好處
// 其實就算與Objective-C的動態派發相比也十分有限，
// 因此在項目還有其他方面可以優化(一般來說會是算法或者圖形相關的內容導致性能瓶頸)的情況下，
// 並不建議使用將類或者方法轉為final 的方式來追求性能的提升。
