//
//  CGMChartViewController.swift
//  corePlotTest
//
//  Created by jlai on 2021/4/22.
//  Copyright © 2021 h2. All rights reserved.
//

import UIKit
import CorePlot

struct CGMDataModel {
    let value: Int
    let date: Date
}

class CGMChartViewController: UIViewController, CPTAxisDelegate {
    @IBOutlet weak var plotView: UIView!
    
    var hostView: CPTGraphHostingView!
    var dataArray: [CGMDataModel] = []
    var startInterval: TimeInterval = 0
    let xAxisCount: CGFloat = 5
    let yAxisBasicValue: CGFloat = 50
    var isDrag = false
    let lowBound: Float = 0
    let padding: CGFloat = 50
    lazy var hostViewWidth: CGFloat = {
        return hostView.bounds.size.width - (padding * 2)
    }()
    var symbolAnnotation: CPTPlotSpaceAnnotation?
    var firstContentLayer: CPTLayer?
    var secondContentLayer: CPTLayer?
    var thirdContentLayer: CPTLayer?
    var fourthContentLayer: CPTLayer?
    let greenColor = UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor
    let grayColor = UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1).cgColor
    
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
        
        let date = Date()
        let components = date.get(.day, .month, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            let dateComponents = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
            startInterval = dateComponents.date?.timeIntervalSince1970 ?? 0
            let quarterSecondNumber: Int = 15 * 60
            let quarterInDay: Int = 96
            
            for index in Array(1...quarterInDay) {
                let date = Date(timeIntervalSince1970: startInterval + Double((quarterSecondNumber * index)))
                dataArray.append(CGMDataModel(value: Int.random(in: 45...250), date: date))
            }
            
        }
        
        initPlot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reloadSymbolAnnotation()
        reloadCharts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK - Private
    
    private func reloadSymbolAnnotation() {
        if symbolAnnotation == nil {
            symbolAnnotation = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [0, 0])
            let contentLayer = CPTLayer.init(frame: CGRect(x: 0, y: 0, width: hostViewWidth / 4, height: hostView.bounds.size.height))
            contentLayer.backgroundColor = UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 0.1).cgColor
            symbolAnnotation?.contentLayer = contentLayer
            symbolAnnotation?.contentAnchorPoint = CGPoint(x: 0, y: 0)
            hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(symbolAnnotation)
        }
        
        for i in 1...4 {
            let pointArray: [Float] = [1, 3, 5, 7]
            let xPoint: NSNumber = NSNumber(value: Float(hostViewWidth) / 86400 * (86400 / 8) * pointArray[i - 1])
            let backgroundAnnotation = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [xPoint, NSNumber(value: Float(hostView.bounds.size.height))])
            
            let padding: CGFloat = 9
            let width = hostViewWidth / 4 - (padding * 2)
            let contentLayer = CPTLayer.init(frame: CGRect(x: 0, y: 0, width: width, height: 24))
            contentLayer.cornerRadius = 12
            contentLayer.backgroundColor = grayColor
            
            if i == 1 {
                contentLayer.backgroundColor = greenColor
                firstContentLayer = contentLayer
                backgroundAnnotation.contentLayer = firstContentLayer
            } else if i == 2 {
                secondContentLayer = contentLayer
                backgroundAnnotation.contentLayer = secondContentLayer
            } else if i == 3 {
                thirdContentLayer = contentLayer
                backgroundAnnotation.contentLayer = thirdContentLayer
            } else if i == 4 {
                fourthContentLayer = contentLayer
                backgroundAnnotation.contentLayer = fourthContentLayer
            }
            
            backgroundAnnotation.displacement = CGPoint(x: 0, y: 50);
            hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(backgroundAnnotation)
            
            let textAnnotation = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [xPoint, NSNumber(value: Float(hostView.bounds.size.height))])
            
            let textStyle = CPTMutableTextStyle()
            textStyle.color = CPTColor.white()
            textStyle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            textStyle.textAlignment = .center

            let textLayer = CPTTextLayer(text: "\(i)", style: textStyle)
            textAnnotation.contentLayer = textLayer
            textAnnotation.displacement = CGPoint(x: 7, y: 50);
            hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(textAnnotation)
            
            let bookAnnotation = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [xPoint, NSNumber(value: Float(hostView.bounds.size.height))])
            let bookMarkImage = UIImage(named: "icDiarySolid")
            let bookImageRect = CGRect(x: 0, y: 0, width: 12, height: 12)
            let bookNewImageLayer = CPTBorderedLayer(frame: bookImageRect)
            bookNewImageLayer.fill = CPTFill(image: CPTImage(cgImage: bookMarkImage?.cgImage, scale: UIScreen.main.scale))
            bookAnnotation.contentLayer = bookNewImageLayer
            bookAnnotation.displacement = CGPoint(x: -5, y: 50);
            hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(bookAnnotation)
            
            let imagePointArray: [Float] = [13, 33, 53, 73]
            let imageX = hostViewWidth / 86400 * CGFloat(dataArray[Int(imagePointArray[i - 1])].date.timeIntervalSince1970 - startInterval)
            let imageY = dataArray[Int(imagePointArray[i - 1])].value
            let imageAnnotation = CPTPlotSpaceAnnotation(plotSpace: (hostView.hostedGraph?.defaultPlotSpace)!, anchorPlotPoint: [NSNumber(value: Float(imageX)), NSNumber(value: Float(imageY))])
            let markImage = UIImage(named: "icDiaryExerciseCgm")
            let imageRect = CGRect(x: 0, y: 0, width: 16, height: 16)
            let newImageLayer = CPTBorderedLayer(frame: imageRect)
            newImageLayer.fill = CPTFill(image: CPTImage(cgImage: markImage?.cgImage, scale: UIScreen.main.scale))
            imageAnnotation.contentLayer = newImageLayer
            imageAnnotation.displacement = CGPoint(x: 0, y: 0);
            hostView.hostedGraph?.plotAreaFrame?.plotArea?.addAnnotation(imageAnnotation)
        }
    }
    
    private func reloadCharts() {
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

        graph.plotAreaFrame?.paddingTop = padding
        graph.plotAreaFrame?.paddingBottom = padding
        graph.plotAreaFrame?.paddingLeft = padding
        graph.plotAreaFrame?.paddingRight = padding
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
            let axisYConstraints = CPTConstraints.constraint(withLowerOffset: 0)
            yAxis.axisConstraints = axisYConstraints
            let yAxisLineStyle = CPTMutableLineStyle()
            yAxisLineStyle.lineWidth = 0
            yAxisLineStyle.lineColor = .clear()
            yAxis.axisLineStyle = yAxisLineStyle
            yAxis.majorGridLineStyle = axisLineStyle
            yAxis.labelingPolicy = .none
            yAxis.labelTextStyle = textStyle
        }

        graph.axisSet?.axes = [axisSet.xAxis, axisSet.yAxis] as? [CPTAxis]
    }

    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        space.allowsUserInteraction = true
        space.delegate = self

        // configure x-axis
        let xMin: CGFloat = 0
        let xWidth: CGFloat = hostViewWidth
        
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xWidth))

        // default x-axis position
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin), lengthDecimal: CPTDecimalFromCGFloat(xWidth))

        self.configureXAxisLabelsWithSpace(space: space)

        // configure y-axis
        self.configureYAxisLabels()
    }

    private func configureXAxisLabelsWithSpace(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else {
            return
        }

        if let xAxis = axisSet.xAxis {
            var xLabels = Set<CPTAxisLabel>()
            let widthPoint = hostViewWidth / (xAxisCount - 1)
            
            for index in 0...4 {
                let location = widthPoint * CGFloat(index)
                let textArray = ["00:00", "6:00", "12:00", "18:00", "24:00"]

                let label = CPTAxisLabel(text: textArray[index], textStyle: textStyle)
                label.tickLocation = NSNumber(value: Float(location))
                label.alignment = .center
                label.offset = 5
                xLabels.insert(label)
            }
            xAxis.axisLabels = xLabels
        }
    }

    private func configureYAxisLabels() {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let space = hostView.hostedGraph?.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        if let yAxis = axisSet.yAxis {

            var yLabels = Set<CPTAxisLabel>()
            var yMajorLocations = Set<NSNumber>()

            space.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(0), lengthDecimal: CPTDecimalFromFloat(250))
            space.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(0), lengthDecimal: CPTDecimalFromFloat(250))

            for i in stride(from: 0, through: 250, by: 50) {
                let label = CPTAxisLabel(text: String(i).formatFloatByNumber(digit: 1), textStyle: textStyle)
                let location = CPTDecimalFromFloat(Float(i))
                label.tickLocation = location as NSNumber
                label.alignment = .center
                label.offset = 10
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }

            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
            let yAxisLineStyle = CPTMutableLineStyle()
            yAxisLineStyle.lineWidth = 0
            yAxisLineStyle.lineColor = .clear()
            yAxis.majorTickLineStyle = yAxisLineStyle
        }
    }
    
}

