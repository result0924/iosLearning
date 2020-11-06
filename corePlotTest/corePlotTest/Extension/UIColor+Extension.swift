//
//  UIColor+Extension.swift
//  corePlotTest
//
//  Created by jlai on 2020/11/5.
//  Copyright © 2020 h2. All rights reserved.
//

import UIKit
import CorePlot

extension UIColor {
    class func scatterLineColor() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1).cgColor)
    }
    
    class func chartXAxisTextColor() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1).cgColor)
    }
    
    class func chartYAxisTextColor() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 166 / 255, green: 166 / 255, blue: 166 / 255, alpha: 1).cgColor)
    }
}
