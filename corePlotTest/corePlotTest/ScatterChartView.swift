//
//  ScatterChartView.swift
//  corePlotTest
//
//  Created by jlai on 2020/10/30.
//  Copyright © 2020 h2. All rights reserved.
//

import UIKit
import CorePlot

class ScatterChartView: UIView {
    var hostView: CPTGraphHostingView!
    var upBound: Float = 0
    var lowBound: Float = 0
    var chartRange: CGFloat = 6 // 在不滑動chart view的情況下、當下畫面x座標的總數
    var hostViewWidth: CGFloat = 0
    let kLengthDistanceFromYAxis: CGFloat = 20
    let bgScatterArray: [NSNumber] = [118, 140, 140, 126, 80, 133]
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
        configureScatter()
        configureAxes()
        configureAnnotations()
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
        graph.paddingTop = 80
        graph.paddingBottom = 40
        graph.paddingLeft = 50
        graph.paddingRight = 40
        hostView.hostedGraph = graph
    }
    
    private func configureScatter() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }
        
        // create chart
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        let greenLineStyle = makeCPTMutableLineStyle(lineWidth: 2.0, color: .chartGreen(alpha: 1))
        scatterChart.dataLineStyle = greenLineStyle
        scatterChart.dataSource = self
        scatterChart.delegate = self
        scatterChart.title = "scatter"
        
        hostGraph.add(scatterChart)
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
    
    private func configureAnnotations() {
        let textLayer = CPTTextLayer.init(text: "abc")
        textLayer.isOpaque = false
        textLayer.fill = CPTFill(color: .clear())
        textLayer.paddingLeft = 5
        textLayer.paddingTop = 5
        textLayer.paddingRight = 5
        textLayer.paddingBottom = 0
        textLayer.cornerRadius = 10
        textLayer.backgroundColor = UIColor.cBlue(alpha: 1).cgColor
        
        let symbolTextAnnotation = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [NSNumber(value: 20), NSNumber(value: 160)])
        symbolTextAnnotation.contentLayer = textLayer;
        symbolTextAnnotation.displacement = CGPoint(x: 0, y: 40);
        hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(symbolTextAnnotation)
        
        let textLayer2 = CPTTextLayer.init(text: "8")
        textLayer2.isOpaque = false
        textLayer2.fill = CPTFill(color: .clear())
        textLayer2.paddingLeft = 5
        textLayer2.paddingTop = 5
        textLayer2.paddingRight = 5
        textLayer2.paddingBottom = 0
        textLayer2.cornerRadius = 10
        textLayer2.backgroundColor = UIColor.clear.cgColor
        
        let symbolTextAnnotation2 = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [NSNumber(value: 30), NSNumber(value: 160)])
        symbolTextAnnotation2.contentLayer = textLayer2;
        symbolTextAnnotation2.displacement = CGPoint(x: 0, y: 70);
        hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(symbolTextAnnotation2)
        
        let symbolTextAnnotation3 = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [NSNumber(value: 16), NSNumber(value: 160)])
        let markImage = UIImage.init(named: "icCheckmark")
        let imageRect = CGRect(x: 0, y: 0, width: 14, height: 14)
        let newImageLayer = CPTBorderedLayer.init(frame: imageRect)
        newImageLayer.fill = CPTFill.init(image: CPTImage.init(cgImage: markImage?.cgImage, scale: 2))
        symbolTextAnnotation3.contentLayer = newImageLayer;
        symbolTextAnnotation3.displacement = CGPoint(x: 0, y: 70);
        hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(symbolTextAnnotation3)
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
        configureYAxisLabelsWithScatter(min: 80, max: 140, numTicks: 5)
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
    
    private func configureYAxisLabelsWithScatter(min: Float, max: Float, numTicks: Int) {
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

extension ScatterChartView: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(bgScatterArray.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }
        
        let scatter = bgScatterArray[Int(idx)]
        
        switch field {
        case .X:
            let hostWidth = hostViewWidth - kLengthDistanceFromYAxis
            let widthPoint = hostWidth / CGFloat(dateArray.count)
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
    }
    
}

extension ScatterChartView: CPTScatterPlotDataSource {
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

extension ScatterChartView: CPTPlotSpaceDelegate {
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

