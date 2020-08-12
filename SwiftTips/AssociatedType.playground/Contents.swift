import UIKit

// 我們在 Swift 協議中可以定義屬性和方法，
// 並要求滿足這個協議的類型實現它們

protocol Food { }
protocol Animal {
    func eat(_ food: Food)
}
struct Meat: Food { }
struct Grass: Food { }

// 我們定義了 Food 協議和 Animal 協議，在 Animal 中有一個接受 Food 的 eat: 方法。
// 當我們嘗試創建一個具體的類型來實現 Animal 協議時，需要實現這個方法:

struct Tiger: Animal {
    func eat(_ food: Food) {
        
    }
}

// 因為老⻁並不吃素，所以在 Tiger 的 eat 中，我們很可能需要進行一些轉換工作才能使用 meat

struct Tiger2: Animal {
    func eat(_ food: Food) {
        if let meat = food as? Meat {
            print("eat: \(meat)")
        } else {
            fatalError("Tiger can only eat meat!")
        }
    }
}

let meat = Meat()
Tiger2().eat(meat)

// 這樣的轉換很多時候沒有意義，而且將責任扔給了運行時。有沒有更好的方式，
// 能讓我們在編譯時就確保“老⻁不吃素”這個條件呢?因為 Meat 其實是實現了 Food 的類型，那換成下面的代碼如何?

// this is error code
//struct Tiger3: Animal {
//    func eat(_ food: Meat) {
//        print("eat \(food)")
//    }
//}

// 很遺憾，這段代碼將無法編譯，因為 Meat 實際上和協議中要求的 Food 並不能等價。
// 其實在協議中除了定義屬性和方法外，我們還能定義類型的佔位符，讓實現協議的類型來指定具體的類型。
// 使用 associatedtype 我們就可以在 Animal 協議中添加一個限定，讓 Tiger 來指定⻝物的具體類型:

protocol Animal2 {
    associatedtype F
    func eat(_ food: F)
}

struct Tiger4: Animal2 {
    typealias F = Meat
    func eat(_ food: Meat) {
        print("eat: \(food)")
    }
}

Tiger4().eat(meat)

// 在 Tiger 通過 typealias 具體指定 F 為 Meat 之前， Animal 協議中並不關心 F 的具體類型，
// 只需要滿足協議的類型中的 F 和 eat 參數一致即可。
// 如此一來，我們就可以避免在 Tiger 的 eat 中進行判定和轉換了。
// 不過這裡忽視了被吃的必須是 Food 這個前提。
// associatedtype 聲明中可以使用冒號來指定類型滿足某個協議，
// 另外，在 Tiger 中只要實現了正確類型的 eat ， F 的類型就可以被推斷出來，
// 所以我們也不需要顯式地寫明 F 。最後這段代碼看起來是這樣的:

struct Tiger5: Animal2 {
    func eat(_ food: Meat) {
        print("eat: \(food)")
    }
}
Tiger5().eat(meat)

let grass = Grass()

struct Sheep: Animal2 {
    func eat(_ food: Grass) {
        print("eat: \(food)")
    }
}

Sheep().eat(grass)

// 不過在添加 associatedtype 後，
// Animal 協議就不能被當作獨立的類型使用了。試想我們有一個函數來判斷某個動物是否危險:

// This is error code

//func isDangerous(animal: Animal2) -> Bool {
//    if animal is Tiger5 {
//        return true
//    } else {
//        return false
//    }
//}

// 這是因為Swift需要在編譯時確定所有類型，這裡因為Animal包含了一個不確定的類型，
// 所以隨著Animal本身類型的變化，其中的 F 將無法確定(試想一下如果在這個函數內部調用eat的情形，
// 你將無法指定eat參數的類型)。在一個協議加入了像是 associatedtype 或者 Self 的約束後，
// 它將只能被用為泛型約束，而不能作為獨立類型的佔位使用，也失去了動態派發的特性。
// 也就是說，這種情況下，我們需要將函數改寫為泛型

func isDangerous2<T: Animal2>(animal: T) -> Bool {
    if animal is Tiger5 {
        return true
    } else {
        return false
    }
}

isDangerous2(animal: Tiger5())
isDangerous2(animal: Sheep())
