import Foundation
// problem: https://leetcode.com/problems/add-two-numbers/

class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}

class Solution {
    func getValFromNode(node: ListNode?) -> Int {
        guard let node = node else {
            return 0
        }
        
        return node.val
    }
    
    func getNextFromNode(node: ListNode?) -> ListNode? {
        guard let node = node else {
            return nil
        }
        
        return node.next
    }
    
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        guard let l1 = l1, let l2 = l2 else {
            return nil
        }
        
        var ll1: ListNode? = l1
        var ll2: ListNode? = l2
        let head = ListNode(0)
        var point = head
        var carry = 0
        
        while (ll1 != nil) || (ll2 != nil) || carry != 0 {
            print("ll1:\(ll1?.val) ll2:\(ll2?.val), carry:\(carry)")
            let total = getValFromNode(node: ll1) + getValFromNode(node: ll2) + carry
            point.val = total % 10
            carry = total / 10
            
            ll1 = getNextFromNode(node: ll1)
            ll2 = getNextFromNode(node: ll2)
            if ll1 != nil || ll2 != nil || carry != 0 {
                print("internal ll1:\(ll1?.val) ll2:\(ll2?.val), carry:\(carry)")
                point.next = ListNode(0)
                point = point.next!
            }
        }
        print("head\(head.val)")
        
        return head
    }
    
    func addTwoNumbers2(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var l1 = l1
        var l2 = l2
        var prev = ListNode(0)
        var carry = 0
        let head = prev
        
        while l1 != nil || l2 != nil || carry != 0 {
            print("l1:\(l1?.val) ll2:\(l2?.val), carry:\(carry)")
            let cur = ListNode(0)
            let sum = (l2 == nil ? 0 : l2!.val) + (l1 == nil ? 0 : l1!.val) + carry
            cur.val = sum % 10
            carry = sum / 10
            prev.next = cur
            prev = cur
            print("cur:\(cur.val)")
            print("prev val:\(prev.val) prev next:\(prev.next)")
            print("aaa:\(l1 == nil) bbb:\(l1?.next?.val ?? 111)")
            print("ccc:\(l2 == nil) ddd:\(l2?.next?.val ?? 111)")
            l1 = l1 == nil ? l1: l1?.next
            l2 = l2 == nil ? l2: l2?.next
        }
        
        return head.next
    }
    
}

let node1 = ListNode.init(2, ListNode.init(4, ListNode.init(3)))
let node2 = ListNode.init(5, ListNode.init(6, ListNode.init(4)))
//let answer = Solution().addTwoNumbers(node1, node2)
//print("first:\(answer?.val)")
//print("second:\(answer?.next?.val)")
//print("third:\(answer?.next?.next?.val)")

let answer2 = Solution().addTwoNumbers2(node1, node2)
print("2 first:\(answer2?.val)")
print("2 second:\(answer2?.next?.val)")
print("2 third:\(answer2?.next?.next?.val)")
