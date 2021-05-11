//
//  Date+Extension.swift
//  TestGrapth
//
//  Created by jlai on 2021/5/11.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
}
