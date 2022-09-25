import Foundation
import _Concurrency
/*:
Opaque用途：省略不必要的複雜類型，專注在功能
 */

let range = 1...1000
print("類型：", type(of: range))

let 反過來 = range.reversed()
print("反過來的類型：", type(of: 反過來))

let 只要前五個 = 反過來.prefix(5)
print("只要前五個的類型：", type(of: 只要前五個))

/*:
- 如果不用some Sequence就得回傳Slice<ReversedCollection<ClosedRange<Int>>>
- 使用Opaque的好處
  1. 定義這function的人不用去煩腦怎麼去寫回傳值
  2. 使用function的人看到是Sequence回傳值、可以針對Sequence的方法、去做操作
- 所以對於二邊來說可以更專注去處理更重要的事情
*/

func 從後往前的五個<T: Sequence>(_ sequence: T) -> some Sequence {
    sequence.reversed().prefix(5)
}

let result = 從後往前的五個(1...1000)
print(result.map { String(describing: $0) })

//: [Next](@next)
