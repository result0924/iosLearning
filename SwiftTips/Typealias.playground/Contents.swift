import UIKit

// typealias是用來為已經存在的類型重新定義名字的，通過命名，可以使代碼變得更加清晰。使用的語法也很簡單，
// 使用 typealias 關鍵字像使用普通的賦值語句一樣，可以將某個已經存在的類型賦值為新的名字。
// 比如在計算二維平面上的距離和位置的時候，我們一般使用 Double 來表示距 離，用 CGPoint 來表示位置:

func distance(from point: CGPoint, to anotherPoint: CGPoint) -> Double {
    let dx = Double(anotherPoint.x - point.x)
    let dy = Double(anotherPoint.y - point.y)
    return sqrt(dx * dx + dy * dy)
}

let origin: CGPoint = CGPoint(x: 0, y: 0)
let point: CGPoint = CGPoint(x: 1, y: 1)

let d: Double = distance(from: origin, to: point)

// 雖然在數學上和最後的程序運行上都沒什麼問題，但是閱讀和維護的時候總是覺得有哪裡不對。
// 因為我們沒有將數學抽象和實際問題結合起來，使得在閱讀代碼時我們還需要在大腦中進行一次額外的轉換:
// CGPoint代表一個點，而這個點就是我們在定義的坐標系裡的位置;
// Double 是一個數字，它代表兩個點之間的距離。
// 如果我們使用 typealias，就可以將這種轉換直接寫在代碼裡，從而減輕閱讀和維護的負擔:

typealias Location = CGPoint
typealias Distance = Double

func newDistance(from location: Location, to anohterLocation: Location) -> Distance {
    let dx = Distance(location.x - anohterLocation.x)
    let dy = Distance(location.y - anohterLocation.y)
    
    return sqrt(dx * dx + dy * dy)
}

let newOrigin: Location = Location(x: 0, y: 0)
let newPoint: Location = Location(x: 1, y: 1)

let d2: Distance = newDistance(from: newOrigin, to: newPoint)

// 對於普通類型並沒有什麼難點，但是在涉及到泛型時，情況就稍微不太一樣。
// 首先，typealias 是單一的，也就是說你必須指定將某個特定的類型
// 通過 typealias 賦值為新名字，而不能將整個泛型 類型進行重命名。
// 下面這樣的命名都是無法通過編譯的:

class Person<T> {}
typealias WorkerP = Person
// This is not work
//typealias Worker = Person<T>
 
// 不過如果我們在別名中也引入泛型，是可以進行對應的:
// This is work
typealias Work<T> = Person<T>

// 當泛型類型的確定性得到保證後，顯然別名也是可以使用的:

typealias WorkId = String
typealias Worker = Person<WorkId>
  
//另一個使用場景是某個類型同時實現多個協議的組合時。
// 我們可以使用 & 符號連接幾個協議，然後給它們一個新的更符合上下文的名字，來增強代碼可讀性:
protocol Cat {}
protocol Dog {}
typealias Pat = Cat & Dog
