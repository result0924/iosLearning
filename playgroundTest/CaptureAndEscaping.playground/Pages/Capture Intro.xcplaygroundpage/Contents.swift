import UIKit

/*:
 - [Refer](https://www.youtube.com/watch?v=lDKuSKrEeAk&ab_channel=ChaoCode)
 ### Capture: closure會「補捉」需要使用的值
 */

func getBuyCandyClosure() -> () -> Void {
    var money = 100

    func buyCandy() {
        money -= 20
        print("🍬, 剩下\(money)")
    }
    
    return buyCandy
}

let buyCandy = getBuyCandyClosure()
buyCandy()
buyCandy()

//: [Next](@next)

