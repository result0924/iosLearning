//
//  ViewController.swift
//  corePlotTest
//
//  Created by justin on 2019/4/19.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit
import CorePlot

struct dataModle {
    let value: Float
    let date: String
}

let kLengthDistanceFromYAxis: CGFloat = 60

class ViewController: UIViewController, CPTAxisDelegate {
    @IBOutlet weak var plotView: UIView!
    var hostView: CPTGraphHostingView!
    lazy var dataArray: [dataModle] = {
        let data1 = dataModle(value: 77, date: "2018-07-15")
        let data2 = dataModle(value: 132, date: "2018-011-23")
        let data3 = dataModle(value: 69, date: "2019-03-08")
        let data4 = dataModle(value: 73, date: "2019-07-15")
        let data5 = dataModle(value: 88, date: "2019-011-23")
        
        return [data1, data2, data3, data4, data5]
    }()
    var minValue: Float = 0
    var maxValue: Float = 0
    
    var textStyle: CPTMutableTextStyle {
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontName = UIFont.systemFont(ofSize: 13).fontName
        textStyle.fontSize = 13.0
        textStyle.textAlignment = .center
        return textStyle
    }
    
    var axisLineStyle : CPTMutableLineStyle {
        let axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 1
        axisLineStyle.lineColor = .lightGray()
        return axisLineStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initPlot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configurePlotData()
        self.configureAxisLabels()
        self.hostView.hostedGraph?.reloadData()
    }
    
    // MARK - Private
    private func initPlot() {
        self.configureHost()
        self.configureGraph()
        self.configureChart()
        self.configureAxes()
    }
    
    private func configureHost() {
        hostView = CPTGraphHostingView(frame: plotView.bounds)
        hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostView.allowPinchScaling = false
        self.plotView.addSubview(hostView)
    }

    private func configureGraph() {
        // 1 - Create the graph
        let graph = CPTXYGraph(frame: hostView.frame)
        graph.plotAreaFrame?.masksToBounds = false
        hostView.hostedGraph = graph
        
        // 2 - Configure the graph
        graph.paddingTop = 0
        graph.paddingLeft = 0
        graph.paddingRight = 0
        graph.paddingBottom = 0
        graph.fill = CPTFill(color: CPTColor.clear())
        
        graph.plotAreaFrame?.paddingBottom = 30
        graph.plotAreaFrame?.paddingLeft = 50
    }
    
    private func configureChart() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }
        
        // create chart
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        scatterChart.interpolation = .curved
        scatterChart.dataSource = self
        scatterChart.labelTextStyle = textStyle
        scatterChart.labelOffset = 4
        
        // fill area under the plot
