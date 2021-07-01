//
//  CorePlot+Extension.swift
//  corePlotTest
//
//  Created by lai Kuan-Ting on 2021/7/1.
//  Copyright © 2021 h2. All rights reserved.
//

import UIKit
import CorePlot

extension CPTMutableTextStyle {
    static func dashBoardTextStyle() -> CPTMutableTextStyle {
        return makeTextStyle(color: CPTColor.gray600(), fontSize: 12)
    }

    static func makeTextStyle(color: CPTColor, fontSize: CGFloat) -> CPTMutableTextStyle {
        let textStyle = CPTMutableTextStyle()
        textStyle.color = color
        textStyle.fontSize = fontSize
        textStyle.textAlignment = .center
        return textStyle
    }
}

extension CPTColor {
    class func gray300() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1).cgColor)
    }
    
    static func gray500() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 135 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1).cgColor)
    }
    
    static func gray600() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 115 / 255, green: 115 / 255, blue: 115 / 255, alpha: 1).cgColor)
    }
    
    static func dashboardNormal() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor)
    }
}

extension CPTMutableLineStyle {
    static func makeLineStyle(lineWidth: CGFloat, lineColor: CPTColor) -> CPTMutableLineStyle {
        let axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = lineWidth
        axisLineStyle.lineColor = lineColor
        return axisLineStyle
    }
}

extension CPTPlotSymbol {
    static func makeScatterSymbol(color: CPTColor) -> CPTPlotSymbol {
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineWidth = 3
        symbolLineStyle.lineColor = color

        let symbol = CPTPlotSymbol.ellipse()
        symbol.fill = CPTFill(color: CPTColor.gray300())
        symbol.lineStyle = symbolLineStyle
        symbol.size = CGSize(width: 3, height: 3)

        return symbol
    }

    static func normalScatterSymbol() -> CPTPlotSymbol {
        return makeScatterSymbol(color: CPTColor.dashboardNormal())
    }

}
