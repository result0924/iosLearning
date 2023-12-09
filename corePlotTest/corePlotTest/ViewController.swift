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

enum dataType {
    case year
    case month
}

let kLengthDistanceFromYAxis: CGFloat = 60
let kLengthDistanceToYAxis: CGFloat = 60

class ViewController: UIViewController, CPTAxisDelegate {
    @IBOutlet weak var plotView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var hostView: CPTGraphHostingView!
    var dataArray: [dataModle] = []
    var symbolTextAnnotation: CPTPlotSpaceAnnotation?
    var fromYear: Int = 0
    var toYear: Int = 0
    var fromMonth: Int = 0
    var minDate: Date = Date()
    var maxDate: Date = Date()
    var chartType: dataType = .month
    var minDateTimeInterval: TimeInterval = 0
    var maxDateTimeInterval: TimeInterval = 0
    var chartRange: CGFloat = 0
    var minValue: Float = 0
    var maxValue: Float = 0
    var xLocationArray: [Float] = []
    var upBound: Float = 0
    var selectIdx: UInt = 0
    
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
    
    lazy var calendar: Calendar = {
       return Calendar.init(identifier: .gregorian)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // user1 glucose_ac
        let data1 = dataModle(value: 142, date: "2017-01-01")
        let data2 = dataModle(value: 191, date: "2017-12-31")
        let data3 = dataModle(value: 143, date: "2018-01-01")
        let data4 = dataModle(value: 80, date: "2018-12-31")
        let data5 = dataModle(value: 126, date: "2019-01-01")
        
        dataArray = [data1, data2, data3, data4, data5]
        titleLabel.text = "user1 glucose_ac"
        
        initPlot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCharts()
    }
    
    // MARK - Private
    
    private func reloadCharts() {
        dismissCrossHairAndAnnotation()
        xLocationArray = []
        self.configurePlotData()
        self.configureAxisLabels()
        self.hostView.hostedGraph?.reloadData()
    }
    
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
        
        graph.plotAreaFrame?.paddingTop = 60
        graph.plotAreaFrame?.paddingBottom = 50
        graph.plotAreaFrame?.paddingLeft = 50
    }
    
    private func configureChart() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }
        
        // create chart
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        let blueLineStyle = CPTMutableLineStyle()
        blueLineStyle.lineWidth = 3.0
        blueLineStyle.lineColor = .chartBlue(alpha: 1)
        scatterChart.labelOffset = 6
        scatterChart.dataLineStyle = blueLineStyle
        scatterChart.dataSource = self
        scatterChart.delegate = self
        
        // fill area under the plot
