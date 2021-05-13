//
//  AGPChart.swift
//  TestGrapth
//
//  Created by jlai on 2021/5/10.
//

import UIKit

struct AGPAreaData {
    let leftToRight: [CGPoint]
    let rightToLeft: [CGPoint]
}

struct PointEntry {
    let value: Int
    let date: Date
}

extension PointEntry: Comparable {
    
    static func <(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value < rhs.value
    }
    
    static func ==(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value == rhs.value
    }
}

struct AGPChartModel {
    let startInterval: TimeInterval
    let tenPercentDatas: [PointEntry]
    let twentyFivePercentDatas: [PointEntry]
    let medianDatas: [PointEntry]
    let seventyFivePercentDatas: [PointEntry]
    let ninetyPercentDatas: [PointEntry]
    let lowestTargetRange: Float
    let highestTargetRange: Float
    let insulinDatas: [PointEntry]
}

class AGPChart: UIView {
    
    private var chartModel: AGPChartModel?
    
    /// preserved space at top of the chart
    private let topSpace: CGFloat = 60.0
    
    /// preserved space at bottom of the chart to show labels along the Y axis
    private let bottomSpace: CGFloat = 40.0
    
    /// preserved space at left of the chart to show labels along the X axis
    private let leftPaddingSpace: CGFloat = 40.0
    
    /// preserved space at right of the chart to show labels along the X axis
    private let rightPaddingSpace: CGFloat = 30.0
    
    /// The top most horizontal line in the chart will be 10% higher than the highest value in the chart
    private let topHorizontalLine: CGFloat = 100.0 / 100.0
    
    /// Contains the chart which represents the ten to ninety data
    private let tenToNinetyDataLayer: CALayer = CALayer()
    
    /// Contains the chart which represents the twenty-five to seventy-five data
    private let twentyFiveToSeventyFiveDataLayer: CALayer = CALayer()
    
    /// Contains the chart which represents the median data
    private let medianDataLayer: CALayer = CALayer()
    
