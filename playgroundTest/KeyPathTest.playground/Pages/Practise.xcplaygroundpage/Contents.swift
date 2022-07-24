//: [Previous](@previous)

//【ChaoCode】 Swift 中級篇 8：KeyPath 實作作業
//: 1. 在 Array 的 extension 中寫一個能把所有資料的某個 Double 屬性加總後算出平均值的方法。
extension Array {
    
}

// ✨ 以下測試請自行完成，前面是 Array，然後是要計算哪個屬性的平均，最後 == 後面是預期結果，你只需要把中間文字的部分改成你設計的方法並放入 keyPath，然後確認兩邊相比結果是 true 即可

// [100, 60, 5.0] 平均 == 55 // 這個就是平均數字本身
// [長度單位(m: 3), 長度單位(m: 0.23), 長度單位(m: 935), 長度單位(m: 1130)] 公尺屬性平均 ==  517.0575
// [長度單位(m: 23), 長度單位(m: 32.311), 長度單位(m: 935), 長度單位(m: 113.0)] 公分屬性平均 == 27582.775
// [長度單位(m: 9), 長度單位(m: 12321), 長度單位(m: 935), 長度單位(m: 1.130)] 公里屬性平均 == 3.3165325


/*: 2. 在 Sequence 的 extension 中寫一個透過某個屬性分類後回傳字典的方法。
 ```
 假設一筆資料是 [(name: "小芳", 性別: "女"), (name: "偉偉", 性別: "男"), (name: "芯宜", 性別: "女")]
 這筆資料用「性別」分類的話，回傳的字典結果就會是
 ["女": [(name: "小芳", 性別: "女"), (name: "芯宜", 性別: "女")], "男": [(name: "偉偉", 性別: "男")]]
 ```
 */
extension Sequence {
    
}

// ✨ 請使用以下兩個變數進行分類，並印出回傳的字典。
// spends 請分別印出用「付款方式」和用「類別」分類的方式
spends

// movies 請用「類型」分類
movies


public typealias 電影 = (名稱: String, 類型: String)

public struct 長度單位 {
    public var 公尺: Double
    
    public var 公分: Double { 公尺 * 100 }
    public var 公里: Double { 公尺 / 1000 }
    
    public init(m: Double) { 公尺 = m }
}

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

//: [Next](@next)
