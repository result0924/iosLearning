import UIKit

/*:
 # Struct VS Class
 ===
 
 在討論這個議題前，我們需要知道一些底層的知識。

 記憶體分成 heap 和 stack 兩塊。
 class 物件是 reference type，會被儲存在 heap；
 struct 物件是 value type，會被存在 stack。
 一般而言，stack 的執行效率會比 heap 好，所以一模一樣的事情，交給 struct 做，
 理論上會比 class 有效率（根據國外網友實測，越新版的 Swift，struct 效能較強這件事越顯著）。
 */

struct Baby {
   var height = 60
   var weight = 10.5
}
var cuteBaby1 = Baby()
withUnsafePointer(to: &cuteBaby1) {
   print($0)
}
