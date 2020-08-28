import UIKit

// Swift 在內存管理上使用的是自動引用計數(ARC) 的一套方法，在 ARC 中雖然不需要手動地調用像是retain ，
// release 或者是 autorelease 這樣的方法來管理引用計數，
// 但是這些方法還是都會被調用的 -- 只不過是編譯器在編譯時在合適的地方幫我們加入了而已。
// 其中 retain 和 release 都很直接，就是將對象的引用計數加一或者減一。
// 但是 autorelease 就比較特殊一些，它會將接受該消息的對象放到一個預先建立的自動釋放池 (auto release pool) 中，
// 並在自動釋放池收到 drain 消息時將這些對象的引用計數減一，然後將它們從池子中移除 (這一過程形像地稱為“抽乾 池子”)。

//　在app中，整個主線程實際上是跑在一個自動釋放池裡的，並且在每個主Runloop結束時進行排水操作。
//　這是一種必要的連續釋放的方式，因為我們有時候需要確保在方法內部 初始化的生成的對像在被返回後別人還能使用，
//　而不是立即被釋放掉。
//　在你Objective-C中，建立一個自動釋放池的語法很簡單，使用@autoreleasepool就行了。
//　如果你新建一個Objective-C項目，可以看到main.m中就有我們剛才說到的整個項目的autoreleasepool ：
//　更進一步，其實@autoreleasepool在編譯時會被展開為NSAutoreleasePool，並附帶排水方法的調用。
//　而在Swift項目中，因為有了@UIApplicationMain，我們不再需要main文件和main函數，
//　所以原來的整個程序的自動釋放池就不存在了。
//　甚至我們使用main.swift作為程序的入口時，也就是不需要自己再添加自動釋放池的。
//　但是在一種情況下我們還是希望自動釋放，那就是面對著一個方法作用域中要生成大量的autorelease對象的時候。
//　在Swift 1.0時，我們可以寫這樣的代碼：

func loadBigData() {
    if let path = Bundle.main.path(forResource: "big", ofType: "jpg") {
        for _ in 1...10000 {
            _ = NSData.dataWithContentsOfMappedFile(path)
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
}

// dataWithContentsOfFile返回的是autorelease的對象，因為我們一直處在循環中，
// 因此它們將一直沒有機會被釋放。如果數量太多而且數據太大的時候，很容易因為內存不足而崩潰。
// 在面對這種情況的時候，正確的處理方法是在其中加入一個自動釋放池，
// 這樣我們就可以在循環進行到某個特定的時候施放內存，
// 在Swift中我們也是能使用autoreleasepool的-儘管語法上略有不同。
// 引用於原來在Objective-C中的關鍵字，現在它變成了一個接受閉包的方法：
// 利用尾隨閉包的寫法，很容易就能在Swift中加入一個類似的自動釋放池了：

func loadBigData2() {
    if let path = Bundle.main.path(forResource: "big", ofType: "jpg") {
        for _ in 1...10000 {
            autoreleasepool {
                _ = NSData.dataWithContentsOfMappedFile(path)
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
}

// 這裡我們每一次循環都生成了一個自動釋放池，雖然可以保證內存使用達到最小，
// 但釋放過多會帶來潛在的性能憂慮。一個折衷的方法是將循環分開開加入自動釋放池，
// 從而每10次循環對應一次自動釋放，這樣能減少帶來的性能損失。
// 在Swift中更提倡的是初始化方法而不是用像上面那樣的類方法來生成對象，
// 而且從Swift 1.1開始，因為加入了可以返回 nil的初始化方法，像上面例子中那樣的工廠方法都已經從API中刪除了。
//  let data = NSData(contentsOfFile: path)
// 使用初始化方法的話，我們就不需要面臨自動釋放的問題了，
// 每次在超過作用域後，自動內存管理都將為我們處理好內存相關的事情。
