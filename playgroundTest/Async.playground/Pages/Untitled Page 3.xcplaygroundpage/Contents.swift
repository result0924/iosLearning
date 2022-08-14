//: [Previous](@previous)

import Foundation
import _Concurrency
import PlaygroundSupport

let startTime = Date.now
let totalSelfMonitor = 5
var finishSelfMonitor = 0

func selfMonitorADay(name: String) {
    print(Thread.current)
    print("\(name): 1️⃣ 起床")
    sleep(1)
    print("\(name): 2️⃣ 開始量血糖")
    sleep(1)
    Task {
        print(Thread.current)
        print("\(name): 3️⃣ 開始量飯前血糖")
        sleep(1)
        print("\(name): 4️⃣ 吃晚餐")
        sleep(1)
        print("\(name): 5️⃣ 開始量飯後血糖")
    }
    sleep(1)
    print("\(name): 6️⃣ 睡覺")
    
    finishSelfMonitor += 1
    if finishSelfMonitor == totalSelfMonitor {
        printElapsedTime(from: startTime)
    }
}

for patient in 1...totalSelfMonitor {
    Task {
       selfMonitorADay(name: "病患 \(patient) ")
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true // begin async execution
//: [Next](@next)
