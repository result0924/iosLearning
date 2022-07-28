//: [Previous](@previous)

import Foundation

/*:
 KeyPath 搭配 Operator
 
 ###　KeyPath 好用的 third party
 - [KeyPathKit](https://github.com/vincent-pradeilles/KeyPathKit)
 */

struct Dog: CustomStringConvertible {
    enum Breed: String {
        case 博美, 柴犬, 哈士奇, 米克斯
    }
    
    var name: String
    var breed: Breed
    var weight: Int
    
    var description: String { "\(name) \(breed.rawValue)" }
}

let dogs = [Dog(name: "Peter", breed: .博美, weight: 109),
            Dog(name: "Amy", breed: .哈士奇, weight: 78),
            Dog(name: "Yumi", breed: .柴犬, weight: 111)]

print(dogs.filter{ $0.breed == .柴犬})

func == <Root, Value: Equatable>(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool {
    { $0[keyPath: lhs] == rhs }
}

func > <Root, Value: Comparable>(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool {
    { $0[keyPath: lhs] > rhs }
}
print(dogs.filter(\.breed == .柴犬))
print(dogs.filter(\.weight > 100))
//: [Next](@next)
