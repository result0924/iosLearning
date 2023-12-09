//
//  String+Extension.swift
//  corePlotTest
//
//  Created by jlai on 2020/10/30.
//  Copyright © 2020 h2. All rights reserved.
//

import UIKit

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date ?? Date()
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return ceil(size.width)
    }
    
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    
    func formatFloatByNumber(digit: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesSignificantDigits = false
        formatter.maximumFractionDigits = digit
        formatter.roundingMode = .halfUp
        
        return formatter.string(from: NSNumber(value: Float(self) ?? 0)) ?? ""
    }
}
