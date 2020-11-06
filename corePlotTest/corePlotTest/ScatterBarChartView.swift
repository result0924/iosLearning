//
//  ScatterBarChartView.swift
//  corePlotTest
//
//  Created by jlai on 2020/11/6.
//  Copyright © 2020 h2. All rights reserved.
//

import UIKit
import CorePlot

class ScatterBarChartView: UIView {
    var hostView: CPTGraphHostingView!
    var upBound: Float = 0
    var lowBound: Float = 0
    var chartRange: CGFloat = 6 // 在不滑動chart view的情況下、當下畫面x座標的總數
    var hostViewWidth: CGFloat = 0
    let kLengthDistanceFromYAxis: CGFloat = 20
    let bgScatterArray: [NSNumber] = [118, 140, 140, 126, 80, 133]
    let insulinBarArray: [NSNumber] = [7.2, 8, 7.2, 6.5, 8, 7]
    let dateArray:[String] = ["9/10", "9/11", "9/14", "9/14", "9/14", "9/15", "9/16"]
    
    var textStyle: CPTMutableTextStyle {
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor(cgColor: UIColor(red: 68 / 255, green: 68 / 255, blue: 68 / 255, alpha: 1).cgColor)
        textStyle.fontSize = 14.0
        textStyle.textAlignment = .center
        return textStyle
    }

    
    private func initPlot() {
//        let chartViewToBorder: CGFloat = 24 // |-12-chartView-12-|
        hostViewWidth = self.bounds.size.width
        
        configureHost()
        configureGraph()
        configureBarPlot()
        configureScatter()
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
        
        let scatterPlotSpace = CPTXYPlotSpace()
        scatterPlotSpace.allowsUserInteraction = true
        graph.add(scatterPlotSpace)
    }
    
    private func configureScatter() {
        guard let hostGraph = hostView.hostedGraph, let scatterPlotSpace = hostGraph.plotSpace(at: 1) as? CPTXYPlotSpace else {
            return
        }
        
        // create chart
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        let greenLineStyle = makeCPTMutableLineStyle(lineWidth: 2.0, color: .chartGreen(alpha: 1))
        scatterChart.dataLineStyle = greenLineStyle
        scatterChart.dataSource = self
        scatterChart.delegate = self
        scatterChart.title = "scatter"
        hostGraph.add(scatterChart, to: scatterPlotSpace)
    }
    
