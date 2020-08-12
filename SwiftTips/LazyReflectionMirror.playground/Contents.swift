import UIKit

// 延時加載或者說延時初始化是很常用的優化方法，在構建和生成新的對象的時候，
// 內存分配會在運行時耗費不少時間，如果有一些對象的屬性和內容非常複雜的話，這個時間更是不可忽略。
// 另外，有些情況下我們並不會立即用到一個對象的所有屬性，而默認情況下初始化時，
// 那些在特定環境下不被使用的存儲屬性，也一樣要被初始化和賦值，也是一種浪費。

// 在其他語言 (包括 Objective-C) 中延時加載的情況是很常見的。
// 我們在第一次訪問某個屬性時，判斷這個屬性背後的存儲是否已經存在，如果存在則直接返回，
// 如果不存在則說明是首次訪問，那麼就進行初始化並存儲後再返回。
// 這樣我們可以把這個屬性的初始化時刻推遲，與包含它的對象 的初始化時刻分開，以達到提升性能的目的。
// 以 Objective-C 舉個例子 (雖然這裡既沒有費時操作，也不會因為使用延時加載而造成什麼性能影響，
// 但是作為一個最簡單的例子，可以很好地說 明問題):

class ClassA {
    lazy var str: String = {
        let str = "Hello"
        print("只在首次訪問輸出")
        return str
    }()
    
    // 我們在使用 lazy 作為屬性修飾符時，只能聲明屬性是變量。另外我們需要顯式地指定屬性類型，
    // 並使用一個可以對這個屬性進行賦值的語句來在首次訪問屬性時運行。
    // 如果我們多次訪問這個實例的 str 屬性的話，可以看到只有一次輸出。
    // 為了簡化，我們如果不需要做什麼額外工作的話，也可以對這個 lazy 的屬性直接寫賦值語句:
    lazy var str2: String = "Hello2"
}

let a = ClassA()
a.str
a.str = "aaa"
a.str
a.str2

// 相比起在 Objective-C 中的實現方法，現在的 lazy 使用起來要方便得多。
// 另外一個不太引起注意的是，在 Swift 的標準庫中，我們還有一組 lazy 方法，它們的定義是這樣的:

//func lazy<S : SequenceType>(s: S) -> LazySequence<S>
//func lazy<S : CollectionType where S.Index : RandomAccessIndexType>(s: S)
//-> LazyRandomAccessCollection<S>
//func lazy<S : CollectionType where S.Index : BidirectionalIndexType>(s: S) -> LazyBidirectionalCollection<S>
//func lazy<S : CollectionType where S.Index : ForwardIndexType>(s: S) -> LazyForwardCollection<S>

// 這些方法可以配合像 map 或是 filter 這類接受閉包並進行運行的方法一起，
// 讓整個行為變成延時進行的。在某些情況下這麼做也對性能會有不小的幫助。例如，直接使用 map 時:

let data = 1...3
let result = data.map { (i) -> Int in
    print("正在處理\(i)")
    return i * 2
}

print("準備訪問結果")

for i in result {
    print("操作後結果為\(i)")
}

print("操作完畢")

//　而如果我們先進行一次 lazy 操作的話，我們就能得到延時運行版本的容器:
print("============\n")
let data2 = 1...3
let result2 = data2.lazy.map { (i) -> Int in
    print("正在處理\(i)")
    return i * 2
}

print("準備訪問結果")

for i in result2 {
    print("操作後結果為\(i)")
}

print("操作完畢")

// 對於那些不需要完全運行，可能提前退出的情況，使用 lazy 來進行性能優化效果會非常有效。
