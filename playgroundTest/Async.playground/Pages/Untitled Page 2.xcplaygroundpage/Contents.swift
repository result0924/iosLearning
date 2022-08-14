//: [Previous](@previous)

import Foundation
import _Concurrency

let startTime = Date.now

print("1️⃣ 起床")
sleep(1)
print("2️⃣ 開始量血糖")
sleep(1)
Task {
    print("3️⃣ 開始量飯前血糖")
    sleep(1)
    print("4️⃣ 吃晚餐")
    sleep(1)
    print("5️⃣ 開始量飯後血糖")
}
sleep(1)
print("6️⃣ 睡覺")

printElapsedTime(from: startTime)
//: [Next](@next)
