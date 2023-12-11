//
//  LabResultDetailChartView.swift
//  corePlotTest
//
//  Created by Justin Lai on 2023/12/4.
//  Copyright © 2023 h2. All rights reserved.
//

import UIKit
import CorePlot

struct LabResultDetailChartPointEntry {
    let value: Float
    let date: Date
}

struct LabResultDetailChartViewModel {
    let testDatas: [LabResultDetailChartPointEntry]
    let lowTarget: Float
    let highTarget: Float
    let unit: String
}

enum LabResultDetailChartType {
    case oneYear
    case threeYear
    case fiveYear
}

protocol LabResultDetailChartViewDelegate: AnyObject {
    func tapChartPointingDeviceDown()
    func tapChartPointingDeviceUp()
}

class LabResultDetailChartView: UIView {
    weak var delegate: LabResultDetailChartViewDelegate?
    private let dateTransformer = H2SDateTransformer()
    // swiftlint:disable implicitly_unwrapped_optional
    private var hostView: CPTGraphHostingView!
    // swiftlint:enable implicitly_unwrapped_optional
    private var viewModel = LabResultDetailChartViewModel(testDatas: [], lowTarget: 0, highTarget: 0, unit: "")
    private var ySpaceCount = 3
    private var minDate: Date = Date()
    private var maxDate: Date = Date()
    private var chartType: LabResultDetailChartType = .oneYear
    private var numberOfDivisions: CGFloat = 11

    private var textStyle: CPTMutableTextStyle {
        CPTMutableTextStyle.dashBoardTextStyle()
    }
    
    private var dashStyle: CPTLineStyle {
        let dashLineStyle = CPTMutableLineStyle()
        dashLineStyle.dashPattern = [NSDecimalNumber(value: 3)]
        dashLineStyle.lineColor = CPTColor.gray300()
        
        return dashLineStyle
    }

    private lazy var calendar: Calendar = {
       return Calendar(identifier: .gregorian)
    }()

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

    func reloadCharts() {
        guard let testDate = try? dateTransformer.utcDate(from: "2023-07-01", format: dateTransformer.dateFormat),
        let testDate2 = try? dateTransformer.utcDate(from: "2023-07-31", format: dateTransformer.dateFormat),
                let testDate3 = try? dateTransformer.utcDate(from: "2023-08-01", format: dateTransformer.dateFormat),
                let testDate4 = try? dateTransformer.utcDate(from: "2023-08-31", format: dateTransformer.dateFormat) else {
            return
        }
        viewModel = LabResultDetailChartViewModel(testDatas: [LabResultDetailChartPointEntry(value: 3, date: testDate),
                                                              LabResultDetailChartPointEntry(value: 4, date: testDate2),
                                                              LabResultDetailChartPointEntry(value: 2.5, date: testDate3),
                                                              LabResultDetailChartPointEntry(value: 1.5, date: testDate4), ], lowTarget: 0, highTarget: 0, unit: "%")
        configureAxisLabels()
        hostView.hostedGraph?.reloadData()
    }

    // MARK: - Private

    private func initPlot() {
        configureHost()
        configureGraph()
        configureAxes()
        configureChart()
    }

    private func configureHost() {
        hostView = CPTGraphHostingView(frame: bounds)
        hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostView.allowPinchScaling = false
        hostView.backgroundColor = UIColor.clear
        addSubview(hostView)
    }

    private func configureGraph() {
        // 1 - Create the graph
        let graph = CPTXYGraph(frame: hostView.frame)
        graph.fill = CPTFill(color: CPTColor.clear())
        graph.plotAreaFrame?.masksToBorder = false
        graph.plotAreaFrame?.paddingTop = 0
        graph.plotAreaFrame?.paddingBottom = 30
        graph.plotAreaFrame?.paddingLeft = 30
        graph.plotAreaFrame?.paddingRight = 0
        hostView.hostedGraph = graph
    }

