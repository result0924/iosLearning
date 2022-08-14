import UIKit
import _Concurrency
/*:
 Asynchronous
 - async: 宣告closure是用Asynchronous的方式執行
 - await: 表示這裡有一個暫停點
 - Task: 在synchronous的空間建立一段Asynchronous code
 */

let startTime = Date.now

print("1️⃣ 起床")
sleep(1)
print("2️⃣ 開始量血糖")
sleep(1)
print("3️⃣ 開始量飯前血糖")
sleep(1)
print("4️⃣ 吃晚餐")
sleep(1)
print("5️⃣ 開始量飯後血糖")
sleep(1)
print("6️⃣ 睡覺")

printElapsedTime(from: startTime)

//: [Next](@next)
