import UIKit

// 想想看有多少次我們因為⼀個⽅法主體內容過⻓，⽽不得不將它重構為好幾個⼩的功能塊的⽅法，
// 然後在原來的主體⽅法中去調⽤這些⼩⽅法。這些具體負責⼀個個⼩功能塊的⽅法也許⼀輩⼦就被調⽤這麼⼀次，
//　但是卻不得不存在於整個類型的作⽤域中。雖然我們會將它們標記為私有⽅法，
//　但是事實上它們所承擔的任務往往和這個類型沒有直接關係，⽽只是會在這個類型中的某個⽅法中被⽤到。
//　更甚⾄這些⼩⽅法也可能有些複雜，我們還想進⼀步將它們分成更⼩的模塊，
//　我們很可能也只有將它們放到和其他⽅法平級的地⽅。這樣⼀來，本來應該是進深的結構，卻被整個展平了，
//　導致之後在對代碼的理解和維護上都很成問題。在 Swift 中，我們對於這種情況有了很好的應對，
//　我們可以在⽅法中定義其他⽅法，也就是說讓⽅法嵌套起來。

func appendQuery(url: String,
                 key: String,
                 value: Any) -> String {
    
    func appendQueryDictionary(url: String,
                               key: String,
                               value: [String: Any]) -> String {
        return "value is [String: AnyObject]"
    }
    
    func appendQueryArray(url: String,
                          key: String,
                          value: [Any]) -> String {
        return "value is [AnyObject]"
    }
    
    func appendQuerySingle(url: String,
                           key: String,
                           value: Any) -> String {
        return "value is AnyObject"
    }
    
    if let dictionary = value as? [String: AnyObject] {
        return appendQueryDictionary(url: url, key: key, value: dictionary)
    } else if let array = value as? [AnyObject] {
        return appendQueryArray(url: url, key: key, value: array)
    } else {
        return appendQuerySingle(url: url, key: key, value: value)
    }
}

appendQuery(url: "123", key: "456", value: ["123": "456"])
appendQuery(url: "123", key: "456", value: ["456"])
appendQuery(url: "123", key: "456", value: "456")

// 另⼀個重要的考慮是雖然 Swift 提供了不同的訪問權限，但是有些⽅法我們完全不希望在其他地⽅
// 被直接使⽤。最常見的例⼦就是在⽅法的模板中：我們⼀⽅⾯希望靈活地提供⼀個模板來讓使⽤
// 者可以通過模板定制他們想要的⽅法，但另⼀⽅⾯⼜不希望暴露太多實現細節，或者甚⾄是讓使
// ⽤者可以直接調⽤到模板。⼀個最簡單的例⼦就是在參數修飾⼀節中提到過的類似這樣的代碼：

func makeIncrementor(addNumber: Int) -> (_ variable: inout Int) -> Void {
    func incrementor(variable: inout Int) -> Void {
        variable += addNumber;
    }
    return incrementor;
}

var luckyNumber = 7
makeIncrementor(addNumber: 7)(&luckyNumber)
