import UIKit

class Test {
    var id: Int
    var name: String
    init(id: Int, name: String) {
        self.id  = id
        self.name = name
    }
}

let tests = [
    Test(id: 1, name: "a"),
    Test(id: 1, name: "b"),
    Test(id: 1, name: "c")
]

var test = tests[0]
test.id = 3

print(tests[0].id)