    private let firstOvalImage: CAShapeLayer = CAShapeLayer()
    private let secondOvalImage: CAShapeLayer = CAShapeLayer()
    private let thirdOvalImage: CAShapeLayer = CAShapeLayer()
    private let fourthOvalImage: CAShapeLayer = CAShapeLayer()
    private lazy var symbolView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 0.1)
        return view
    }()
    
    /// Contains dataLayer
    private let mainLayer: CALayer = CALayer()
    
    /// Contains mainLayer and label for each data entry
    private let scrollView: UIScrollView = UIScrollView()
    
    /// Contains horizontal lines
    private let gridLayer: CALayer = CALayer()
    
    /// Contains insulins
    private let insulinLayer: CALayer = CALayer()
    
    /// An array of CGPoint on tenToNinetyDataLayer coordinate system that the main line will go through. These points will be calculated from AGPLineModel tenPercentDatas and ninetyPercentDatas
    private var tenToNinetyDataPoints: AGPAreaData?
    
    /// An array of CGPoint on twentyFiveToSeventyFiveDataLayer coordinate system that the main line will go through. These points will be calculated from AGPLineModel twentyFivePercentDatas and seventyFivePercentDatas
    private var twentyFiveToSeventyFiveDataPoints: AGPAreaData?
    
    /// An array of CGPoint on medianDataLayer coordinate system that the main line will go through. These points will be calculated from AGPLineModel medianDatas
    private var medianDataPoints:[CGPoint]?
    
    private lazy var dataCount: Int = {
        guard let chartModel = chartModel else {
            return 0
        }
        return chartModel.tenPercentDatas.count
    }()
    
    private lazy var minMaxRange: CGFloat = {
        if let max = chartModel?.ninetyPercentDatas.max()?.value,
           let min = chartModel?.tenPercentDatas.min()?.value {
            return CGFloat(max - min) * topHorizontalLine
        }

        return 0
    }()

    private lazy var yAxisMinValue: CGFloat = {
        return CGFloat(chartModel?.tenPercentDatas.min()?.value ?? 0)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    func updateChartData(chartModel: AGPChartModel) {
        self.chartModel = chartModel
        reloadAGPChartView()
    }
    
    private func setupView() {
        mainLayer.addSublayer(tenToNinetyDataLayer)
        mainLayer.addSublayer(twentyFiveToSeventyFiveDataLayer)
        mainLayer.addSublayer(medianDataLayer)
        mainLayer.addSublayer(insulinLayer)
        scrollView.layer.addSublayer(mainLayer)
        
        self.layer.addSublayer(gridLayer)
        self.addSubview(scrollView)
        self.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        reloadAGPChartView()
    }
    
    private func dataLayerFrame() -> CGRect {
        return CGRect(x: leftPaddingSpace, y: topSpace, width: mainLayer.frame.width - (leftPaddingSpace + rightPaddingSpace), height: mainLayer.frame.height - topSpace - bottomSpace)
    }
    
    private func reloadAGPChartView() {
        guard let chartModel = chartModel else {
            return
        }
        
        let mainFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        scrollView.frame = mainFrame
        scrollView.contentSize = mainFrame.size
        mainLayer.frame = mainFrame
        
        tenToNinetyDataLayer.frame = dataLayerFrame()
        twentyFiveToSeventyFiveDataLayer.frame = dataLayerFrame()
        medianDataLayer.frame = dataLayerFrame()
        insulinLayer.frame = dataLayerFrame()
        gridLayer.frame = CGRect(x: 0, y: topSpace, width: mainLayer.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
        
        tenToNinetyDataPoints = convertAreaDataEntriesToPoints(entries: chartModel.ninetyPercentDatas, entries2: chartModel.tenPercentDatas)
        twentyFiveToSeventyFiveDataPoints = convertAreaDataEntriesToPoints(entries: chartModel.seventyFivePercentDatas, entries2: chartModel.twentyFivePercentDatas)
        medianDataPoints = convertDataEntriesToPoints(entries: chartModel.medianDatas)
        
        clean()
        drawHorizontalLines()
        drawTenToNinetyCurvedChart()
        drawTwentyFiveToSeventyFiveCurvedChart()
        drawMedianCurvedChart()
        drawInsulinChart()
        drawSymbols()
        drawLabels()
    }
    
    /**
     Convert an array of PointEntry to an array of CGPoint on dataLayer coordinate system
     */
    private func convertDataEntriesToPoints(entries: [PointEntry]) -> [CGPoint] {
        var result: [CGPoint] = []
        
        for i in 0..<entries.count {
            let height = dataLayerFrame().height * (1 - ((CGFloat(entries[i].value) - CGFloat(yAxisMinValue)) / minMaxRange))
            let startInterVal: TimeInterval = chartModel?.startInterval ?? 0
            let point = CGPoint(x: dataLayerFrame().width / 86400 * CGFloat(entries[Int(i)].date.timeIntervalSince1970 - startInterVal), y: height)
            result.append(point)
        }
        
        return result
    }
    
    
    /**
     Convert an array of PointEntry to an array of CGPoint on dataLayer coordinate system
     */
    private func convertAreaDataEntriesToPoints(entries: [PointEntry], entries2: [PointEntry]) -> AGPAreaData {
        var leftToRight: [CGPoint] = []
        var rightToLeft: [CGPoint] = []
        
        for i in 0..<entries.count {
            let height = dataLayerFrame().height * (1 - ((CGFloat(entries[i].value) - CGFloat(yAxisMinValue)) / minMaxRange))
            let startInterVal: TimeInterval = chartModel?.startInterval ?? 0
            let point = CGPoint(x: dataLayerFrame().width / 86400 * CGFloat(entries[Int(i)].date.timeIntervalSince1970 - startInterVal), y: height)
            leftToRight.append(point)
        }
        
        for i in stride(from: entries2.count - 1, through: 0, by: -1) {
            let height = dataLayerFrame().height * (1 - ((CGFloat(entries2[i].value) - CGFloat(yAxisMinValue)) / minMaxRange))
            let startInterVal: TimeInterval = chartModel?.startInterval ?? 0
            let point = CGPoint(x: dataLayerFrame().width / 86400 * CGFloat(entries2[Int(i)].date.timeIntervalSince1970 - startInterVal), y: height)
            rightToLeft.append(point)
        }
        return AGPAreaData(leftToRight: leftToRight, rightToLeft: rightToLeft)
    }
    
    /**
     Draw a curved line connecting all points in dataPoints
     */
    private func drawCurvedChart(dataPoints: [CGPoint]) {
        if let path = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            medianDataLayer.addSublayer(lineLayer)
            lineLayer.strokeColor = UIColor(red: 68 / 255, green: 115 / 255, blue: 114 / 255, alpha: 1).cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
        }
    }
    
    /**
     Draw a curved area connecting all points in AGPAreaData
     */
    private func drawAreaCurvedChart(areaData: AGPAreaData, isTenToNinety: Bool) {
        
        let fillColor = isTenToNinety ? UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 0.2).cgColor :
            UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 0.6).cgColor
        
        if let path = CurveAlgorithm.shared.createAreaPath(areaData) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            medianDataLayer.addSublayer(lineLayer)
            lineLayer.strokeColor = UIColor(red: 68 / 255, green: 115 / 255, blue: 114 / 255, alpha: 1).cgColor
            lineLayer.fillColor = fillColor
            lineLayer.strokeColor = UIColor.clear.cgColor
            
            if isTenToNinety {
                tenToNinetyDataLayer.addSublayer(lineLayer)
            } else {
                twentyFiveToSeventyFiveDataLayer.addSublayer(lineLayer)
            }
        }
    }
    
    private func drawTenToNinetyCurvedChart() {
        guard let areaData = tenToNinetyDataPoints, areaData.leftToRight.count > 0 else {
            return
        }
        
        drawAreaCurvedChart(areaData: areaData, isTenToNinety: true)
    }
    
    private func drawTwentyFiveToSeventyFiveCurvedChart() {
        guard let areaData = twentyFiveToSeventyFiveDataPoints, areaData.leftToRight.count > 0 else {
            return
        }
        
        drawAreaCurvedChart(areaData: areaData, isTenToNinety: false)
    }
    
    private func drawMedianCurvedChart() {
        guard let dataPoints = medianDataPoints, dataPoints.count > 0 else {
            return
        }
        
        drawCurvedChart(dataPoints: dataPoints)
    }
    
    private func drawInsulinChart() {
        guard let chartModel = chartModel else {
            return
        }
        
        let insulinDatas = chartModel.insulinDatas
        
        if let insulinAxisMin = insulinDatas.min()?.value,
           let insulinAxisMax = insulinDatas.max()?.value {
            let insulinMinMaxRange = CGFloat(insulinAxisMax - insulinAxisMin) * topHorizontalLine
            
            for index in 0..<insulinDatas.count {
                let height = dataLayerFrame().height * (1 - ((CGFloat(insulinDatas[index].value) - CGFloat(insulinAxisMin)) / insulinMinMaxRange))
                
                let startInterVal: TimeInterval = chartModel.startInterval
                let point = CGPoint(x: dataLayerFrame().width / 86400 * CGFloat(insulinDatas[Int(index)].date.timeIntervalSince1970 - startInterVal), y: height)
                
                let circleLayer = CAShapeLayer()
                circleLayer.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
                circleLayer.fillColor = UIColor(red: 64 / 255, green: 99 / 255, blue: 189 / 255, alpha: 1).cgColor
                let path = UIBezierPath(arcCenter: circleLayer.position, radius: 2, startAngle: 0, endAngle: CGFloat(2 * Float.pi), clockwise: true)
                circleLayer.path = path.cgPath
                circleLayer.position = point
                
                insulinLayer.addSublayer(circleLayer)
            }
        }
    }
    
    /**
     Create titles at the bottom for all entries showed in the chart
     */
    private func drawLabels() {
        for i in 0...4 {
            let textLayer = CATextLayer()
            let textArray = ["00:00", "6:00", "12:00", "18:00", "24:00"]
            
            let widthPoint = dataLayerFrame().width / CGFloat(textArray.count - 1)
            let textLayerWidth: CGFloat = 60
            
            textLayer.frame = CGRect(x: leftPaddingSpace + widthPoint * CGFloat(i) - textLayerWidth / 2, y: mainLayer.frame.size.height - bottomSpace / 2 - 8, width: textLayerWidth, height: 16)
            textLayer.foregroundColor = UIColor(red: 115 / 255, green: 115 / 255, blue: 115 / 255, alpha: 1).cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 11
            textLayer.string = textArray[i]
            mainLayer.addSublayer(textLayer)
        }
    }
    
    private func drawSymbols() {
        symbolView.frame = CGRect(x: leftPaddingSpace, y: 0, width: dataLayerFrame().width / 4, height: mainLayer.frame.height - bottomSpace)
        self.addSubview(symbolView)
        
        for i in 1...4 {
            let pointArray: [Float] = [1, 3, 5, 7]
            let xPoint: CGFloat = CGFloat(Float(dataLayerFrame().width) / 86400 * (86400 / 8) * pointArray[i - 1]) + leftPaddingSpace
            
            let padding: CGFloat = 9
            let width = dataLayerFrame().width / 4 - (padding * 2)
            
            let imageFrame = CGRect(x: 0, y: 0, width: width, height: 24)
            let imageColor = UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1).cgColor
            let imagePath = UIBezierPath(roundedRect: imageFrame, cornerRadius: 12).cgPath
            let imagePosition = CGPoint(x: xPoint, y: 34)
            
            let viewDataImageFrame = CGRect(x: xPoint, y: 34, width: 16, height: 16)
            
            let imageLayer = CALayer()
            let viewDataImage = UIImage(named: "iconViewData")?.cgImage
            
            if i == 1 {
                firstOvalImage.frame = imageFrame
                firstOvalImage.fillColor = UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor
                firstOvalImage.path = imagePath
                firstOvalImage.position = imagePosition
                mainLayer.addSublayer(firstOvalImage)
            } else if i == 2 {
                secondOvalImage.frame = imageFrame
                secondOvalImage.fillColor = imageColor
                secondOvalImage.path = imagePath
                secondOvalImage.position = imagePosition
                mainLayer.addSublayer(secondOvalImage)
            } else if i == 3 {
                thirdOvalImage.frame = imageFrame
                thirdOvalImage.fillColor = imageColor
                thirdOvalImage.path = imagePath
                thirdOvalImage.position = imagePosition
                mainLayer.addSublayer(thirdOvalImage)
            } else if i == 4 {
                fourthOvalImage.frame = imageFrame
                fourthOvalImage.fillColor = imageColor
                fourthOvalImage.path = imagePath
                fourthOvalImage.position = imagePosition
                mainLayer.addSublayer(fourthOvalImage)
            }
            
            imageLayer.frame = viewDataImageFrame
            imageLayer.position = imagePosition
            imageLayer.contents = viewDataImage
            mainLayer.addSublayer(imageLayer)
        }
    }
    
    /**
     Create horizontal lines (grid lines) and show the value of each line
     */
    private func drawHorizontalLines() {
        guard let chartModel = chartModel else {
            return
        }
        
        var gridValues: [CGFloat]? = nil
        if dataCount < 4 && dataCount > 0 {
            gridValues = [0, 1]
        } else if dataCount >= 4 {
            gridValues = [0, 0.25, 0.5, 0.75, 1]
        }
        if let gridValues = gridValues {
            for value in gridValues {
                let height = value * gridLayer.frame.size.height
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: leftPaddingSpace, y: height))
                path.addLine(to: CGPoint(x: gridLayer.frame.size.width - rightPaddingSpace, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1).cgColor
                lineLayer.lineWidth = 0.5
                
                gridLayer.addSublayer(lineLayer)
                
                var minMaxGap: CGFloat = 0
                var leftLineValue: Int = 0
                
                // draw left label
                if let leftMax = chartModel.ninetyPercentDatas.max()?.value,
                   let leftMin = chartModel.tenPercentDatas.min()?.value {
                    if leftMax - leftMin > 0 {
                        minMaxGap = CGFloat(leftMax - leftMin) * topHorizontalLine
                        leftLineValue = Int((1 - value) * minMaxGap) + Int(leftMin)
                    } else {
                        leftLineValue = Int((1 - value) * 4 * 100)
                    }
                }
                
                let leftTextLayer = CATextLayer()
                let textLayerHeight: CGFloat = 16
                let textLayerFrame = CGRect(x: 4, y: height - (textLayerHeight / 2), width: 20, height: textLayerHeight)
                let textLayerColor = UIColor(red: 115 / 255, green: 115 / 255, blue: 115 / 255, alpha: 1).cgColor
                leftTextLayer.frame = textLayerFrame
                leftTextLayer.foregroundColor = textLayerColor
                leftTextLayer.backgroundColor = UIColor.clear.cgColor
                leftTextLayer.contentsScale = UIScreen.main.scale
                leftTextLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                leftTextLayer.fontSize = 12
                leftTextLayer.alignmentMode = .right
                leftTextLayer.string = "\(leftLineValue)"
                
                gridLayer.addSublayer(leftTextLayer)
                
                // draw right label
                var rightLineValue: Int = 0
                
                if let rightMax = chartModel.insulinDatas.max()?.value,
                   let rightMin = chartModel.insulinDatas.min()?.value {
                    if rightMax - rightMin > 0 {
                        minMaxGap = CGFloat(rightMax - rightMin) * topHorizontalLine
                        rightLineValue = Int((1 - value) * minMaxGap) + Int(rightMin)
                    } else {
                        rightLineValue = Int((1 - value) * 4 * 100)
                    }
                }
                
                let rightTextLayer = CATextLayer()
                rightTextLayer.frame = CGRect(x: mainLayer.frame.width - rightPaddingSpace + 10, y: height - (textLayerHeight / 2), width: 20, height: textLayerHeight)
                rightTextLayer.foregroundColor = textLayerColor
                rightTextLayer.backgroundColor = UIColor.clear.cgColor
                rightTextLayer.contentsScale = UIScreen.main.scale
                rightTextLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                rightTextLayer.fontSize = 12
                rightTextLayer.alignmentMode = .left
                rightTextLayer.string = "\(rightLineValue)"
                
                gridLayer.addSublayer(rightTextLayer)
            }
        }
        
        // draw target range
        
        gridLayer.addSublayer(drawTargetRangeLine(value: chartModel.lowestTargetRange))
        gridLayer.addSublayer(drawTargetRangeLine(value: chartModel.highestTargetRange))
    }
    
    private func drawTargetRangeLine(value: Float) -> CAShapeLayer {
        let targetRangePath = UIBezierPath()
        let targetRangeHeight = dataLayerFrame().height * (1 - ((CGFloat(value) - CGFloat(yAxisMinValue)) / minMaxRange))
        targetRangePath.move(to: CGPoint(x: leftPaddingSpace, y: targetRangeHeight))
        targetRangePath.addLine(to: CGPoint(x: gridLayer.frame.size.width - rightPaddingSpace, y: targetRangeHeight))
        
        let targetRangeLineLayer = CAShapeLayer()
        targetRangeLineLayer.path = targetRangePath.cgPath
        targetRangeLineLayer.fillColor = UIColor.clear.cgColor
        targetRangeLineLayer.strokeColor = UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor
        targetRangeLineLayer.lineWidth = 0.5
        targetRangeLineLayer.lineDashPattern = [4, 4]
        
        return targetRangeLineLayer
    }
    
    private func clean() {
        mainLayer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })
        
        tenToNinetyDataLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        twentyFiveToSeventyFiveDataLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        medianDataLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        firstOvalImage.sublayers?.forEach({ $0.removeFromSuperlayer() })
        secondOvalImage.sublayers?.forEach({ $0.removeFromSuperlayer() })
        thirdOvalImage.sublayers?.forEach({ $0.removeFromSuperlayer() })
        fourthOvalImage.sublayers?.forEach({ $0.removeFromSuperlayer() })
        insulinLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        gridLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let anchorPoint = Float(sender.location(in: self).x)
        
        let leftPadding = Float(leftPaddingSpace)
        let symbolViewWidth = Float(mainLayer.frame.width - leftPaddingSpace - rightPaddingSpace) / 4
        let showAreaOne = anchorPoint > leftPadding && anchorPoint < (leftPadding + symbolViewWidth)
        let showAreaTwo = anchorPoint > (leftPadding + symbolViewWidth) && anchorPoint < (leftPadding + symbolViewWidth * 2)
        let showAreaThree = anchorPoint > (leftPadding + symbolViewWidth * 2) && anchorPoint < (leftPadding + symbolViewWidth * 3)
        let showAreaFour = anchorPoint > (leftPadding + symbolViewWidth * 3) && anchorPoint < Float(mainLayer.frame.width) - Float(rightPaddingSpace)

        if showAreaOne {
            symbolView.frame = CGRect(x: leftPaddingSpace, y: 0, width: CGFloat(symbolViewWidth), height: mainLayer.frame.height - bottomSpace)
        } else if showAreaTwo {
            symbolView.frame = CGRect(x: leftPaddingSpace + CGFloat(symbolViewWidth), y: 0, width: CGFloat(symbolViewWidth), height: mainLayer.frame.height - bottomSpace)
        } else if showAreaThree {
            symbolView.frame = CGRect(x: leftPaddingSpace + CGFloat(symbolViewWidth) * 2, y: 0, width: CGFloat(symbolViewWidth), height: mainLayer.frame.height - bottomSpace)
        } else if showAreaFour {
            symbolView.frame = CGRect(x: leftPaddingSpace + CGFloat(symbolViewWidth) * 3, y: 0, width: CGFloat(symbolViewWidth), height: mainLayer.frame.height - bottomSpace)
        }
    }
    
}
