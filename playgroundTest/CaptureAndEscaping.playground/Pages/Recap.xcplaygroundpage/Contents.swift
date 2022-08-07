//: [Previous](@previous)

/*:
 ### Capture(補捉)
    - 會直接存取到需要的變數，把它的生命週期跟自已綁在一起。
    - 如果是Reference Type會產生強連結。
 ### Capture Lit
    - 在closure expression的參數前面加上[], 裡面放上需要的變數。
    - 會把Capture List中的變數都用「複製」的方式建立成自已的變數。(後續不會影響外部原本的變數)
    - 如果是Value Type就會固定為建立時的值。
    - 如果是Reference Type是存取一樣的實例，但是可以設定弱連結。
    - 除了放入self，也可以直接放入需要的屬性，可以更方便地避免retain cycle。
    - weak連結是可變的，所以在concurrency context中，只能存取local的weak連結
 ### Escaping
    - 表示closure會以某種形式繼續存在
    - 通常是被放到某個屬性中或是被另個escaping closure capture
    - @escaping是提醒呼要者要注意「強連結」
 
 ### 概念
 - 哪些地方會發生 Capture？
 ```
 Nested function（function 中的 function）和 closure expression。
 ```
 - Capture 和 Capture List 的差別是什麼？
 ```
 Capture 是直接使用外部的某一個變數，把這個變數的生命週期跟自己綁在一起。
 Capture List 是用複製的方式自己建立一樣值的變數。
 ```
 - Capture List 能用在哪種 closure？
 ```
 只能搭配 closure expression 使用。
 ```
 - Capture List 中放的變數和直接 Capture 的變數，是 Value Type 或 Reference Type 有什麼差別？
 ```
 Value Type：Capture 會影響原本的變數，；Capture List 不會影響到原本變數。
 Reference Type：兩者都是操作同一個實例，但是 Capture List 可以設定弱連結。
 ```
 - Escaping 是什麼意思？
 ```
 指一個 closure 會用某種形式繼續存在，不是執行完某個 closure 後就消失。
 ```
 - 看到參數是 escaping 的 closure 應該要注意什麼？
 ```
 escaping 會產生強連結，要注意 closure 中用到的 reference type 會受到這個強連結影響，被維持更久的時間
 ```
 */

//: [Next](@next)