    private func configureChart() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }

        // create chart
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        let greenLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 2, lineColor: CPTColor.chartGreen(alpha: 1))
        scatterChart.labelOffset = 6
        scatterChart.dataLineStyle = greenLineStyle
        scatterChart.dataSource = self

        hostGraph.add(scatterChart)
    }

    private func configureAxes() {
        // get axis set
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let graph = hostView.hostedGraph else {
            return
        }

        let axisLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 1, lineColor: CPTColor.gray300())
        let xAxisDashLineStyle = CPTMutableLineStyle()
        xAxisDashLineStyle.dashPattern = [NSDecimalNumber(value: 3)]
        xAxisDashLineStyle.lineColor = CPTColor.gray300()

        // configure x-axis
        if let xAxis = axisSet.xAxis {
            let axisXConstraints = CPTConstraints.constraint(withLowerOffset: 0)
            xAxis.axisConstraints = axisXConstraints
            xAxis.majorGridLineStyle = xAxisDashLineStyle
            xAxis.axisLineStyle = axisLineStyle
            xAxis.labelingPolicy = .none
        }

        // configure y-axis
        if let yAxis = axisSet.yAxis {
            let axisYconstraints = CPTConstraints.constraint(withLowerOffset: 0)
            yAxis.axisConstraints = axisYconstraints
            yAxis.axisLineStyle = axisLineStyle
            yAxis.majorGridLineStyle = axisLineStyle
            yAxis.labelingPolicy = .none
            yAxis.majorTickLength = 0
        }

        graph.axisSet?.axes = [axisSet.xAxis, axisSet.yAxis] as? [CPTAxis]
    }

    private func configureYAxisLabelModel() -> AxisScaleModel {
        var finalDailyDataMin: Float = viewModel.testDatas.first?.value ?? 0
        var finalDailyDataMax: Float = viewModel.testDatas.first?.value ?? 0
        viewModel.testDatas.forEach { testData in
            let dailyDataMin = testData.value
            let dailyDataMax = testData.value
            finalDailyDataMin = finalDailyDataMin < dailyDataMin ? finalDailyDataMin : dailyDataMin
            finalDailyDataMax = finalDailyDataMax > dailyDataMax ? finalDailyDataMax : dailyDataMax
        }
        let testMinValue = min(finalDailyDataMin, viewModel.lowTarget)
        let testMaxValue = max(finalDailyDataMax, viewModel.highTarget)

        return fetchAxisRange(min: testMinValue, max: testMaxValue, axisCount: ySpaceCount)
    }

    private func configureDate() {
        configureMinDate()
        let maxDateTimeInterval = viewModel.testDatas.last?.date.timeIntervalSince1970 ?? 0
        maxDate = Date(timeIntervalSince1970: maxDateTimeInterval)
    }

    private func configureMinDate() {
        let firstDate = viewModel.testDatas.first?.date ?? Date()
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: firstDate)) ?? Date()

        guard viewModel.testDatas.count > 1 else {
            minDate = startDate
            return
        }

        let endDate = viewModel.testDatas.last?.date ?? Date()

        let components = calendar.dateComponents([.year], from: firstDate, to: endDate)

        if let years = components.year, years >= 1 {
            minDate = startDate
        } else {
            let minDateTimeInterval = viewModel.testDatas.last?.date.add(month: -11).timeIntervalSince1970 ?? 0
            minDate = calendar.date(from: calendar.dateComponents([.year, .month], from: Date(timeIntervalSince1970: minDateTimeInterval))) ?? Date()
        }
    }

    private func fetchMonthCount() -> CGFloat {
        configureDate()
        let components = calendar.dateComponents([.month], from: minDate, to: maxDate)
        return CGFloat(components.month ?? 0)
    }

    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        space.allowsUserInteraction = true
        space.delegate = self

        // configure x-axis
        let xMin: CGFloat = 0
        let count: CGFloat = fetchMonthCount()
        let xWidth: CGFloat = hostView.bounds.size.width * (count / numberOfDivisions)
        let xMax = max(xMin, xWidth)
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xMax - xMin))

        // default x-axis position
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMax - hostView.bounds.size.width), lengthDecimal: CPTDecimalFromCGFloat(hostView.bounds.size.width))

        configureXAxisLabelsWithSpace(space: space)

        // configure y-axis
        let scatterYAxisModel = configureYAxisLabelModel()
        let scatterYMax = scatterYAxisModel.min + Float(ySpaceCount) * scatterYAxisModel.interval
        configureYAxisLabels(yMin: scatterYAxisModel.min, yMax: scatterYMax, majorIncrement: scatterYAxisModel.interval)
    }

    private func configureXAxisLabelsWithSpace(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }

        if let xAxis = axisSet.xAxis {
            let fromYear = calendar.component(.year, from: minDate)
            let fromMonth = calendar.component(.month, from: minDate)
            let fromDate = getStartDate()
            let widthPoint = getWidthPoint()
            var currentYear = fromYear
            var xLabels = Set<CPTAxisLabel>()
            var xMajorLocations = Set<NSNumber>()

            for index in 0...Int(fetchMonthCount()) {
                let month = index + fromMonth
                let text = month % 12 == 0 ? "12" : String(month % 12)

                if month % 12 == 1, 0 != index {
                    currentYear += 1
                }

                let dateComponents = DateComponents(year: currentYear, month: Int(text) ?? 1)

                guard let monthDate = calendar.date(from: dateComponents) else {
                    return
                }
                let monthFromFirstMonthDay = calendar.dateComponents([.day], from: fromDate, to: monthDate).day
                let location = CGFloat(monthFromFirstMonthDay ?? 0) * widthPoint

                let label = CPTAxisLabel(text: text, textStyle: textStyle)
                let lablLocation = NSNumber(value: Float(location))
                label.tickLocation = lablLocation
                label.alignment = .left
                label.offset = 5
                xLabels.insert(label)
                xMajorLocations.insert(lablLocation)
            }
            xAxis.axisLabels = xLabels
            xAxis.majorTickLocations = xMajorLocations
            xAxis.majorTickLength = 30
            let axisLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 1, lineColor: CPTColor.gray300())
            xAxis.majorTickLineStyle = dashStyle
            xAxis.tickDirection = .negative
        }
    }

    private func configureYAxisLabels(yMin: Float, yMax: Float, majorIncrement: Float) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let space = hostView.hostedGraph?.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        if let yAxis = axisSet.yAxis {
            let chartYMax = getChartYMax(yMax: yMax, yMin: yMin)
            var yLabels = Set<CPTAxisLabel>()
            var yMajorLocations = Set<NSNumber>()

            space.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(yMin), lengthDecimal: CPTDecimalFromFloat(chartYMax))
            space.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(yMin), lengthDecimal: CPTDecimalFromFloat(chartYMax))

            for index in stride(from: yMin, to: yMax + majorIncrement, by: majorIncrement) {
                let labelText = "\(index)"
                let label = CPTAxisLabel(text: labelText, textStyle: textStyle)
                let location = CPTDecimalFromFloat(index)
                label.tickLocation = location as NSNumber
                label.alignment = .right
                label.offset = 10
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }

            let labelFont = UIFont.systemFont(ofSize: 12)
            let unitLabel = CPTAxisLabel(text: viewModel.unit, textStyle: textStyle)
            let yLocation = getChartUnitYSite(yMax: yMax, yMin: yMin) + yMin
            let unitLocation = CPTDecimalFromFloat(yLocation)
            unitLabel.tickLocation = unitLocation as NSNumber
            unitLabel.alignment = .center
            unitLabel.offset = -(viewModel.unit.widthOfString(usingFont: labelFont) / 3) + 10
            yLabels.insert(unitLabel)

            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
        }
    }

    private func getChartYMax(yMax: Float, yMin: Float) -> Float {
        return (yMax - yMin) * 6 / 5
    }

    private func getChartUnitYSite(yMax: Float, yMin: Float) -> Float {
        return (yMax - yMin) * 8 / 7
    }

    private func getStartDate() -> Date {
        let startComponents = calendar.dateComponents([.year, .month], from: minDate)
        return calendar.date(from: startComponents) ?? Date()
    }

    private func getWidthPoint() -> CGFloat {
        let fromDate = getStartDate()
        let endComponents = calendar.dateComponents([.year, .month], from: maxDate)
        let maxDateStartOfMonth = calendar.date(from: endComponents) ?? Date()
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: maxDateStartOfMonth) ?? Date()

        let components = calendar.dateComponents([.day], from: fromDate, to: endDate)
        return hostView.bounds.size.width * (fetchMonthCount() / numberOfDivisions) / CGFloat(components.day ?? 0)
    }
    
    private func fetchAxisRange(min: Float, max: Float, axisCount: Int, ignoreFloatScale: Bool = true, isStep: Bool = false) -> AxisScaleModel {
        let finalMax = ceil(max)
        var finalMin = floor(min)

        let diff = finalMax - finalMin

        let spaceFloat = Float(axisCount)

        if ignoreFloatScale == false && 1 * diff < 0.5 * spaceFloat {
            finalMin = finalMax - 0.5 * spaceFloat < 0 ? 0 : finalMax - 0.5 * spaceFloat
            return AxisScaleModel(min: finalMin, interval: 0.5)
        }

        let axisArray1: [Float] = [1, 2, 3, 4, 5, 10, 15, 20, 25, 30, 40]
        let axisArray2: [Float] = isStep ? Array(stride(from: 50, through: 40000, by: 50)) : Array(stride(from: 50, through: 500, by: 50))
        let axisArray = axisArray1 + axisArray2

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
            let yAxisMaxValue = axis * spaceFloat + axisMin

            if finalMax <= yAxisMaxValue {
                return AxisScaleModel(min: axisMin, interval: axis)
            }
        }

        return AxisScaleModel(min: finalMin, interval: 50)
    }

}

extension LabResultDetailChartView: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(viewModel.testDatas.count)
    }

    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }

        switch field {
        case .X:
            let fromDate = getStartDate()
            let date = viewModel.testDatas[Int(idx)].date
            let components = calendar.dateComponents([.day], from: fromDate, to: date)
            let widthPoint = getWidthPoint()
            let xIndex = widthPoint * CGFloat(components.day ?? 0) as NSNumber
            return xIndex
        case .Y:
            return viewModel.testDatas[Int(idx)].value as NSNumber
        @unknown default:
            return nil
        }
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDownEvent event: UIEvent, at point: CGPoint) -> Bool {
        delegate?.tapChartPointingDeviceDown()
        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDraggedEvent event: UIEvent, at point: CGPoint) -> Bool {
        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {
        delegate?.tapChartPointingDeviceUp()
        return true
    }

}

extension LabResultDetailChartView: CPTPlotSpaceDelegate {

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
        configureXAxisLabelsWithSpace(space: space)
    }
}

extension LabResultDetailChartView: CPTScatterPlotDataSource {
    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
        return CPTPlotSymbol.normalScatterSymbol()
    }
}
