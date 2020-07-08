import UIKit

protocol Vehicle {
    var numberOfWheels: Int {get}
    var color: UIColor {get set}

    // Swift 的 mutating 關鍵字修飾⽅法是為了能在該⽅法中修改 struct 或是 enum 的變量
    // 如果是class就不需要mutating
    mutating func changeColor()
}

struct MyCar: Vehicle {
    let numberOfWheels = 4
    var color = UIColor.blue
    mutating func changeColor() { // changeColor not mutating will have error
        color = .red
    }
}

// 先定義⼀個實現了 IteratorProtocol 協議的類型
// IteratorProtocol 需要指定⼀個 typealias Element
// 以及提供⼀個返回 Element? 的⽅法 next()
class ReverseIterator<T>: IteratorProtocol {
    typealias Element = T
    var array: [Element]
    var currentIndex = 0
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }

    func next() -> Element? {
        if currentIndex < 0 {
            return nil
        } else {
            let element = array[currentIndex]
            currentIndex -= 1
            return element
        }
    }
}

// 然後我們來定義 Sequence
// 和 IteratorProtocol 很類似，不過換成指定⼀個 typealias Iterator
// 以及提供⼀個返回 Iterator? 的⽅法 makeIterator()
struct ReverseSequence<T>: Sequence {
    var array: [T]
    init (array: [T]) {
        self.array = array
    }
    typealias Iterator = ReverseIterator<T>
    func makeIterator() -> ReverseIterator<T> {
        return ReverseIterator(array: self.array)
    }
}

let array = [0, 1, 2, 3, 4]

// 對 Sequence 可以使⽤ for...in 來循環訪問
for i in ReverseSequence(array: array) {
    print("Index \(i) is \(array[i])")
}


// Subscript

// 宣告一個 [Int] 型別的陣列
var arr = [1,2,3,4,5,6,7]

// 印出其內第三個元素(請記得 陣列的索引值是從 0 開始算起)
print(arr[2])

// 修改第四個元素為 12
arr[3] = 12


// 宣告一個 [String:String] 型別的字典
var dict = ["name":"Kevin","city":"Taipei"]

// 印出鍵為 name 的值
print(dict["name"]!)

// 修改鍵為 city 的值為 New York
dict["city"] = "New York"


// 定義一個簡單數學算式功能的類別
class SimpleMath {
    // 一個數字屬性預設值
    var num = 500
    
    // 定義一個下標 為乘法
    subscript(times: String) -> Int {
        get {
            // 其內可以使用這個索引值
            print(times)
            
            // 會返回 數字屬性乘以 2 的數值
            return num * 2
        }
        set {
            // 將數字屬性乘以新的倍數
            num *= newValue
        }
    }
    
    // 定義另一個下標 為除法
    subscript(divided: Int) -> Int {
        return num / divided
    }
}

// 宣告一個類別 SimpleMath 的常數
let oneMath = SimpleMath()

// 印出：1000
print(oneMath["simple"])

// 傳入值為 3, 會將數字屬性乘以 3
oneMath["star"] = 3

// 這個下標例子中的字串索引值沒有被使用到
// 其實是可以依照傳入的索引值 來做不同的需求及返回值
// 印出：1500
print(oneMath.num)

// 使用到另一個下標 索引值型別為 Int
// 印出：15
print(oneMath[100])

//　在array我們很難⼀次性取出某幾個特定位置的元素，⽐如在⼀個數組內，
//　我想取出 index 為 0, 2, 3 的元素的時候，現有的體系就會⽐較吃⼒。我們很可能會要
//　去枚舉數組，然後在循環⾥判斷是否是我們想要的位置。其實這⾥有更好的做法，⽐如說可以實
//　現⼀個接受數組作為下標輸⼊的讀取⽅法：

extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            
            return result
        }
        
        set {
            for (index, i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}

var newArray = [1, 2, 3, 4, 5]
newArray[[0,2,3]]
newArray[[0,2,3]] = [-1, -3, -4]
print("newArray:\(newArray)")

//　雖然我們在這⾥實現了下標為數組的版本，但是我並不推薦使⽤這樣的形式。如果閱讀過
//　參數列表⼀節的讀者也許會想為什麼在這⾥我們不使⽤看起來更優雅的參數列表的⽅式，
//　也就是 subscript(input: Int...) 的形式。不論從易⽤性還是可讀性上來說，參數列表的形
//　式會更好。但是存在⼀個問題，那就是在只有⼀個輸⼊參數的時候參數列表會導致和現有
//　的定義衝突，有興趣的讀者不妨試試看。當然，我們完全可以使⽤⾄少兩個參數的的參數
//　列表形式來避免這個衝突，即定義形如 subscript(first: Int, second: Int, others: Int...) 的下標⽅法，我想這作為練習留給讀者進⾏嘗試會更好。
