import UIKit

class Name {
    private var firstName: String!
    private var lastName: String!
    var fullName: String!

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    // join firstName and lastName
    func join() {
        fullName = firstName + " " + lastName
    }

    // remove spaces
    func removeSpace() {
        let firstChar = fullName.components(separatedBy: " ").first

        if (firstChar == " ") {
            fullName.remove(at: fullName.startIndex)
        }

        let lastChar = fullName.components(separatedBy: " ").last

        if (lastChar == " ") {
            fullName.remove(at: fullName.index(before: fullName.endIndex))
        }

        while (fullName.contains("  ") == true) {
            let index = fullName.range(of: "  ")?.lowerBound
            fullName.remove(at: index!)
        }
    }

    // print fullName
    func printName() {
        print(fullName ?? "")
    }
}

let name = Name(firstName: "Thanh-Dung", lastName: "Nguyen ")
name.join()
name.removeSpace()
name.printName()


class Name2 {
    private var firstName: String!
    private var lastName: String!
    var fullName: String!
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    // join firstName and lastName
    @discardableResult
    func join() -> Self {
        fullName = firstName + " " + lastName
        
        return self
    }
    
    // remove spaces
    @discardableResult
    func removeSpace() -> Self {
        let firstChar = fullName.components(separatedBy: " ").first
        
        if (firstChar == " ") {
            fullName.remove(at: fullName.startIndex)
        }
        
        let lastChar = fullName.components(separatedBy: " ").last
        
        if (lastChar == " ") {
            fullName.remove(at: fullName.index(before: fullName.endIndex))
        }
        
        while (fullName.contains("  ") == true) {
            let index = fullName.range(of: "  ")?.lowerBound
            fullName.remove(at: index!)
        }
        
        return self
    }
    
    // print fullName
    @discardableResult
    func printName() -> Self {
        print(fullName ?? "")
        return self
    }
}

let name2 = Name2(firstName: "Thanh-Dung", lastName: "Nguyen ").join().removeSpace().printName()