//        let areaColor = CPTColor(componentRed: 240, green: 240, blue: 240, alpha: 1)
//        let areaGradient = CPTGradient(beginning: CPTColor.clear(), ending: areaColor)
//        let areaGradientFill = CPTFill(gradient: areaGradient)
//        scatterChart.areaFill = areaGradientFill
//        scatterChart.areaBaseValue = 0
        
        hostGraph.add(scatterChart)
    }
    
    private func configureAxes() {
        // get axis set
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let graph = hostView.hostedGraph else {
            return
        }
        
        // configure x-axis
        if let xAxis = axisSet.xAxis {
            let axisXConstraints = CPTConstraints.constraint(withLowerOffset: 0)
            xAxis.axisConstraints = axisXConstraints
            xAxis.axisLineStyle = axisLineStyle
            xAxis.labelingPolicy = .none
            xAxis.labelTextStyle = textStyle
        }
        
        // configure y-axis
        if let yAxis = axisSet.yAxis {
            let axisYconstraints = CPTConstraints.constraint(withLowerOffset: 0)
            yAxis.axisConstraints = axisYconstraints
            let yAxisLineStyle = CPTMutableLineStyle()
            yAxisLineStyle.lineWidth = 0
            yAxisLineStyle.lineColor = .clear()
            yAxis.axisLineStyle = yAxisLineStyle
            yAxis.majorGridLineStyle = axisLineStyle
            yAxis.labelingPolicy = .none
            yAxis.labelTextStyle = textStyle
            
            let bandFill = CPTFill.init(color: .chartBlue(alpha: 0.2))
            let bandRange = CPTPlotRange.init(location: 135, length: 50)
            yAxis.addBackgroundLimitBand(CPTLimitBand.init(range: bandRange, fill: bandFill))
        }
        
        // configure crosshair-axis
        let crosshair = CPTXYAxis()
        crosshair.isHidden = true
        crosshair.coordinate = .X
        crosshair.plotSpace = hostView.hostedGraph?.defaultPlotSpace
        crosshair.axisConstraints = CPTConstraints(lowerOffset: 0)
        crosshair.labelingPolicy = .none
        crosshair.majorGridLineStyle = axisLineStyle
        let crosshairLineStyle = CPTMutableLineStyle()
        crosshairLineStyle.lineWidth = 0
        crosshairLineStyle.lineColor = .clear()
        crosshair.axisLineStyle = crosshairLineStyle
        
        graph.axisSet?.axes = [axisSet.xAxis, axisSet.yAxis, crosshair] as? [CPTAxis]
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
    
    private func configureDate() {
        minDateTimeInterval = dataArray.first?.date.date?.timeIntervalSince1970 ?? 0
        maxDateTimeInterval = dataArray.first?.date.date?.timeIntervalSince1970 ?? 0
        
        for data in dataArray {
            if let dateTimeInterval = data.date.date?.timeIntervalSince1970 {
                if dateTimeInterval < minDateTimeInterval {
                    minDateTimeInterval = dateTimeInterval
                }
                
                if dateTimeInterval > maxDateTimeInterval {
                    maxDateTimeInterval = dateTimeInterval
                }
            }
        }
        
        minDate = Date.init(timeIntervalSince1970: minDateTimeInterval)
        fromMonth = calendar.component(.month, from: minDate)
        fromYear = calendar.component(.year, from:minDate)
        maxDate = Date.init(timeIntervalSince1970: maxDateTimeInterval)
        toYear = calendar.component(.year, from: maxDate) + 1
    }
    
    private func fetchMonthCount() -> CGFloat {
        configureDate()
        
        let components = calendar.dateComponents([.month], from: minDate, to: maxDate)
        
        return CGFloat(components.month ?? 0) + 1
    }
    
    private func fetchYearCount() -> CGFloat {
        configureDate()

        let range: CGFloat = CGFloat(ceil((maxDateTimeInterval - minDateTimeInterval) / 86400 / 365)) + 1
        
        return range
    }
    
    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }
        
        space.allowsUserInteraction = true
        space.delegate = self
        
        // configure x-axis
        let xMin: CGFloat = 0
        let count: CGFloat = chartType == .year ? fetchYearCount() : fetchMonthCount()
        chartRange = chartType == .year ? 5 : 12
        let xWidth: CGFloat = hostView.bounds.size.width * (count / chartRange) + kLengthDistanceFromYAxis
        let xMax = max(xMin, xWidth)
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xMax - xMin))
        
        // default x-axis position
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMax - hostView.bounds.size.width), lengthDecimal: CPTDecimalFromCGFloat(hostView.bounds.size.width))
        
        self.configureXAxisLabelsWithSpace(space: space)
        
        // configure y-axis
        self.configureYAxisLabelsWithMin(min: minValue, max: maxValue, numTicks: 5)
    }
    
    private func configureXAxisLabelsWithSpace(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }
        
        if let xAxis = axisSet.xAxis {
            
            switch chartType {
            case .year:
                var xLabels = Set<CPTAxisLabel>()
                
                let firstDayString = String(fromYear) + "-01-01"
                let endDayString = String(toYear) + "-12-31"
                
                guard let fromDate = firstDayString.date, let endDate = endDayString.date else {
                    return
                }
                
                let components = calendar.dateComponents([.day], from: fromDate, to: endDate)
                let widthPoint = hostView.bounds.size.width * (fetchYearCount() / chartRange) / CGFloat(components.day ?? 0)
                
                for index in 0..<Int(fetchYearCount()) {
                    let i = CGFloat(index) * 365
                    let location = kLengthDistanceFromYAxis + i * widthPoint
                    
                    let label = CPTAxisLabel(text: String(index + fromYear), textStyle: textStyle)
                    label.tickLocation = NSNumber(value: Float(location))
                    label.alignment = .center
                    label.offset = 5
                    xLabels.insert(label)
                }
                xAxis.axisLabels = xLabels
            default:
                var xLabels = Set<CPTAxisLabel>()
                var showYear = fromMonth == 1 ? fromYear : fromYear + 1
                var rightYear = fromYear
                
                let startComponents = calendar.dateComponents([.year, .month], from: minDate)
                let fromDate = calendar.date(from: startComponents) ?? Date()
                let endComponents = calendar.dateComponents([.year, .month], from: maxDate)
                let maxDateStartOfMonth = calendar.date(from: endComponents) ?? Date()
                let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: maxDateStartOfMonth) ?? Date()
                
                let components2 = calendar.dateComponents([.day], from: fromDate, to: endDate)
                let widthPoint = hostView.bounds.size.width * (fetchMonthCount() / chartRange) / CGFloat(components2.day ?? 0)
       
                for index in 0...Int(fetchMonthCount()) {
                    let month = index + fromMonth
                    var text = month % 12 == 0 ? "12" : String(month % 12)
                    
                    if month % 12 == 1 {
                        text = text + "\n" + String(showYear)
                        showYear += 1
                        
                        if 0 != index {
                            rightYear += 1
                        }
                    }
                    
                    let dateComponents = DateComponents(year: rightYear, month: Int(text) ?? 1)
                    
                    guard let monthDate = calendar.date(from: dateComponents) else {
                        return
                    }
                    let monthFromFirstMonthDay = calendar.dateComponents([.day], from: fromDate, to: monthDate).day
                    let location = kLengthDistanceFromYAxis + CGFloat(monthFromFirstMonthDay ?? 0) * widthPoint

                    let label = CPTAxisLabel(text: text, textStyle: textStyle)
                    label.tickLocation = NSNumber(value: Float(location))
                    label.alignment = .center
                    label.offset = 5
                    xLabels.insert(label)
                }
                xAxis.axisLabels = xLabels
            }
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
                yMin = yMin - 0.2 * abs(yMin)
                yMax = yMax + 0.2 * abs(yMax)
            }
            
            let yRange = yMax - yMin
            let rawStep = yRange / Float(numTicks - 2)
            let mag = floor(log10(rawStep))
            let magPow = pow(10, mag)
            let magMsd = Int(rawStep / magPow + 0.5)
            let stepSize = Float(magMsd) * magPow
            
            var lowBound = stepSize * floor(yMin / stepSize)
            upBound = stepSize * floor(yMax / stepSize + 1)
            
            if yMin - lowBound < 0.2 * stepSize {
                lowBound = (lowBound - stepSize < 0 && lowBound >= 0) ? lowBound : lowBound - stepSize
            }
            
            if upBound - yMax < 0.2 * stepSize {
                upBound = (upBound + stepSize > 0 && upBound <= 0) ? upBound : upBound + stepSize
            }
            
            space.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(lowBound), lengthDecimal: CPTDecimalFromFloat(upBound - lowBound))
            space.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(lowBound), lengthDecimal: CPTDecimalFromFloat(upBound - lowBound))
            
            for i in stride(from: lowBound, to: upBound, by: stepSize) {
                let label = CPTAxisLabel(text: String(i).formatFloatByNumber(digit: 1), textStyle: textStyle)
                let location = CPTDecimalFromFloat(i)
                label.tickLocation = location as NSNumber
                label.alignment = .center
                label.offset = 10
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }
            
            let label = CPTAxisLabel(text: String(upBound).formatFloatByNumber(digit: 1), textStyle: textStyle)
            let location = CPTDecimalFromFloat(upBound)
            label.tickLocation = location as NSNumber
            label.alignment = .center
            label.offset = 10
            yLabels.insert(label)
            yMajorLocations.insert(upBound as NSNumber)
            
            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
            let yAxisLineStyle = CPTMutableLineStyle()
            yAxisLineStyle.lineWidth = 0
            yAxisLineStyle.lineColor = .clear()
            yAxis.majorTickLineStyle = yAxisLineStyle
        }
    }
    
    private func dismissCrossHairAndAnnotation() {
        guard let hostGraph = hostView.hostedGraph, let crossHair = hostGraph.axisSet?.axes?[2] as? CPTXYAxis else {
            return
        }
        
        crossHair.majorTickLocations = []
        crossHair.isHidden = true
        
        if symbolTextAnnotation != nil {
            hostView.hostedGraph?.plotAreaFrame?.plotArea?.removeAnnotation(symbolTextAnnotation)
            symbolTextAnnotation = nil
        }
    }
    
    @IBAction func tapDataChange(_ sender: UISegmentedControl) {
        if 0 == sender.selectedSegmentIndex {
            // user1 glucose_ac
            let data1 = dataModle(value: 142, date: "2017-01-01")
            let data2 = dataModle(value: 191, date: "2017-12-31")
            let data3 = dataModle(value: 143, date: "2018-01-01")
            let data4 = dataModle(value: 80, date: "2018-12-31")
            let data5 = dataModle(value: 126, date: "2019-01-01")
            
            dataArray = [data1, data2, data3, data4, data5]
            titleLabel.text = "user1 glucose_ac"
            reloadCharts()
        } else if 1 == sender.selectedSegmentIndex {
            // user1202 wbc_count
            let data1 = dataModle(value: 5.5, date: "2016-11-03")
            let data2 = dataModle(value: 6.5, date: "2017-02-03")
            let data3 = dataModle(value: 4.7, date: "2017-08-01")
            let data4 = dataModle(value: 5.7, date: "2017-11-03")
            let data5 = dataModle(value: 5.1, date: "2017-12-02")
            let data6 = dataModle(value: 4.6, date: "2018-01-04")
            let data7 = dataModle(value: 4, date: "2018-05-02")
            let data8 = dataModle(value: 4.3, date: "2018-06-03")
            let data9 = dataModle(value: 5, date: "2018-07-04")
            let data10 = dataModle(value: 4.6, date: "2018-08-03")
            let data11 = dataModle(value: 5.4, date: "2018-09-01")
            
            dataArray = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11]
            titleLabel.text = "user1202 wbc_count"
            reloadCharts()
        } else if 2 == sender.selectedSegmentIndex {
            // user1202 glucose_ac
            let data1 = dataModle(value: 303, date: "2016-11-03")
            let data2 = dataModle(value: 201, date: "2017-02-03")
            let data3 = dataModle(value: 141, date: "2017-08-01")
            let data4 = dataModle(value: 235, date: "2017-11-03")
            let data5 = dataModle(value: 192, date: "2017-12-02")
            let data6 = dataModle(value: 246, date: "2018-01-04")
            let data7 = dataModle(value: 100, date: "2018-04-17")
            let data8 = dataModle(value: 154, date: "2018-05-02")
            let data9 = dataModle(value: 180, date: "2018-06-03")
            let data10 = dataModle(value: 192, date: "2018-07-04")
            let data11 = dataModle(value: 184, date: "2018-08-03")
            let data12 = dataModle(value: 161, date: "2018-09-01")
            
            dataArray = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12]
            titleLabel.text = "user1202 glucose_ac"
            reloadCharts()
        } else if 3 == sender.selectedSegmentIndex {
            // user1345 wbc_count
            let data1 = dataModle(value: 11.8, date: "2017-02-03")
            let data2 = dataModle(value: 9.5, date: "2017-07-04")
            let data3 = dataModle(value: 9.6, date: "2017-08-03")
            let data4 = dataModle(value: 10.2, date: "2017-09-02")
            let data5 = dataModle(value: 10.8, date: "2017-10-03")
            let data6 = dataModle(value: 9.7, date: "2017-11-02")
            let data7 = dataModle(value: 9.2, date: "2018-01-03")
            let data8 = dataModle(value: 9.6, date: "2018-02-04")
            let data9 = dataModle(value: 9.3, date: "2018-04-03")
            let data10 = dataModle(value: 9.5, date: "2018-05-03")
            let data11 = dataModle(value: 10.1, date: "2018-09-03")
            
            dataArray = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11]
            titleLabel.text = "user1345 wbc_count"
            reloadCharts()
        } else if 4 == sender.selectedSegmentIndex {
            // user12 egfr
            let data1 = dataModle(value: 77.168, date: "2014-04-19")
            let data2 = dataModle(value: 87.793, date: "2014-07-16")
            let data3 = dataModle(value: 48.205, date: "2016-08-27")
            let data4 = dataModle(value: 58.738, date: "2017-10-20")
            
            dataArray = [data1, data2, data3, data4]
            titleLabel.text = "user12 egfr"
            reloadCharts()
        }
        
    }
    
    @IBAction func tapSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            chartType = .month
            reloadCharts()
        } else {
            chartType = .year
            reloadCharts()
        }
    }
}

