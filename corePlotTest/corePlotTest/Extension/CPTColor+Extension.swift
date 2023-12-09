//
//  CPTColor+Extension.swift
//  corePlotTest
//
//  Created by jlai on 2023/12/9.
//  Copyright © 2023 h2. All rights reserved.
//

import Foundation
import CorePlot

extension CPTColor {
    static func chartBlue(alpha: CGFloat) -> CPTColor {
        return CPTColor(cgColor: UIColor.cBlue(alpha: alpha).cgColor)
    }
    
    static func chartRed(alpha: CGFloat) -> CPTColor {
        return CPTColor(cgColor: UIColor.cRed(alpha: alpha).cgColor)
    }
    
    static func chartGreen(alpha: CGFloat) -> CPTColor {
        return CPTColor(cgColor: UIColor.cGreen(alpha: alpha).cgColor)
    }
}
