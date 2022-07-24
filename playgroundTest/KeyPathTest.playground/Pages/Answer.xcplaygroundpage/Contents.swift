//: [Previous](@previous)

import Foundation

//【ChaoCode】 Swift 中級篇 8：KeyPath 實作作業
//: 1. 在 Array 的 extension 中寫一個能把所有資料的某個 Double 屬性加總後算出平均值的方法。
extension Array {
    func Average(_ path: KeyPath<Element, Double>) -> Double {
        let value = reduce(0) { $0 + $1[keyPath: path] }
        let count = Double(self.count)
        return value / count
    }
}

print([5, 7].Average(\.self))
// ✨ 以下測試請自行完成，前面是 Array，然後是要計算哪個屬性的平均，最後 == 後面是預期結果，你只需要把中間文字的部分改成你設計的方法並放入 keyPath，然後確認兩邊相比結果是 true 即可
public struct 長度單位 {
    public var 公尺: Double
    
    public var 公分: Double { 公尺 * 100 }
    public var 公里: Double { 公尺 / 1000 }
    
    public init(m: Double) { 公尺 = m }
}

[100, 60, 5.0].Average(\.self) == 55 // 這個就是平均數字本身
[長度單位(m: 3), 長度單位(m: 0.23), 長度單位(m: 935), 長度單位(m: 1130)].Average(\.公尺) ==  517.0575
[長度單位(m: 23), 長度單位(m: 32.311), 長度單位(m: 935), 長度單位(m: 113.0)].Average(\.公分) == 27582.775
 [長度單位(m: 9), 長度單位(m: 12321), 長度單位(m: 935), 長度單位(m: 1.130)].Average(\.公里) == 3.3165325


/*: 2. 在 Sequence 的 extension 中寫一個透過某個屬性分類後回傳字典的方法。
 ```
 假設一筆資料是 [(name: "小芳", 性別: "女"), (name: "偉偉", 性別: "男"), (name: "芯宜", 性別: "女")]
 這筆資料用「性別」分類的話，回傳的字典結果就會是
 ["女": [(name: "小芳", 性別: "女"), (name: "芯宜", 性別: "女")], "男": [(name: "偉偉", 性別: "男")]]
 ```
 */
struct People {
    let name: String
    let 性別: String
}

let peoples = [People(name: "小芳", 性別: "女"), People(name: "偉偉", 性別: "男"), People(name: "芯宜", 性別: "女")]

extension Sequence {
    func groupBy<T: Hashable>(_ path:KeyPath<Element, T>) -> [T:[Element]] {
        var categories: [T: [Element]] = [:]
//        for element in self {
//            let key = element[keyPath: path]
//            if case nil = categories[key]?.append(element) {
//                categories[key] = [element]
//            }
//        }
        self.forEach {
            categories[$0[keyPath: path], default: []].append($0)
        }
        return categories
    }
}
print(peoples.groupBy(\.性別))

public typealias 電影 = (名稱: String, 類型: String)

public struct 花費 {
    public var 名稱: String
    public var 費用: Double
    public var 類別: 類別
    public var 付款方式: 付款方式
    
}

extension 花費 {
    public enum 類別: String, CustomStringConvertible {
        case 食, 娛樂, 帳單, 購物, 社交
        public var description: String { rawValue }
    }
    
    public enum 付款方式: String, CustomStringConvertible {
        case 現金, 全額刷卡, 全額分期
        public var description: String { rawValue }
    }
}

// 👆 資料類型宣告到這邊，後面都只是測試用的～

extension 花費: CustomStringConvertible, Hashable {
    public var description: String { "[\(self.類別)] \(名稱) - $\(費用) (\(self.付款方式))" }
}


public let spends: Set<花費> = [花費(名稱: "電費", 費用: 1590, 類別: .帳單, 付款方式: .全額刷卡), 花費(名稱: "PS5", 費用: 15000, 類別: .娛樂, 付款方式: .全額刷卡), 花費(名稱: "老闆禮物", 費用: 3500, 類別: .社交, 付款方式: .全額刷卡), 花費(名稱: "除濕機", 費用: 2966, 類別: .購物, 付款方式: .全額分期), 花費(名稱: "麥當勞", 費用: 168, 類別: .食, 付款方式: .現金), 花費(名稱: "全聯", 費用: 789, 類別: .食, 付款方式: .現金), 花費(名稱: "中秋禮盒", 費用:4800 , 類別: .社交, 付款方式: .全額刷卡), 花費(名稱: "電影", 費用: 400, 類別: .娛樂, 付款方式: .全額刷卡), 花費(名稱: "顯卡", 費用: 5900, 類別: .購物, 付款方式: .全額分期), 花費(名稱: "網路費", 費用: 900, 類別: .帳單, 付款方式: .全額刷卡), 花費(名稱: "手機費", 費用: 599, 類別: .帳單, 付款方式: .全額刷卡)]


public let movies: [電影] = [("奇異博士2：失控多重宇宙", "動作"),("北方人", "劇情"),("空氣殺人", "劇情"),("怪獸與鄧不利多的秘密","奇幻"),("媽的多重宇宙", "喜劇"),("死亡預報", "懸疑"),("失落謎城", "喜劇"),("超吉任務", "喜劇"),("壞蛋聯盟", "動畫"),("捍衛戰士：獨行俠", "動作"),("終極夜路", "動作")]


public func print<Key: Hashable, Value>(_ dict: Dictionary<Key, [Value]>) {
    dict.forEach { (key, value) in
        print("\(key) 內有：")
        value.forEach { print("\t \($0)") }
    }
    print("-------------------")
}

// ✨ 請使用以下兩個變數進行分類，並印出回傳的字典。
// spends 請分別印出用「付款方式」和用「類別」分類的方式
spends
print(spends.groupBy(\.付款方式))
print("======")
print(spends.groupBy(\.類別))
print("======")
//print(spends.groupBy(\.類別))
// movies 請用「類型」分類
movies
print(movies.groupBy(\.類型))

/*:
 ### 概念答案
- 怎麼透過 KeyPath 存取資料？
 ```
 透過下標存取。 object[keyPath: KeyPath]
 ```
- KeyPath Literal 如何辨別 KeyPath 和 Writable KeyPath？
 ```
 如果類型中，屬性被用 var 定義就會是「Writable KeyPath」，如果是 let 就會是「KeyPath」。
 ```
- 要把 KeyPath 當作引數傳進需要 Closure 的參數要注意什麼？
 ```
 Closure 要是 (Root) -> Value，並且必須用 KeyPath literal 的方式寫才能自動被轉換。
 ```
- 除了簡化語法以外，還有什麼時候用 KeyPath 比 Clousre 更好？
 ```
 當不應該有和屬性互動以外的操作時，用 KeyPath 可以確保被呼叫時不會有額外的事件。
 ```
 */


//: [Next](@next)
