//
//  ScaleScatterChartView.swift
//  corePlotTest
//
//  Created by lai Kuan-Ting on 2021/6/30.
//  Copyright © 2021 h2. All rights reserved.
//

import Foundation
import CorePlot

struct pointEntry {
    let value: Float
    let date: Date
}

extension pointEntry: Comparable {
    static func < (lhs: pointEntry, rhs: pointEntry) -> Bool {
        return lhs.value < rhs.value
    }

    static func == (lhs: pointEntry, rhs: pointEntry) -> Bool {
        return lhs.value == rhs.value
    }
}


struct AxisScaleModel {
    let min: Float
    let interval: Float
}

class ScaleScatterChartView: UIView {
    // swiftlint:disable implicitly_unwrapped_optional
    var hostView: CPTGraphHostingView!
    // swiftlint:enable implicitly_unwrapped_optional
    var kLengthDistanceFromYAxis: CGFloat = 0
    var minDataArray: [pointEntry] = []
    var maxDataArray: [pointEntry] = []

    lazy var hostViewWidth: CGFloat = {
        return hostView.bounds.size.width
    }()

    var widthPoint: CGFloat = 0
    var chartCountInView: CGFloat = 0
    private var isDrag: Bool = false
    private let yAxisCount = 4

    // create chart
    lazy var scatterChart: CPTScatterPlot = {
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        scatterChart.dataSource = self
        scatterChart.delegate = self
        scatterChart.title = "first"
        return scatterChart
    }()

    lazy var secondScatterChart: CPTScatterPlot = {
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        scatterChart.dataSource = self
        scatterChart.delegate = self
        scatterChart.title = "second"
        return scatterChart
    }()

    private func initPlot() {
        configureHost()
        configureGraph()
        configureScatter()
        configureSecondScatter()
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
        hostView = CPTGraphHostingView(frame: bounds)
        hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostView.allowPinchScaling = false
        hostView.backgroundColor = UIColor.paleGrayColor()
        addSubview(hostView)
    }

    private func configureGraph() {
        // 1 - Create the graph
        let graph = CPTXYGraph(frame: hostView.frame)
        graph.fill = CPTFill(color: CPTColor.clear())
        graph.plotAreaFrame?.masksToBorder = false
        graph.paddingTop = 10
        graph.paddingBottom = 32
        graph.paddingLeft = 30
        graph.paddingRight = 30
        hostView.hostedGraph = graph
    }

