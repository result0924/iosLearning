import UIKit
//
// where 關鍵字在 Swift 中非常強大，但是往往容易被忽視。在這一節中，我們就來整理看看
// where 有哪些使用場合吧。
// 首先是 switch 語句中，我們可以使用 where 來限定某些條件 case:

let name = ["allen", "tim", "toys", "steven"]
name.forEach {
    switch $0 {
    case let x where x.hasPrefix("a"):
        print("\(x) is a prefix")
    default:
        print("hello \($0)")
    }
}

// 這可以說是模式匹配的標準用法，對 case 條件進行限定可以讓我們更靈活地使用 switch 語句。
// 在 for 中我們也可以使用 where 來做類似的條件限定:

let num: [Int?] = [44, 77, nil]
let n = num.compactMap{$0}
for score in n where score > 60 {
    print("your score \(score) is pass")
}

// 和 for 循環中類似，我們也可以對可選綁定進行條件限定。
// 不過在 Swift 3 中， if let 和 guard let 的條件不再使用 where 語句，
// 而是直接和普通的條件判斷一樣，用逗號寫在 if 或者 guard 的後面:

num.forEach {
    if let score = $0, score > 60 {
        print("Pass - \(score)")
    } else {
        print(":(")
    }
}

// indirect 和嵌套 enum
//　如果要表示一個列舉成員可以遞迴，必須在成員前面加上indirect

// 在涉及到一些數據結構的經典理論和模型 (沒錯，就是鏈表，樹和圖) 時，我們往往會用到嵌套的類型。
// 比如鏈表，在 Swift 中，我們可以這樣來定義一個單向鏈表:

class Node<T> {
    let value: T?
    let next: Node<T>?
    
    init(value: T?, next: Node<T>?) {
        self.value = value
        self.next = next
    }
}

let list = Node(value: 1, next: Node(value: 2, next: Node(value: 3, next: Node(value: 4, next: nil))))

// 看起來還不錯，但是這樣的形式在表達空節點的時候並不十分理想。
// 我們不得不借助於 nil 來表達空節點，但是事實上空節點和 nil並不是等價的。
// 另外，如果我們想表達一個空鏈表的話，要麼需要把list 設置為Optional，
// 要麼把Node 裡的value 以及next都設為nil，這導致描述中存在歧義，
// 我們不得不去做一些人為的約定來表述這樣的情況，這在算法描述中是十分致命的。
// 在 Swift 2 中，我們現在可以使用嵌套的 enum 了 -- 而這在 Swift 1.x 裡是編譯器所不允許的。
// 我們用 enum 來重新定義鏈表結構的話，會是下面這個樣子:

indirect enum LinkedList<Element: Comparable> {
    case empty
    case node(Element, LinkedList<Element>)
    
    func removing(_ element: Element) -> LinkedList<Element> {
        guard case let .node(value, next) = self else {
            return .empty
        }
        return value == element ? next : LinkedList.node(value, next.removing(element))
    }
}

let linkedList = LinkedList.node(1, .node(2, .node(3, .node(4, .empty))))

// 在 enum 的定義中嵌套自身對於 class 這樣的引用類型來說沒有任何問題，
// 但是對於像 struct 或者 enum 這樣的值類型來說，普通的做法是不可行的。
// 我們需要在定義前面加上 indirect 來提示編譯器不要直接在值類型中直接嵌套。
// 用 enum 表達鏈表的好處在於，我們可以清晰地表示出空節點這一定義，
// 這在像 Swift 這樣類型十分嚴格的語言中是很有幫助的。比如我們可以寥寥數行就輕易地實現鍊錶節點的刪除方法，
// 在 enum 中添加:

let result = linkedList.removing(2)
print(result)
