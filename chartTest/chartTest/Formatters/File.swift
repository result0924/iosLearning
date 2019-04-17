//
//  File.swift
//  chartTest
//
//  Created by justin on 2019/4/15.
//  Copyright © 2019 h2. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        let timeZone = NSTimeZone(name:"UTC")
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.timeZone = timeZone as TimeZone?
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: value))
        let dateStrArray = dateStr.split(separator: "-")
        let finalString = dateStrArray[0] + "-" + dateStrArray[1] + "\n" + dateStrArray[2]
        
        return finalString
    }
}

