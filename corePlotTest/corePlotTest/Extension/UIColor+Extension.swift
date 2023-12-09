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
    
    class func paleGrayColor() -> UIColor {
        return UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
    }
    
    static func cGreen(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: alpha)
    }
    
    static func cBlue(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 0.16, green: 0.53, blue: 0.87, alpha: alpha)
    }
    
    static func cRed(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 1, green: 0.51, blue: 0.41, alpha: alpha)
    }
}