extension CGMChartViewController: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(dataArray.count)
    }

    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }

        switch field {
        case .X:
            return hostViewWidth / 86400 * CGFloat(dataArray[Int(idx)].date.timeIntervalSince1970 - startInterval)
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
        
        if yPoint < lowBound {
            return false
        }
        
        isDrag = true
        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {
        
        if !isDrag {
            let anchorPoint = space.plotPoint(for: event)?.first?.floatValue ?? 0
            let hostWidth = Float(hostViewWidth)
            let showAreaOne = anchorPoint < hostWidth / 4
            let showAreaTwo = hostWidth / 4 < anchorPoint && anchorPoint < hostWidth / 2
            let showAreaThree = hostWidth / 2 < anchorPoint && anchorPoint < hostWidth * 3 / 4
            let showAreaFour = hostWidth * 3 / 4 < anchorPoint
            
            if showAreaOne {
                symbolAnnotation?.contentAnchorPoint = CGPoint(x: 0, y: 0)
                firstContentLayer?.backgroundColor = greenColor
                secondContentLayer?.backgroundColor = grayColor
                thirdContentLayer?.backgroundColor = grayColor
                fourthContentLayer?.backgroundColor = grayColor
            } else if showAreaTwo {
                symbolAnnotation?.contentAnchorPoint = CGPoint(x: -1, y: 0)
                firstContentLayer?.backgroundColor = grayColor
                secondContentLayer?.backgroundColor = greenColor
                thirdContentLayer?.backgroundColor = grayColor
                fourthContentLayer?.backgroundColor = grayColor
            } else if showAreaThree {
                symbolAnnotation?.contentAnchorPoint = CGPoint(x: -2, y: 0)
                firstContentLayer?.backgroundColor = grayColor
                secondContentLayer?.backgroundColor = grayColor
                thirdContentLayer?.backgroundColor = greenColor
                fourthContentLayer?.backgroundColor = grayColor
            } else if showAreaFour {
                symbolAnnotation?.contentAnchorPoint = CGPoint(x: -3, y: 0)
                firstContentLayer?.backgroundColor = grayColor
                secondContentLayer?.backgroundColor = grayColor
                thirdContentLayer?.backgroundColor = grayColor
                fourthContentLayer?.backgroundColor = greenColor
            }
            
        }
        isDrag = false

        return true
    }

}

extension CGMChartViewController: CPTPlotSpaceDelegate {

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

extension CGMChartViewController: CPTScatterPlotDelegate {
    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt, with event: UIEvent) {
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    // MARK: - Add Methods

    func add(_ unit: Calendar.Component, value: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: unit, value: value, to: self) ?? self
    }

    func add(year: Int) -> Date {
        add(.year, value: year)
    }

    func add(month: Int) -> Date {
        add(.month, value: month)
    }

    func add(week: Int) -> Date {
        add(.weekOfYear, value: week)
    }

    func add(day: Int) -> Date {
        add(.day, value: day)
    }

    func add(hour: Int) -> Date {
        add(.hour, value: hour)
    }

    func add(minute: Int) -> Date {
        add(.minute, value: minute)
    }

    func add(seconds: Int) -> Date {
        add(.second, value: seconds)
    }
}