    private func configureScatter() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }

        hostGraph.add(scatterChart)
    }

    private func configureSecondScatter() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }

        hostGraph.add(secondScatterChart)
    }

    private func configureAxes() {
        // 1 - Get axis set
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let xAxis = axisSet.xAxis, let yAxis = axisSet.yAxis else {
            return
        }

        // 2 - Create styles
        let xAxisLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 1, lineColor: CPTColor.gray300())
        let yAxisLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 0.5, lineColor: CPTColor.gray300())

        // 3 - Configure x-axis
        let axisXConstraints = CPTConstraints.constraint(withLowerOffset: 0)
        xAxis.axisConstraints = axisXConstraints
        xAxis.axisLineStyle = xAxisLineStyle
        xAxis.labelingPolicy = .none
        xAxis.labelTextStyle = CPTMutableTextStyle.dashBoardTextStyle()

        // 4 - Configure scatter-axis
        let axisYConstraints = CPTConstraints.constraint(withLowerOffset: 0)
        yAxis.axisConstraints = axisYConstraints
        yAxis.axisLineStyle = yAxisLineStyle
        yAxis.majorGridLineStyle = yAxisLineStyle
        yAxis.labelingPolicy = .none
        yAxis.labelTextStyle = CPTMutableTextStyle.dashBoardTextStyle()
        yAxis.majorTickLength = 0
    }

    func reloadCharts() {
        minDataArray = generateFakeData(isMin: true)
        print("minDataArray:\(minDataArray)")
        maxDataArray = generateFakeData(isMin: false)
        print("maxDataArray:\(maxDataArray)")
        chartCountInView = CGFloat(minDataArray.count)

        widthPoint = hostViewWidth / 6
        kLengthDistanceFromYAxis = widthPoint / 2
        let normalLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 2, lineColor: CPTColor.dashboardNormal())
        scatterChart.dataLineStyle = normalLineStyle
        let secondScatterLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 2, lineColor: CPTColor.gray500())
        secondScatterChart.dataLineStyle = secondScatterLineStyle

        configureAxisLabels()
        hostView.hostedGraph?.reloadData()
    }
    
    private func generateFakeData(isMin: Bool) -> [pointEntry] {
        var intRandomRange: Int = 0

        var dataArray: [pointEntry] = []
        let date = Date()
        let components = date.get(.day, .month, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            let dateComponents = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
            let startInterval = dateComponents.date?.timeIntervalSince1970 ?? 0
            let daySeconds: Int = 86400
            let days: Int = 30

            for index in Array(0...days) {

                intRandomRange = isMin ? Int.random(in: 70...100) : Int.random(in: 101...140)

                let date = Date(timeIntervalSince1970: startInterval - Double((daySeconds * index)))
                dataArray.append(pointEntry(value: Float(intRandomRange), date: date))
            }

            return dataArray

        }

        return []
    }
    
    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        space.allowsUserInteraction = true
        space.delegate = self

        // configure x-axis
        
        let xMin: CGFloat = 0
        let count: CGFloat = CGFloat(minDataArray.count)

        let xWidth: CGFloat = count * widthPoint
        let xMax = max(hostViewWidth, xWidth)
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xMax - xMin))
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMax - hostViewWidth), lengthDecimal: CPTDecimalFromCGFloat(hostViewWidth))

        configureXAxisLabelsWithSpace(space: space)
        let minValue = minDataArray.min()?.value ?? 0
        let maxValue = maxDataArray.max()?.value ?? 0

        let yAxisModel = fetchAxisRange(min: minValue, max: maxValue, axisCount: 4)

        configureYAxisLabelsWithScatter(yMin: yAxisModel.min, majorIncrement: yAxisModel.interval)
    }

    private func configureXAxisLabelsWithSpace(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }

        if let xAxis = axisSet.xAxis {
            var xLabels = Set<CPTAxisLabel>()

            for index in 0..<minDataArray.count {
                let records = minDataArray[index]
                let text = date2String(records.date, dateFormat: "M/dd")
                let location = kLengthDistanceFromYAxis + CGFloat(index) * widthPoint
                let label = CPTAxisLabel(text: text, textStyle: CPTMutableTextStyle.dashBoardTextStyle())
                label.tickLocation = NSNumber(value: Float(location))
                label.alignment = .center
                label.offset = 5
                xLabels.insert(label)
            }
            xAxis.axisLabels = xLabels
        }
    }

    private func configureYAxisLabelsWithScatter(yMin: Float, majorIncrement: Float) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let space = hostView.hostedGraph?.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        if let yAxis = axisSet.yAxis {

            var yLabels = Set<CPTAxisLabel>()
            var yMajorLocations = Set<NSNumber>()
            space.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(yMin), lengthDecimal: CPTDecimalFromFloat(Float(yAxisCount) * majorIncrement))
            space.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(yMin), lengthDecimal: CPTDecimalFromFloat(Float(yAxisCount) * majorIncrement))
            let yMax = yMin + (majorIncrement * Float(yAxisCount))

            for index in stride(from: yMin, to: yMax + majorIncrement, by: majorIncrement) {
                let labelText = "\(index.clean)"
                let label = CPTAxisLabel(text: labelText, textStyle: CPTMutableTextStyle.dashBoardTextStyle())
                let location = CPTDecimalFromFloat(index)
                label.tickLocation = location as NSNumber
                label.alignment = .right
                label.offset = 0
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }

            let unitLabel = CPTAxisLabel(text: "unit", textStyle: CPTMutableTextStyle.dashBoardTextStyle())
            let unitLocation = CPTDecimalFromFloat(yMin + majorIncrement * Float(yAxisCount))
            unitLabel.tickLocation = unitLocation as NSNumber
            unitLabel.alignment = .center
            unitLabel.offset = 0
            yLabels.insert(unitLabel)

            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
        }
    }
    
    private func fetchAxisRange(min: Float, max: Float, axisCount: Int, ignoreFloatScale: Bool = true) -> AxisScaleModel {
        let finalMax = ceil(max)
        var finalMin = floor(min)

        let diff = finalMax - finalMin

        let spaceFloat = Float(axisCount)

        if ignoreFloatScale == false && 1 * diff < 0.5 * spaceFloat {
            finalMin = finalMax - 0.5 * spaceFloat < 0 ? 0 : finalMax - 0.5 * spaceFloat
            return AxisScaleModel(min: finalMin, interval: 0.5)
        }

        // The max value for pressure, weight, glucose is 999, so 500 * 3 = 1200 is enough
        let axisArray: [Float] = [1, 2, 3, 4, 5, 10, 15, 20, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500]

        for axis in axisArray where finalMax - finalMin < axis * spaceFloat {
            var axisMin = finalMin
            if axis > axisMin {
                axisMin = axis - axis
            } else if axisMin == min {
                axisMin -= axis
            }
            // 如果最大值沒辦法超過中線、可以讓最小值再減一個格距、這樣圖看起來才不會偏下
            if finalMax <= axis * (spaceFloat / 2) + axisMin {
                axisMin -= axis
            }

            // finalMin - Float(Int(finalMin) % Int(axis)) 可以讓yAxis的刻度變好看
            axisMin -= Float(Int(axisMin) % Int(axis))

            axisMin = axisMin < 0 ? 0 : axisMin

            if finalMax < axis * spaceFloat + axisMin {
                return AxisScaleModel(min: axisMin, interval: axis)
            }
        }

        // 應該上面就處理完不應該跑到這裡、所以只帶初始值
        return AxisScaleModel(min: finalMin, interval: 50)
    }
    
    private func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }

}

extension ScaleScatterChartView: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return plot.title == "first" ? UInt(maxDataArray.count) : UInt(minDataArray.count)
    }

    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        if let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) {
            let scatter = plot.title == "first" ? maxDataArray[Int(idx)] : minDataArray[Int(idx)]

            switch field {
            case .X:
                let location = kLengthDistanceFromYAxis + CGFloat(idx) * widthPoint
                return location
            case .Y:
                return scatter.value
            @unknown default:
                return nil
            }

        } else {
            return nil
        }
    }

}

extension ScaleScatterChartView: CPTScatterPlotDataSource {
    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {

        return CPTPlotSymbol.normalScatterSymbol()
    }
}

extension ScaleScatterChartView: CPTPlotSpaceDelegate {
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

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDownEvent event: UIEvent, at point: CGPoint) -> Bool {

        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDraggedEvent event: UIEvent, at point: CGPoint) -> Bool {
        guard (space.plotPoint(for: event)?[1].floatValue) != nil else {
            return false
        }

        isDrag = true
        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {

        if !isDrag {
            let anchorPoint = space.plotPoint(for: event)?.first?.floatValue ?? 0
            print("anchorPoint:\(anchorPoint)")
        }

        isDrag = false

        return true
    }
}

extension Float {
    var clean: String {
           return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        }
}