extension ViewController: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(dataArray.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }
        
        switch field {
        case .X:
            switch chartType {
            case .year:
                if fromYear == 0 {
                    return nil
                }
                
                let firstDayString = String(fromYear) + "-01-01"
                let endDayString = String(toYear) + "-12-31"
                
                if let fromDate = firstDayString.date, let date = dataArray[Int(idx)].date.date, let endDate = endDayString.date {
                    let components = calendar.dateComponents([.day], from: fromDate, to: date)
                    let components2 = calendar.dateComponents([.day], from: fromDate, to: endDate)
                    let widthPoint = hostView.bounds.size.width * (fetchYearCount() / chartRange) / CGFloat(components2.day ?? 0)
                    let xIndex = widthPoint * CGFloat(components.day ?? 0) + kLengthDistanceFromYAxis as NSNumber
                    
                    if !xLocationArray.contains(xIndex.floatValue) {
                        xLocationArray.append(xIndex.floatValue)
                    }

                    return xIndex
                }
                return nil
            default:
                if fromMonth == 0 {
                    return nil
                }
                
                let startComponents = calendar.dateComponents([.year, .month], from: minDate)
                let fromDate = calendar.date(from: startComponents) ?? Date()
                let endComponents = calendar.dateComponents([.year, .month], from: maxDate)
                let maxDateStartOfMonth = calendar.date(from: endComponents) ?? Date()
                let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: maxDateStartOfMonth) ?? Date()
                
                if let date = dataArray[Int(idx)].date.date {
                    let components = calendar.dateComponents([.day], from: fromDate, to: date)
                    let components2 = calendar.dateComponents([.day], from: fromDate, to: endDate)
                    let widthPoint = hostView.bounds.size.width * (fetchMonthCount() / chartRange) / CGFloat(components2.day ?? 0)
                    let xIndex = widthPoint * CGFloat(components.day ?? 0) + kLengthDistanceFromYAxis as NSNumber

                    if !xLocationArray.contains(xIndex.floatValue) {
                        xLocationArray.append(xIndex.floatValue)
                    }
                    return xIndex
                }
                return nil
            }
        case .Y:
            return dataArray[Int(idx)].value as NSNumber
        @unknown default:
            return nil
        }
    }
    
    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDownEvent event: UIEvent, at point: CGPoint) -> Bool {
 
        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDraggedEvent event: UIEvent, at point: CGPoint) -> Bool {
        guard let yPoint = space.plotPoint(for: event)?[1].floatValue else {
            return false
        }
        
        if yPoint < minValue {
            return false
        }
        
//        let anchorPoint = space.plotPoint(for: event)?.first?.floatValue ?? 0
//        print("anchorPoint:\(anchorPoint)")

        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {

        return true
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
        symbolLineStyle.lineWidth = idx == selectIdx ? 10 : 2
        symbolLineStyle.lineColor = idx == selectIdx ? .chartRed(alpha: 0.3) : .white()
        
        let symbol = CPTPlotSymbol.ellipse()
        symbol.fill = idx == selectIdx ? CPTFill(color: .chartRed(alpha: 1)) : CPTFill(color: .chartBlue(alpha: 1))
        symbol.lineStyle = symbolLineStyle
        symbol.size = CGSize(width: 10, height: 10)
        
        return symbol
    }
    
    func dataLabel(for plot: CPTPlot, record idx: UInt) -> CPTLayer? {
        let label = CPTTextLayer()
        let text = String(dataArray[Int(idx)].value) + "\n" + dataArray[Int(idx)].date
        
        let myAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
        let myString: NSAttributedString = NSAttributedString.init(string: text, attributes: myAttributes)
        label.attributedText = myString
        
        label.text = ""
        
        let symbolTextStyle = CPTMutableTextStyle()
        symbolTextStyle.color = .chartBlue(alpha: 1)
        symbolTextStyle.fontName = UIFont.systemFont(ofSize: 13).fontName
        symbolTextStyle.fontSize = 13.0
        symbolTextStyle.textAlignment = .center

        label.textStyle = symbolTextStyle
        label.paddingBottom = 30
        
        return label
    }
}

