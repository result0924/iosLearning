//: [Previous](@previous)

import Foundation

// 對呼叫端隱藏類型的例子

protocol 有交友資料: Equatable {
    var 名字: String { get }
    var 自我介紹: String { get }
}

struct 會員: 有交友資料 {
    enum 會員類型 { case 普通會員, 享樂會員, 尊勞會員 }
    
    // 交友資料
    var 名字: String
    var 自我介紹: String = ""
    
    // 帳戶資訊
    var 帳號: String = ""
    var 手機: String = ""
    var 生日: Date = .now
    var 會員類型: 會員類型 = .普通會員
    
    // 活動數值
    var 回應率: Double = 0
    var 熱門度: Double = 0
    
    // 交友操作
    func 產生每日配對() -> 會員 {
        return 會員(名字: "Tom")
    }
    
    func 發訊息(給 person: 會員, _ message: String) {
        print("\(名字)　對　\(person.名字) 說：\(message)")
    }
    
    func 產生每日配對2() -> some 有交友資料 {
        return 會員(名字: "Tom")
    }

    func 發訊息2<T: 有交友資料>(給 person: T, _ message: String) {
        print("\(名字)　對　\(person.名字) 說：\(message)")
    }
    
}

let user = 會員(名字: "Jane")
// 拿到配對不應該取得對象的個資
let match = user.產生每日配對()
user.發訊息(給: match, "Hello")

let match2 = user.產生每日配對2()
user.發訊息2(給: match2, "Hello")
//: [Next](@next)
