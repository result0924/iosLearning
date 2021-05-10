//
//  AGPChart.swift
//  TestGrapth
//
//  Created by jlai on 2021/5/10.
//

import UIKit

struct PointEntry {
    let value: Int
    let label: String
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
    let tenPercentDatas: [PointEntry]
    let twentyFivePercentDatas: [PointEntry]
    let seventyFivePercentDatas: [PointEntry]
    let ninetyPercentDatas: [PointEntry]
}

class AGPChart: UIView {
    
    private var chartModel: AGPChartModel?
    
    /// preserved space at top of the chart
    let topSpace: CGFloat = 40.0
    
    /// preserved space at bottom of the chart to show labels along the Y axis
    let bottomSpace: CGFloat = 40.0
    
    /// gap between each point
    private let lineGap: CGFloat = 60.0
    
    /// The top most horizontal line in the chart will be 10% higher than the highest value in the chart
    private let topHorizontalLine: CGFloat = 110.0 / 100.0
    
    /// Contains the chart which represents the ten to ninety data
    private let tenToNinetyDataLayer: CALayer = CALayer()
    
    /// Contains the chart which represents the twenty-five to seventy-five data
    private let twentyFiveToSeventyFiveDataLayer: CALayer = CALayer()
    
    /// Contains dataLayer
    private let mainLayer: CALayer = CALayer()
    
    /// Contains mainLayer and label for each data entry
    private let scrollView: UIScrollView = UIScrollView()
    
    /// Contains horizontal lines
    private let gridLayer: CALayer = CALayer()
    
    /// An array of CGPoint on tenToNinetyDataLayer coordinate system that the main line will go through. These points will be calculated from AGPLineModel tenPercentDatas and ninetyPercentDatas
    private var tenToNinetyDataPoints: [CGPoint]?
    
    /// An array of CGPoint on twentyFiveToSeventyFiveDataLayer coordinate system that the main line will go through. These points will be calculated from AGPLineModel twentyFivePercentDatas and seventyFivePercentDatas
    private var twentyFiveToSeventyFiveDataPoints: [CGPoint]?

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
    }
    
    private func setupView() {
        mainLayer.addSublayer(tenToNinetyDataLayer)
        mainLayer.addSublayer(twentyFiveToSeventyFiveDataLayer)
        scrollView.layer.addSublayer(mainLayer)
        
        self.layer.addSublayer(gridLayer)
        self.addSubview(scrollView)
        self.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        guard let chartModel = chartModel else {
            return
        }
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        scrollView.contentSize = CGSize(width: CGFloat(chartModel.tenPercentDatas.count) * lineGap, height: self.frame.size.height)
        mainLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(chartModel.tenPercentDatas.count) * lineGap, height: self.frame.size.height)
