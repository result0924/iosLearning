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
}

let nums = [3,2,3]
let target = 6

print("\(Solution().twoSum(nums, target))")


