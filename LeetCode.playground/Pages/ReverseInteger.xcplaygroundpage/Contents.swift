import UIKit
// problem: https://leetcode.com/problems/reverse-integer/

class Solution {
    func reverse(_ x: Int) -> Int {
        
        func checkLastValueIsZero(array:[Int]) -> [Int] {
            var newArray = array
            
            if array.last == 0 {
                newArray.removeLast()
                checkLastValueIsZero(array: newArray)
            }
            
            return newArray
        }
        
        var symbol = "+"
        if x < 0 {
            symbol = "-"
        }
        
        let stringX = "\(x)"
        
        let digits = stringX.compactMap{$0.wholeNumberValue}
        
        let finalDigits = checkLastValueIsZero(array: digits)
        let stringDigits = finalDigits.map{ String($0) }
        let answer = Int("\(symbol)\(stringDigits.reversed().joined())") ?? 0
//        print("2 32次方:\(1 << 31)")
//        print("-2 32次方:\(-1 << 31)")

        if answer > 1 << 31 || answer < -1 << 31 {
            return 0
        }
        
        return answer
    }
    
    func niceReverse(_ x: Int) -> Int {
        var number = x
        var revNumber: Int = 0

        while number != 0 {
            let pop = number % 10
            number = number / 10
//            print("pop:\(pop)")
//            print("number:\(number )")
//            print("Int32 min:\(Int32.min)")
//            print("Int32 max:\(Int32.max)")
            
            if revNumber > Int32.max / 10 || (revNumber == Int32.max / 10 && pop > 7) {
                return 0
            }

            if revNumber < Int32.min / 10 || (revNumber == Int32.min / 10 && pop < -8) {
                return 0
            }

            let temp = revNumber * 10 + pop
            revNumber = temp
        }
        
        return revNumber
   }
}


print("self answer: \(Solution().reverse(123))")
print("good answer: \(Solution().niceReverse(123))")
