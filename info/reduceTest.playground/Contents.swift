//: Playground - noun: a place where people can play

import PlaygroundSupport
import UIKit

let persons: [[String: Any]] = [["name": "Carl Saxon", "city": "New York, NY", "age": 44],
                                ["name": "Travis Downing", "city": "El Segundo, CA", "age": 34],
                                ["name": "Liz Parker", "city": "San Francisco, CA", "age": 32],
                                ["name": "John Newden", "city": "New Jersey, NY", "age": 21],
                                ["name": "Hector Simons", "city": "San Diego, CA", "age": 37],
                                ["name": "Brian Neo", "age": 27]] //注意這傢伙沒有 city 鍵值
func infoFromState(withState state: String, persons: [[String: AnyObject]])
    -> Int {
        // 先進行 flatMap 後進行 filter 篩選
        // $0["city"] 是一個可選值，對於那些沒有 city 屬性的項返回 nil
        // componentsSeparatedByString 處理鍵值，例如 "New York, NY"
        // 最後返回的 ["New York","NY"]，last 取到最後的 NY 
        return persons.compactMap({$0["city"]?.components(separatedBy: ", ").last}).filter({$0 == state}).count
}

infoFromState(withState: "CA", persons: persons as [[String : AnyObject]])

func combinator(accumulator: Int, current: Int) -> Int {
    return accumulator + current
}

[1, 2, 3].reduce(0, combinator)

func rmap(elements: [Int], trasform: (Int) -> Int) -> [Int] {
    return elements.reduce([Int](), {(acc:[Int], obj: Int) -> [Int] in
        var vacc = acc
        vacc.append(trasform(obj))
        return vacc
    })
}

rmap(elements: [1, 2, 3, 4], trasform: {$0 * 2})

func rmap2(elements: [Int], transform: (Int) -> Int) -> [Int] {
    return elements.reduce([Int](), {$0 + [transform($1)]})
}

rmap2(elements: [1, 2, 3, 4], transform: {$0 * 2})

func rflatMap(elements:[Int], transform:(Int) -> Int?) -> [Int] {
    return elements.reduce([Int](), {
        guard let m = transform($1) else {return $0}
        return $0 + [m]
    })
}

rflatMap(elements: [1, 3, 4], transform:{ guard $0 != 3 else { return nil}; return $0 * 2})

func rFilter(elements: [Int], filter: (Int) -> Bool) -> [Int] {
    return elements.reduce([Int](), {
        guard filter($1) else {return $0}
            return $0 + [$1]
    })
}

rFilter(elements: [1, 3, 4, 6], filter:{$0 % 2 == 0})

[0, 1, 2, 3, 4].reduce(0, +)

[1, 2, 3, 4].reduce(1, *)

[1, 2, 3, 4].reduce([Int](), {[$1] + $0})

typealias Acc = (l: [Int], r: [Int])

