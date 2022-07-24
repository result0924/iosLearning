//: [Previous](@previous)
/*:
 ### 用途：語法糖，省去不必要的Clousures
 */

import Foundation
 
struct Cat: CustomStringConvertible {
    var description: String {"\(name) \(color)"}
    
    let name: String
    let color: String
    let weight: Double
}

let Cats = [Cat(name: "opeg", color: "orange", weight: 17), Cat(name: "yoyo", color: "white orange", weight: 13)]

extension Array {
    func filter(keyword: String, on paths: [KeyPath<Element, String>]) -> Self {
        filter { data in
            paths.contains { path in
                let parameterData = data[keyPath: path]
                return parameterData.contains(keyword)
            }
        }
    }
}
print("filter cat parameter")
print(Cats.filter{ $0.name.contains("op") || $0.color.contains("op")})
print(Cats.filter(keyword: "op", on: [\.name, \.color]))
print(Cats.filter(keyword: "o", on: [\.name, \.color]))

print("===")
print("sort cat weight")
extension Sequence {
    func sorted<T: Comparable>(_ path: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: path] < $1[keyPath: path] }
    }
    
    func sum<T: AdditiveArithmetic>(_ path: KeyPath<Element, T>) -> T {
        reduce(T.zero) { $0 + $1[keyPath: path] }
    }
}
print(Cats.sorted{ $0.weight < $1.weight})
print(Cats.sorted(\.weight))
print(Cats.sum(\.weight))
print([111.1, 222.2].sum(\.self))
//: [Next](@next)