//            print("dataLayer y:\(topSpace)")
//            print("dataLayer bottom space:\(bottomSpace)")
//            print("dataLayer width:\(mainLayer.frame.width)")
//            print("dataLayer height:\(mainLayer.frame.height - topSpace - bottomSpace)")
        tenToNinetyDataLayer.frame = CGRect(x: 0, y: topSpace, width: mainLayer.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
        twentyFiveToSeventyFiveDataLayer.frame = CGRect(x: 0, y: topSpace, width: mainLayer.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
        tenToNinetyDataPoints = convertDataEntriesToPoints(entries: chartModel.ninetyPercentDatas, entries2: chartModel.tenPercentDatas)
        twentyFiveToSeventyFiveDataPoints = convertDataEntriesToPoints(entries: chartModel.seventyFivePercentDatas, entries2: chartModel.twentyFivePercentDatas)
        gridLayer.frame = CGRect(x: 0, y: topSpace, width: self.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
        clean()
        drawHorizontalLines()
        drawTenToNinetyCurvedChart()
        drawTwentyFiveToSeventyFiveCurvedChart()
        drawLabels()
    }
    
    /**
     Convert an array of PointEntry to an array of CGPoint on dataLayer coordinate system
     */
    private func convertDataEntriesToPoints(entries: [PointEntry], entries2: [PointEntry]) -> [CGPoint] {
        if let max = chartModel?.ninetyPercentDatas.max()?.value,
           let min = chartModel?.tenPercentDatas.min()?.value {
            
            var result: [CGPoint] = []
            let minMaxRange: CGFloat = CGFloat(max - min) * topHorizontalLine
            
            for i in 0..<entries.count {
                let height = tenToNinetyDataLayer.frame.height * (1 - ((CGFloat(entries[i].value) - CGFloat(min)) / minMaxRange))
                let point = CGPoint(x: CGFloat(i)*lineGap + 40, y: height)
                result.append(point)
            }
            
            for index in stride(from: entries2.count - 1, through: 0, by: -1) {
                let height = tenToNinetyDataLayer.frame.height * (1 - ((CGFloat(entries2[index].value) - CGFloat(min)) / minMaxRange))
                let point = CGPoint(x: CGFloat(index)*lineGap + 40, y: height)
                result.append(point)
            }
            return result
        }
        return []
    }
    
    /**
     Draw a curved line connecting all points in dataPoints
     */
    private func drawTenToNinetyCurvedChart() {
        guard let dataPoints = tenToNinetyDataPoints, dataPoints.count > 0 else {
            return
        }
        
        print("dataPoints: \(dataPoints)")
        if let path = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = UIColor.clear.cgColor
            lineLayer.fillColor =  UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 0.1).cgColor
            tenToNinetyDataLayer.addSublayer(lineLayer)
        }
    }
    
    /**
     Draw a curved line connecting all points in dataPoints
     */
    private func drawTwentyFiveToSeventyFiveCurvedChart() {
        guard let dataPoints = twentyFiveToSeventyFiveDataPoints, dataPoints.count > 0 else {
            return
        }
        
        print("dataPoints2: \(dataPoints)")
        if let path = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = UIColor.clear.cgColor
            lineLayer.fillColor =  UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor
            twentyFiveToSeventyFiveDataLayer.addSublayer(lineLayer)
        }
    }
    
    /**
     Create titles at the bottom for all entries showed in the chart
     */
    private func drawLabels() {
        guard let chartModel = chartModel else {
            return
        }
        
        for i in 0..<chartModel.tenPercentDatas.count {
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: lineGap * CGFloat(i) - lineGap / 2 + 40, y: mainLayer.frame.size.height - bottomSpace/2 - 8, width: lineGap, height: 16)
            textLayer.foregroundColor = #colorLiteral(red: 0.5019607843, green: 0.6784313725, blue: 0.8078431373, alpha: 1).cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 11
            textLayer.string = chartModel.tenPercentDatas[i].label
            mainLayer.addSublayer(textLayer)
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
        if chartModel.tenPercentDatas.count < 4 && chartModel.tenPercentDatas.count > 0 {
            gridValues = [0, 1]
        } else if chartModel.tenPercentDatas.count >= 4 {
            gridValues = [0, 0.25, 0.5, 0.75, 1]
        }
        if let gridValues = gridValues {
            for value in gridValues {
                let height = value * gridLayer.frame.size.height
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
                lineLayer.lineWidth = 0.5
                if (value > 0.0 && value < 1.0) {
                    lineLayer.lineDashPattern = [4, 4]
                }
                
                gridLayer.addSublayer(lineLayer)
                
                var minMaxGap:CGFloat = 0
                var lineValue:Int = 0
                if let max = chartModel.ninetyPercentDatas.max()?.value,
                   let min = chartModel.tenPercentDatas.min()?.value {
                    if max - min > 0 {
                        minMaxGap = CGFloat(max - min) * topHorizontalLine
                        lineValue = Int((1-value) * minMaxGap) + Int(min)
                    } else {
                        lineValue = Int((1-value) * 4 * 100)
                    }
                }
                
                let textLayer = CATextLayer()
                textLayer.frame = CGRect(x: 4, y: height, width: 50, height: 16)
                textLayer.foregroundColor = #colorLiteral(red: 0.5019607843, green: 0.6784313725, blue: 0.8078431373, alpha: 1).cgColor
                textLayer.backgroundColor = UIColor.clear.cgColor
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                textLayer.fontSize = 12
                textLayer.string = "\(lineValue)"
                
                gridLayer.addSublayer(textLayer)
            }
        }
    }
    
    private func clean() {
        mainLayer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })
        tenToNinetyDataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        twentyFiveToSeventyFiveDataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        gridLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    
}
