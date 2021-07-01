//
//  BarChartView.swift
//  corePlotTest
//
//  Created by jlai on 2020/11/5.
//  Copyright © 2020 h2. All rights reserved.
//

import Foundation

import UIKit
import CorePlot

class BarChartView: UIView {
    var hostView: CPTGraphHostingView!
    var upBound: Float = 0
    var lowBound: Float = 0
    var chartRange: CGFloat = 6 // 在不滑動chart view的情況下、當下畫面x座標的總數
    var hostViewWidth: CGFloat = 0
    let kLengthDistanceFromYAxis: CGFloat = 20
    let insulinScatterArray: [NSNumber] = [7.2, 8, 7.2, 6.5, 8, 7.6]
    let dateArray:[String] = ["9/10", "9/11", "9/14", "9/14", "9/14", "9/15", "9/16"]
    
    var textStyle: CPTMutableTextStyle {
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor(cgColor: UIColor(red: 68 / 255, green: 68 / 255, blue: 68 / 255, alpha: 1).cgColor)
        textStyle.fontSize = 14.0
        textStyle.textAlignment = .center
        return textStyle
    }

    
    private func initPlot() {
        let chartViewToBorder: CGFloat = 24 // |-12-chartView-12-|
        hostViewWidth = self.bounds.size.width - chartViewToBorder
        
        configureHost()
        configureGraph()
        configureBarPlot()
        configureAxes()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initPlot()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPlot()
    }
    
    private func configureHost() {
        hostView = CPTGraphHostingView(frame: self.bounds)
        hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostView.allowPinchScaling = false
        self.addSubview(hostView)
    }
    
    private func configureGraph() {
        // 1 - Create the graph
        let graph = CPTXYGraph(frame: hostView.frame)
        graph.fill = CPTFill(color: CPTColor.clear())
        graph.plotAreaFrame?.masksToBorder = false
        graph.paddingTop = 0
        graph.paddingBottom = 40
        graph.paddingLeft = 50
        graph.paddingRight = 40
        hostView.hostedGraph = graph
    }
    
    private func configureBarPlot() {
        guard let hostGraph = hostView.hostedGraph, let plotSpace = hostGraph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }
        
