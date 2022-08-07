//: [Previous](@previous)

//【ChaoCode】 Swift 中級篇 20 Capture & Escaping 實作作業
import _Concurrency
import Foundation
// 1. 把 GymMemeber 中的 payBill 改成一個 closure 的屬性，並且讓月費價格固定於入會時的價格。（例如：如果入會時月費是 150，後面漲價也不受影響。
// 💡 真實情況只需要替每個會員設定一個自己的月費金額就好，不過這裡是為了練習 & 理解 Value Type 的 capture 情況～所以請用 closure 解決，不要修改其他地方。
struct GymMember {
    static var monthlyCost = 150
    let name: String
    
    func payBill() {
        print("會員 \(name) 自動扣款 \(GymMember.monthlyCost) 元訂閱費。")
    }
}

// 以下是測試，請勿修改
var member1 = GymMember(name: "賈伯斯")
member1.payBill()
print("漲價到每月 200 元。")
GymMember.monthlyCost = 200
var memeber2 = GymMember(name: "庫克")
member1.payBill()
memeber2.payBill()


print("---------------------------")

// 2. 修正以下兩個 schedule 的方法，兩者都是等待幾秒後執行 action，一個是同步的 、另一個是非同步的。
// ＊ 用 Task.sleep 等待，如果等待時報錯就直接 return。
// ＊ 宣告的地方也會需要修改，確保引數標籤一樣即可。
// ＊ action 可能是 async 的，也可能報錯，如果有報錯的話必須傳出來。

func schedule(after second: Double, action: () -> Void) {
    Task {
        try! await Task.sleep(seconds: second)
        action()
    }
}

func schedule(after second: Double, action: () -> Void) async  {
    try! await Task.sleep(seconds: second)
    action()
}


// 3. 以下是使用者和信用卡 class，請根據步驟完成類型宣告和測試。

final class User {
    var name: String
    var notify: (String) -> Void
    
    // 1️⃣ 完成啟動，參數名稱請用跟屬性名稱一樣的。
    init() {
        
    }
}

final class CreditCard {
    var owner: User
    private var limit: Int
    private var used: Int = 0
    
    init(owner: User, limit: Int) {
        self.owner = owner
        self.limit = limit
    }
    
    deinit {
        print("信用卡已註銷。")
        sendBill()
    }
    
    func sendBill() {
        // 2️⃣ 在 capture list 中直接存取需要的值。並確保這裡沒有產生任何強連結。（這裡產生強連結並不會有問題，這個調整只是為了練習）
        // 💡 這點你要自己對答案檢查。
        Task {
            owner.notify("[帳單] 您本月的刷卡金額為 \(used) 元。")
        }
    }
    
    @MainActor
    func swipe(amount: Int) {
        guard used + amount <= limit else {
            owner.notify("[刷卡通知] 卡片被拒絕。")
            return
        }
        
        used += amount
        owner.notify("[刷卡通知] 消費\(amount)。")
    }
}


// 3️⃣ 這個測試會每秒刷一次卡，使用者在兩秒後就會剪卡。你會在下面手指的地方寫每秒刷卡的程式碼，並確保裡面沒有對信用卡的強連結。
func runTest() {
    let startTime = Date.now
    let user = User(name: "Jane") { print($0) }
    let creditCard = CreditCard(owner: user, limit: 1000)
    
    // 💡 這是剪卡的 Task，這裡應該要是唯一一個 capture 信用卡的地方。如果後面弱連結設定都正確，這個 Task 兩秒後被釋放時卡片就會跟著被釋放。
    Task {
        try! await Task.sleep(seconds: 2)
        print("\(creditCard.owner.name) 剪卡了。")
    }
    
    let testCases = [300, 200, 700, 220]
    // 👇 請從這裡開始編輯，請新增一個 TaskGroup，其中任務是使用第二題寫的 schedule 來刷卡。（也是測試 schedule 有沒有寫對）
    // ＊ testCases 的數字是刷卡金額，請根據 index 設定等待秒數。例如 700 的 index 是 2，就是等待 2 秒後執行刷卡。
    // ＊ 假如卡片已註銷就拋出 CancellationError。印出「ＯＯＯ 的卡片註銷，取消剩餘任務。」後直接結束整組任務。
    // ＊ 確保這些任務不會對 CreditCard 產生強連結。（包含 Task 本身）
    // 💡 這題用連結判斷是否註銷也是為了練習而已，實際上用一個布林屬性判斷是否註銷即可。
    Task {
        
        print("\(user.name) 的卡片已註銷，取消剩餘任務。")
        printElapsedTime(from: startTime)
    }
}


runTest()


public func printElapsedTime(from startTime: Date) {
    let endTime = Date.now
    let timePassed = (startTime.distance(to: endTime)).formatted()
    print("完成任務共花費：\(timePassed) 秒")
}

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: Double) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
    }
}

//: [Next](@next)
