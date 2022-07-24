//: [Previous](@previous)
/*:
 ### KeyPath搭配Protocol
 */

import Foundation

protocol CanSearch {
    static var searchParameter: [KeyPath<Self, String>] { get }
}

extension Sequence where Element: CanSearch {
    func filter(keyword: String) -> [Element] {
        filter { data in
            Element.searchParameter.contains { path in
                let parameterData = data[keyPath: path]
                return parameterData.contains(keyword)
            }
        }
    }
}
 
struct Cat: CustomStringConvertible, CanSearch {
    static var searchParameter: [KeyPath<Cat, String>] = [\.name, \.color]
    
    var description: String {"\(name) \(color)"}
    
    let name: String
    let color: String
}

let Cats = [Cat(name: "opeg", color: "orange"), Cat(name: "yoyo", color: "white orange")]
print(Cats.filter(keyword: "op"))
print(Cats.filter(keyword: "o"))
//: [Next](@next)
