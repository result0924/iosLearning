import UIKit
import Foundation

// Refer https://jierong.dev/2021/02/26/providing-default-value-for-decodable-property-by-property-wrapper.html

protocol Default {
    associatedtype Value
    static var defaultValue: Value { get }
}

@propertyWrapper
struct DefaultDecodable<D: Default>: Decodable where D.Value: Decodable {
    let wrappedValue: D.Value
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(D.Value.self)
    }
    
    init() {
        wrappedValue = D.defaultValue
    }
}

extension KeyedDecodingContainer {
    func decode<D>(_ type: DefaultDecodable<D>.Type, forKey key: Key) throws -> DefaultDecodable<D> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

protocol EmptyInitializable {
    init()
}

extension Array: EmptyInitializable {}
extension String: EmptyInitializable {}

struct EmptyDefault<Value: EmptyInitializable>: Default {
    static var defaultValue: Value {
        .init()
    }
}

enum CommonDefault {
    struct Empty<Value: EmptyInitializable>: Default {
        static var defaultValue: Value {
            .init()
        }
    }
    
    struct Zero<Value: Numeric>: Default {
        static var defaultValue: Value {
            .zero
        }
    }
    
    struct One<Value: Numeric>: Default {
        static var defaultValue: Value {
            1
        }
    }
    
    struct MinusOne<Value: Numeric>: Default {
        static var defaultValue: Value {
            -1
        }
    }
    
    struct `Self`<Value: SelfDefault>: Default {
        static var defaultValue: Value {
            Value.defaultValue
        }
    }
}

enum DefaultBy {
    typealias Empty<Value: Decodable & EmptyInitializable> = DefaultDecodable<CommonDefault.Empty<Value>>
    typealias Zero<Value: Decodable & Numeric> = DefaultDecodable<CommonDefault.Zero<Value>>
    typealias One<Value: Decodable & Numeric> = DefaultDecodable<CommonDefault.One<Value>>
    typealias MinusOne<Value: Decodable & Numeric> = DefaultDecodable<CommonDefault.MinusOne<Value>>
    typealias `Self`<Value: Decodable & SelfDefault> = DefaultDecodable<CommonDefault.Self<Value>>
}

protocol SelfDefault {
    static var defaultValue: Self { get }
}

enum Bar: String, Decodable, SelfDefault {
    static var defaultValue: Bar = .case2
    
    case case1, case2
}

struct Foo: Decodable {
    @DefaultBy.Empty var array: [Int]
    @DefaultBy.Empty var string: String
    @DefaultBy.Zero var int: Int
    @DefaultBy.MinusOne var double: Double
    @DefaultBy.Self var bar: Bar
}

let jsonData = Data(#"{"bar": null}"#.utf8)
let decoder = JSONDecoder()
let target = try decoder.decode(Foo.self, from: jsonData)
print("target:\(target.bar)")
print("======================")
let jsonData2 = Data("{}".utf8)
let target2 = try decoder.decode(Foo.self, from: jsonData2)
print("target:\(target.array)")
print("target:\(target.string)")
print("target:\(target.int)")
print("target:\(target.double)")
print("target:\(target.bar)")