    private func configureBarPlot() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }
        
        // create chart
        let barPlot = CPTBarPlot.tubularBarPlot(with: .red(), horizontalBars: false)
        let barPlotLineStyle = CPTMutableLineStyle()
        barPlotLineStyle.lineColor = CPTColor.init(cgColor: UIColor.clear.cgColor)
        barPlotLineStyle.lineWidth = 0
        barPlot.lineStyle = barPlotLineStyle
        barPlot.baseValue = 0
        barPlot.dataSource = self
        barPlot.title = "bar"
        barPlot.barWidth = 10
        barPlot.cornerRadius = 2
        hostGraph.add(barPlot)
    }
    
    private func configureAxes() {
        // 1 - Get axis set
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let x = axisSet.xAxis, let y = axisSet.yAxis, let hostGraph = hostView.hostedGraph, let scatterPlotSpace = hostGraph.plotSpace(at: 1) as? CPTXYPlotSpace else {
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
        let axisYConstraints = CPTConstraints.constraint(withUpperOffset: 0)
        y.axisConstraints = axisYConstraints
        y.axisLineStyle = axisLineStyle2
        y.majorGridLineStyle = yLineStyle
        y.labelingPolicy = .none
        y.labelTextStyle = yAxisTextStyle
        y.majorTickLength = 0
        
        // 5 - Configure scatter-axis
        let scatterYAxis = CPTXYAxis()
        let scatterAxisYConstraints = CPTConstraints.constraint(withLowerOffset: 0)
        scatterYAxis.coordinate = .Y
        scatterYAxis.plotSpace = scatterPlotSpace
        scatterYAxis.axisConstraints = scatterAxisYConstraints
        scatterYAxis.axisLineStyle = axisLineStyle2
        scatterYAxis.majorGridLineStyle = yLineStyle
        scatterYAxis.labelingPolicy = .none
        scatterYAxis.labelTextStyle = yAxisTextStyle
        scatterYAxis.majorTickLength = 0
        
        hostGraph.axisSet?.axes = [axisSet.xAxis, axisSet.yAxis, scatterYAxis] as? [CPTAxis]
    }
    
    func reloadCharts() {
        configureAxisLabels()
        self.hostView.hostedGraph?.reloadData()
    }
    
    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace, let scatterPlotSpace = graph.plotSpace(at: 1) as? CPTXYPlotSpace else {
            return
        }
        
        space.allowsUserInteraction = true
        space.delegate = self
        
        // configure x-axis
        let xMin: CGFloat = 0
        let count: CGFloat = CGFloat(dateArray.count)
        
        let widthPoint = hostViewWidth / chartRange
        
        let xWidth: CGFloat = count * widthPoint + kLengthDistanceFromYAxis
        let xMax = max(hostViewWidth, xWidth)
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xMax - xMin))
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMax - hostViewWidth), lengthDecimal: CPTDecimalFromCGFloat(hostViewWidth))
        scatterPlotSpace.globalXRange = space.globalXRange
        scatterPlotSpace.xRange = space.xRange
        
        configureXAxisLabelsWithSpace(space: space)
        configureYAxisLabelsWithScatter(min: 80, max: 140, numTicks: 5)
        configureYAxisLabelsWithBar(min: 6.5, max: 8, numTicks: 5)
    }

    private func configureXAxisLabelsWithSpace(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }
        
        if let xAxis = axisSet.xAxis {
            var xLabels = Set<CPTAxisLabel>()
            
            let hostWidth = hostViewWidth
            let widthPoint = hostWidth / chartRange
            
            for index in 0..<dateArray.count {
                let scatterObject = dateArray[index]
                let location = kLengthDistanceFromYAxis + CGFloat(index) * widthPoint
                print("idx2: \(index) location:\(location)")
                let label = CPTAxisLabel(text: scatterObject, textStyle: textStyle)
                label.tickLocation = NSNumber(value: Float(location))
                label.alignment = .center
                label.offset = 5
                xLabels.insert(label)
            }
            xAxis.axisLabels = xLabels
        }
    }
    
    private func configureYAxisLabelsWithScatter(min: Float, max: Float, numTicks: Int) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let space = hostView.hostedGraph?.plotSpace(at: 1) as? CPTXYPlotSpace else {
            return
        }
        
        if let yAxis = axisSet.axes?[2] {
            
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
                label.alignment = .right
                label.offset = 10
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }
            
            let label = CPTAxisLabel(text: formatFloatByNumber(value: upBound, digit: 1), textStyle: textStyle)
            let location = CPTDecimalFromFloat(upBound)
            label.tickLocation = location as NSNumber
            label.alignment = .right
            label.offset = 10
            yLabels.insert(label)
            yMajorLocations.insert(upBound as NSNumber)
            
            let unitLabel = CPTAxisLabel(text: "mg/dL", textStyle: textStyle)
            let unitLocation = CPTDecimalFromFloat(upBound + stepSize / 2)
            unitLabel.tickLocation = unitLocation as NSNumber
            unitLabel.alignment = .center
            unitLabel.offset = 0
            yLabels.insert(unitLabel)
            
            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
        }
    }
    
    private func configureYAxisLabelsWithBar(min: Float, max: Float, numTicks: Int) {
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
                label.alignment = .left
                label.offset = -30
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }
            
            let label = CPTAxisLabel(text: formatFloatByNumber(value: upBound, digit: 1), textStyle: textStyle)
            let location = CPTDecimalFromFloat(upBound)
            label.tickLocation = location as NSNumber
            label.alignment = .left
            label.offset = -30
            yLabels.insert(label)
            yMajorLocations.insert(upBound as NSNumber)
            
            let unitLabel = CPTAxisLabel(text: "劑量", textStyle: textStyle)
            let unitLocation = CPTDecimalFromFloat(upBound + stepSize / 2)
            unitLabel.tickLocation = unitLocation as NSNumber
            unitLabel.alignment = .center
            unitLabel.offset = -30
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

extension ScatterBarChartView: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return plot.title == "bar" ? UInt(insulinBarArray.count) : UInt(bgScatterArray.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        if plot.title == "scatter", let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) {
            let scatter = bgScatterArray[Int(idx)]
            
            switch field {
            case .X:
                let hostWidth = hostViewWidth
                let widthPoint = hostWidth / chartRange
                var location = kLengthDistanceFromYAxis + CGFloat(idx) * widthPoint
                if idx > 3 {
                    location = kLengthDistanceFromYAxis + CGFloat(idx + 1) * widthPoint
                }
                
                return location
            case .Y:
                return scatter
            @unknown default:
                return nil
            }
        } else if plot.title == "bar", let field = CPTBarPlotField(rawValue: Int(fieldEnum)) {
            let bar = insulinBarArray[Int(idx)]
            
            switch field {
            case .barLocation:
                let hostWidth = hostViewWidth
                let widthPoint = hostWidth / chartRange
                var location = kLengthDistanceFromYAxis + CGFloat(idx) * widthPoint
                if idx > 2 {
                    location = kLengthDistanceFromYAxis + CGFloat(idx + 1) * widthPoint
                }
                
                return location
            case .barTip:
                return bar
            case .barBase:
                return nil
            @unknown default:
                return nil
            }
        } else {
            return nil
        }
    }
    
}

extension ScatterBarChartView: CPTScatterPlotDataSource {
    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineWidth = 3
        symbolLineStyle.lineColor = .chartGreen(alpha: 1)
        
        let symbol = CPTPlotSymbol.ellipse()
        symbol.fill = CPTFill(color: .chartGreen(alpha: 1))
        symbol.lineStyle = symbolLineStyle
        symbol.size = CGSize(width: 3, height: 3)
        
        return symbol
    }
}

extension ScatterBarChartView: CPTBarPlotDataSource {

    func barFill(for barPlot: CPTBarPlot, record idx: UInt) -> CPTFill? {
        return CPTFill.init(color: .chartBlue(alpha: 1))
    }
}

extension ScatterBarChartView: CPTPlotSpaceDelegate {
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