extension ViewController: CPTScatterPlotDelegate {
    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt, with event: UIEvent) {
        dismissCrossHairAndAnnotation()
        
        guard let hostGraph = hostView.hostedGraph, let crossHair = hostGraph.axisSet?.axes?[2] as? CPTXYAxis else {
            return
        }
        
        selectIdx = idx
        
        // Now add the annotation to the plot area
        let textLayer = CPTTextLayer.init(text: "")
        textLayer.isOpaque = false
        textLayer.fill = CPTFill(color: .clear())
        textLayer.paddingLeft = 5
        textLayer.paddingTop = 5
        textLayer.paddingRight = 5
        textLayer.paddingBottom = 0
        textLayer.cornerRadius = 10
        textLayer.backgroundColor = UIColor.cBlue(alpha: 1).cgColor
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let myAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)] as [NSAttributedString.Key: Any]
        let date = dataArray[Int(idx)].date
        let value = dataArray[Int(idx)].value
        let myString: NSAttributedString = NSAttributedString.init(string: "\(date)\n\(value)", attributes: myAttributes)
        textLayer.attributedText = myString
        
        var anchorPoint = plot.plotSpace?.plotPoint(for: event)?.first?.floatValue ?? 0
        let closest = xLocationArray.enumerated().min(by: { abs($0.1 - anchorPoint) < abs($1.1 - anchorPoint)})
        anchorPoint = closest?.element ?? 0
        let anchorValue = upBound

        symbolTextAnnotation = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [NSNumber(value: anchorPoint), NSNumber(value: anchorValue)])
        symbolTextAnnotation?.contentLayer = textLayer;
        symbolTextAnnotation?.displacement = CGPoint(x: 0, y: 30);
        hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(symbolTextAnnotation)
        
        var yMajorLocations = Set<NSNumber>()
        yMajorLocations.insert(CPTDecimalFromFloat(anchorPoint) as NSNumber)
        crossHair.majorTickLocations = yMajorLocations
        crossHair.majorTickLength = 0
    
        crossHair.isHidden = false
        self.hostView.hostedGraph?.reloadData()
    }
}
