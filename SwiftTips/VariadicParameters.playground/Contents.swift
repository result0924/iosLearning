import UIKit

// 可變參數函數指的是可以接受任意多個參數的函數，
// 我們最熟悉的可能就是 NSString 的 - stringWithFormat: 方法了。
// 在 Objective-C 中，我們使用這個方法生成字符串的寫法是這樣的:

// NSString *name = @"Tom";
// NSDate *date = [NSDate date];
// NSString *string = [NSString stringWithFormat:@"Hello %@. Date: %@", name, date];

// 這個方法中的參數是可以任意變化的，參數的第一項是需要格式化的字符串，
// 後面的參數都是向第一個參數中填空。在這裡我們不再詳細描述
// Objective-C中可變參數函數的寫法(畢竟這是一本Swift的書)，
// 但是我相信絕大多數即使有著幾年Objective-C經驗的讀者，
// 也很難在不查閱資料的前提下正確寫出一個接受可變參數的函數。
// 但是這一切在 Swift 中得到了前所未有的簡化。
// 現在，寫一個可變參數的函數只需要在聲明參數時 在類型後面加上 ...就可以了。
// 比如下面就聲明了一個接受可變參數的 Int 累加函數
// 輸入的 input 在函數體內部將被作為數組 [Int] 來使用，
// 讓我們來完成上面的方法吧。當然你可以用傳統的 for...in 做累加，
// 但是這裡我們選擇了一種看起來更 Swift 的方式:

func sum(input: Int...) -> Int {
    return input.reduce(0, +)
}

print(sum(input: 1,2,3,4,5))

// Swift的可變參數十分靈活，在其他很多語言中，因為編譯器和語言自身語法特性的限制，
// 在使用可變參數時往往可變參數只能作為方法中的最後一個參數來使用，而不能先聲明一個可變參數，
// 然後再聲明其他參數。這是很容易理解的，因為編譯器將不知道輸入的參數應該從哪裡截斷。
// 這個限制在 Swift 中是不存在的，因為我們會對方法的參數進行命名，
// 所以我們可以隨意地放置可變參數的位置，而不必拘泥於最後一個參數:

func myFunc(number: Int..., string: String) {
    number.forEach {
        for i in 0 ..< $0 {
            print("\(i + 1): \(string)")
        }
    }
}

myFunc(number: 1, 2, 3, string: "hello")

// 限制自然是有的，比如在同一個方法中只能有一個參數是可變的，
// 比如可變參數都必須是同一種類型的等。對於後一個限制，
// 當我們想要同時傳入多個類型的參數時就需要做一些變通。
// 比如最開始提到的 -stringWithFormat: 方法。可變參數列表的第一個元素是等待格式化的字符串，
// 在 Swift 中這會對應一個 String 類型，而剩下的參數應該可以是對應格式化標準的任意類型。
// 一種解決方法是使用 Any 作為參數類型，然後對接收到的數組的首個元素進行特殊處理。
// 不過因為 Swift 提供了使用下劃線 _ 來作為參數的外部標籤，來使調用時不再需要加上參數名字。
// 我們可以利用這個特性，在聲明方法時就指定第一個參數為一個字符串，
// 然後跟一個匿名的參數列表， 這樣在寫起來的時候就"好像"是所有參數都是在同一個參數列表中進行的處理，
// 會好看很多。比如 Swift 的 NSString 格式化的聲明就是這樣處理的:

// extension NSString {
//     convenience init(format: NSString, _ args: CVarArg...)
//     //...
// }

// 調用的時候就和在 Objective-C 時幾乎一樣了，非常方便:
let name = "Tom"
let date = NSDate()
let string = NSString(format: "Hello %@. Date: %@", name, date)