//        let areaColor = CPTColor(componentRed: 240, green: 240, blue: 240, alpha: 1)
//        let areaGradient = CPTGradient(beginning: CPTColor.clear(), ending: areaColor)
//        let areaGradientFill = CPTFill(gradient: areaGradient)
//        scatterChart.areaFill = areaGradientFill
//        scatterChart.areaBaseValue = 0
        
        scatterChart.dataLineStyle = axisLineStyle
        
        hostGraph.add(scatterChart)
    }
    
    private func configureAxes() {
        // get axis set
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }
        
        // configure x-axis
        if let xAxis = axisSet.xAxis {
            let axisXConstraints = CPTConstraints.constraint(withLowerOffset: 0)
            xAxis.orthogonalPosition = 10
            xAxis.axisConstraints = axisXConstraints
            xAxis.axisLineStyle = axisLineStyle
            xAxis.labelingPolicy = .none
            xAxis.labelTextStyle = textStyle
        }
        
        // configure y-axis
        if let yAxis = axisSet.yAxis {
            let axisYconstraints = CPTConstraints.constraint(withLowerOffset: 0)
            yAxis.axisConstraints = axisYconstraints
            yAxis.axisLineStyle = axisLineStyle
            yAxis.majorGridLineStyle = axisLineStyle
            yAxis.labelingPolicy = .none
            yAxis.labelTextStyle = textStyle
        }
    }
    
    private func configurePlotData() {
        if !dataArray.isEmpty {
            minValue = dataArray.first?.value ?? 0
            maxValue = dataArray.first?.value ?? 0
            
            for data in dataArray {
                if data.value < minValue {
                    minValue = data.value
                }
                
                if data.value > maxValue {
                    maxValue = data.value
                }
            }
        }
    }
    
    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }
        
        space.allowsUserInteraction = true
        space.delegate = self
        
        // configure x-axis
        let xMin: CGFloat = 0
        let xWidth: CGFloat = hostView.bounds.size.width * (CGFloat(dataArray.count) / 3)
        let xMax = max(xMin, xWidth)
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xMax - xMin))
        
        // default x-axis position
        print("aaa:\(xMax + kLengthDistanceFromYAxis - hostView.bounds.size.width) bbb:\(hostView.bounds.size.width)")
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMax - hostView.bounds.size.width), lengthDecimal: CPTDecimalFromCGFloat(hostView.bounds.size.width))
        
        self.configureXAxisLabelsWithSpace(space: space)
        
        // configure y-axis
        let modMinY = self.minValue - fmodf(self.minValue , 10)
        let modMaxY = self.nearestMutipleOf10From(number: self.maxValue)
        let modDelta = ceilf(modMaxY - modMinY)
        let increment = self.nearestMutipleOf10From(number: ceilf(modDelta / 1.5))
        var line0 = modMinY
        
        if abs(self.minValue - line0) < increment {
            var extraIncrement = self.nearestMutipleOf10From(number: ceilf(increment / 2))
            extraIncrement = line0 - extraIncrement < 0 ? line0 : extraIncrement
            line0 -= extraIncrement
        }
        
        let line3 = line0 + increment * 3
        print("line0: \(line0) line3: \(line3)")
        
        space.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(line0), lengthDecimal: CPTDecimalFromFloat(line3 - line0))
        space.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(line0), lengthDecimal: CPTDecimalFromFloat(line3 - line0))
        
        self.configureYAxisLabelsWithMin(min: line0, max: line3, increment: increment)
    }
    
    private func configureXAxisLabelsWithSpace(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }
        
        if let xAxis = axisSet.xAxis {
            var xLabels = Set<CPTAxisLabel>()
            
            for index in 0..<dataArray.count {
                let i = CGFloat(index)
                let location = kLengthDistanceFromYAxis + i * (hostView.bounds.size.width / 3.0)
                
                if space.xRange.minLimit.floatValue < Float(location) && Float(location) < space.xRange.maxLimit.floatValue {
                    print("date:\(dataArray[index].date) location:\(location)")
                    let label = CPTAxisLabel(text: dataArray[index].date, textStyle: textStyle)
                    label.tickLocation = NSNumber(value: Float(location))
                    label.alignment = .center
                    label.offset = 10
                    xLabels.insert(label)
                }
            }
            xAxis.axisLabels = xLabels
        }
    }
    
    private func configureYAxisLabelsWithMin(min: Float, max: Float, increment: Float) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }
        
        if let yAxis = axisSet.yAxis {
            
            var yLabels = Set<CPTAxisLabel>()
            var yMajorLocations = Set<NSNumber>()
            
            for i in stride(from: min, to: max, by: increment) {
                if i == min {
                    continue
                }
                let label = CPTAxisLabel(text: String(i), textStyle: textStyle)
                let location = CPTDecimalFromFloat(i)
                label.tickLocation = location as NSNumber
                label.alignment = .left
                label.offset = 10
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }
            
            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
        }
    }
    
    private func nearestMutipleOf10From(number: Float) -> Float {
        return round((number + 5) / 10) * 10
    }

}

extension ViewController: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        print("number of records:\(dataArray.count)")
        return UInt(dataArray.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }
        
        switch field {
        case .X:
            print("data source: X \(kLengthDistanceFromYAxis + CGFloat(idx) * (hostView.bounds.size.width / 3.0))")
            return kLengthDistanceFromYAxis + CGFloat(idx) * (hostView.bounds.size.width / 3.0) as NSNumber
        case .Y:
            print("data source: Y \(dataArray[Int(idx)].value)")
            return dataArray[Int(idx)].value as NSNumber
        @unknown default:
            return nil
        }
    }
}

extension ViewController: CPTPlotSpaceDelegate {
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

    func plotSpace(_ space: CPTPlotSpace, didChangePlotRangeFor coordinate: CPTCoordinate) {
        guard let space = space as? CPTXYPlotSpace else {
            return
        }
        self.configureXAxisLabelsWithSpace(space: space)
    }
}

extension ViewController: CPTScatterPlotDataSource {
    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineWidth = 2
        symbolLineStyle.lineColor = .white()
        
        
        let symbol = CPTPlotSymbol.ellipse()
        symbol.fill = CPTFill(color: CPTColor.blue())
        symbol.lineStyle = symbolLineStyle
        symbol.size = CGSize(width: 10, height: 10)
        return symbol
    }
    
    func dataLabel(for plot: CPTPlot, record idx: UInt) -> CPTLayer? {
        let label = CPTTextLayer()
        label.text = String(dataArray[Int(idx)].value)
        label.textStyle = textStyle
        
        return label
    }
}