        // create chart
        let barPlot = CPTBarPlot.tubularBarPlot(with: .red(), horizontalBars: false)
        barPlot.baseValue = 0
        barPlot.dataSource = self
        hostGraph.add(barPlot, to: plotSpace)
    }
    
    private func configureAxes() {
        // 1 - Get axis set
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let x = axisSet.xAxis, let y = axisSet.yAxis else {
            return
        }
        
        // 2 - Create styles
        let axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineColor = UIColor.scatterLineColor()
        axisLineStyle.lineWidth = 1
        
        let axisLineStyle2 = CPTMutableLineStyle()
        axisLineStyle2.lineColor = UIColor.scatterLineColor()
        axisLineStyle2.lineWidth = 0
        
        let xAxisTextStyle = CPTMutableTextStyle()
        xAxisTextStyle.color = UIColor.chartXAxisTextColor()
        xAxisTextStyle.fontSize = 13
        
        let yAxisTextStyle = CPTMutableTextStyle()
        yAxisTextStyle.color = UIColor.chartYAxisTextColor()
        yAxisTextStyle.fontSize = 11
        
        let yLineStyle = CPTMutableLineStyle()
        yLineStyle.lineWidth = 0.5
        yLineStyle.lineColor = UIColor.scatterLineColor()
        
        // 3 - Configure x-axis
        let axisXConstraints = CPTConstraints.constraint(withLowerOffset: 0)
        x.axisConstraints = axisXConstraints
        x.axisLineStyle = axisLineStyle
        x.labelingPolicy = .none
        x.labelTextStyle = xAxisTextStyle
        
        // 4 - Configure y-axis
        let axisYConstraints = CPTConstraints.constraint(withLowerOffset: 0)
        y.axisConstraints = axisYConstraints
        y.axisLineStyle = axisLineStyle2
        y.majorGridLineStyle = yLineStyle
        y.labelingPolicy = .none
        y.labelTextStyle = yAxisTextStyle

    }
    
    func reloadCharts() {
        configureAxisLabels()
        self.hostView.hostedGraph?.reloadData()
    }
    
    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }
        
        space.allowsUserInteraction = true
        space.delegate = self
        
        // configure x-axis
        let xMin: CGFloat = 0
        let count: CGFloat = CGFloat(dateArray.count)
        let xWidth: CGFloat = (hostViewWidth - kLengthDistanceFromYAxis) * (count / chartRange) + kLengthDistanceFromYAxis
        let xMax = max(hostViewWidth, xWidth)
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xMax - xMin))
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMax - hostViewWidth), lengthDecimal: CPTDecimalFromCGFloat(hostViewWidth))
        
        configureXAxisLabelsWithSpace(space: space)
        configureYAxisLabelsWithMin(min: 6.5, max: 8, numTicks: 5)
    }
    
    private func configureXAxisLabelsWithSpace(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }
        
        if let xAxis = axisSet.xAxis {
            var xLabels = Set<CPTAxisLabel>()
            
            let hostWidth = hostViewWidth - kLengthDistanceFromYAxis
            let widthPoint = hostWidth / CGFloat(dateArray.count)
            
            for index in 0..<dateArray.count {
                let scatterObject = dateArray[index]
                let location = kLengthDistanceFromYAxis + CGFloat(index) * widthPoint
                let label = CPTAxisLabel(text: scatterObject, textStyle: textStyle)
                label.tickLocation = NSNumber(value: Float(location))
                label.alignment = .center
                label.offset = 5
                xLabels.insert(label)
            }
            xAxis.axisLabels = xLabels
        }
    }
    
    private func configureYAxisLabelsWithMin(min: Float, max: Float, numTicks: Int) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let space = hostView.hostedGraph?.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }
        
        if let yAxis = axisSet.yAxis {
            
            var yLabels = Set<CPTAxisLabel>()
            var yMajorLocations = Set<NSNumber>()
            var yMin = min
            var yMax = max
            
            if yMin == yMax {
                yMin -= 0.2 * abs(yMin)
                yMax += 0.2 * abs(yMax)
            }
            
            let yRange = yMax - yMin
            let rawStep = yRange / Float(numTicks - 2)
            let mag = floor(log10(rawStep))
            let magPow = pow(10, mag)
            let magMsd = Int(rawStep / magPow + 0.5)
            let stepSize = Float(magMsd) * magPow
            
            lowBound = stepSize * floor(yMin / stepSize)
            upBound = stepSize * floor(yMax / stepSize + 1)
            
            if yMin - lowBound < 0.2 * stepSize {
                lowBound = (lowBound - stepSize < 0 && lowBound >= 0) ? lowBound : lowBound - stepSize
            }
            
            if upBound - yMax < 0.2 * stepSize {
                upBound = (upBound + stepSize > 0 && upBound <= 0) ? upBound : upBound + stepSize
            }
            
            space.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(lowBound), lengthDecimal: CPTDecimalFromFloat(upBound - lowBound + (stepSize / 3 * 2)))
            space.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(lowBound), lengthDecimal: CPTDecimalFromFloat(upBound - lowBound + (stepSize / 3 * 2)))
            
            for i in stride(from: lowBound, to: upBound, by: stepSize) {
                if lowBound == i {
                    continue
                }
                let label = CPTAxisLabel(text: formatFloatByNumber(value: Float(i), digit: 1), textStyle: textStyle)
                let location = CPTDecimalFromFloat(i)
                label.tickLocation = location as NSNumber
                label.alignment = .center
                label.offset = 10
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }
            
            let label = CPTAxisLabel(text: formatFloatByNumber(value: upBound, digit: 1), textStyle: textStyle)
            let location = CPTDecimalFromFloat(upBound)
            label.tickLocation = location as NSNumber
            label.alignment = .center
            label.offset = 10
            yLabels.insert(label)
            yMajorLocations.insert(upBound as NSNumber)
            
            let unitLabel = CPTAxisLabel(text: "劑量", textStyle: textStyle)
            let unitLocation = CPTDecimalFromFloat(upBound + stepSize / 2)
            unitLabel.tickLocation = unitLocation as NSNumber
            unitLabel.alignment = .right
            unitLabel.offset = 0
            yLabels.insert(unitLabel)
            
            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
        }
    }
    
    private func formatFloatByNumber(value: Float, digit: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesSignificantDigits = false
        formatter.maximumFractionDigits = digit
        formatter.roundingMode = .halfUp

        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    private func makeCPTMutableLineStyle(lineWidth: CGFloat, color: CPTColor) -> CPTMutableLineStyle {
        let axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = lineWidth
        axisLineStyle.lineColor = color
        return axisLineStyle
    }
    
}

extension BarChartView: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(insulinScatterArray.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        guard let field = CPTBarPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }
        
        let scatter = insulinScatterArray[Int(idx)]
        
        switch field {
        case .barLocation:
            let hostWidth = hostViewWidth - kLengthDistanceFromYAxis
            let widthPoint = hostWidth / CGFloat(dateArray.count)
            var location = kLengthDistanceFromYAxis + CGFloat(idx) * widthPoint
            if idx > 3 {
                location = kLengthDistanceFromYAxis + CGFloat(idx + 1) * widthPoint
            }
            
            return location
        case .barTip:
            return scatter
        case .barBase:
            return nil
        @unknown default:
            return nil
        }
    }
    
}

extension BarChartView: CPTPlotSpaceDelegate {
    func plotSpace(_ space: CPTPlotSpace, shouldScaleBy interactionScale: CGFloat, aboutPoint interactionPoint: CGPoint) -> Bool {
        return false
    }
    
    func plotSpace(_ space: CPTPlotSpace, willChangePlotRangeTo newRange: CPTPlotRange, for coordinate: CPTCoordinate) -> CPTPlotRange? {
        
        switch coordinate {
        case .X:
            return newRange
        case .Y:
            let space = space as? CPTXYPlotSpace
            return space?.globalYRange
        default:
            return nil
        }
    }
    
    func plotSpace(_ space: CPTPlotSpace, didChangePlotRangeForcoordinate: CPTCoordinate) {
        guard let space = space as? CPTXYPlotSpace else {
            return
        }
        configureXAxisLabelsWithSpace(space: space)
    }
}
