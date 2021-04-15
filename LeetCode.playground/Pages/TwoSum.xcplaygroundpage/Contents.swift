import Foundation
// problem: https://leetcode.com/problems/two-sum/

class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        for (index, element) in nums.enumerated() {
            for (index2, element2) in nums.enumerated() {
                if index == index2 {
                    break
                }
                
                if element + element2 == target {
                    return [index, index2]
                }
            }
        }
        
        return [0, 0]
    }
    
    // good solution
    func niceTwoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var numToIndex: [Int: Int] = [:]
        for index in nums.indices {
            let num = nums[index]
            let needle = target - num
            if let previousIndex = numToIndex[needle], previousIndex != index {
                return [previousIndex, index]
            }
            numToIndex[num] = index
        }
        return []
    }
}

let numbers = [3,2,3]
let target = 6

print("self answer: \(Solution().twoSum(numbers, target))")
print("good answer: \(Solution().niceTwoSum(numbers, target))")
