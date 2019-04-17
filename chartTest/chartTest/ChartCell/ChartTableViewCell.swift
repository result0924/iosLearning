//
//  ChartTableViewCell.swift
//  chartTest
//
//  Created by justin on 2019/3/28.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit
import Charts

class ChartTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet weak var chartContentView: UIView!
    var chartView: LineChartView = {
        let chartView = LineChartView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
        return chartView
    }()
    
    lazy var H2DateFormatterUTC: DateFormatter = {
        let formatter = DateFormatter()
        let timeZone = NSTimeZone(name:"UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = timeZone as TimeZone?
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.legend.enabled = false
        chartView.xAxis.enabled = true
        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottomInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
//        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 86400 * 30
        xAxis.valueFormatter = DateValueFormatter()
        
        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        ll1.lineWidth = 2
//        ll1.lineDashLengths = [5, 5]
//        ll1.labelPosition = .rightTop
        ll1.drawLabelEnabled = false
        ll1.lineColor = .yellow
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.axisRange = 10
        
        chartView.legend.form = .line
        chartView.chartDescription?.enabled = false
        
        print("chart frame: \(chartView.frame)")
        chartContentView.addSubview(chartView)
    }
    
    func updateChartData() {
        self.setDataCount()
    }
    
    func setDataCount() {
        let sampleDict = ["2017-03-24": 162, "2017-04-26": 139, "2017-05-23": 142, "2017-06-23": 154, "2018-06-23": 174]
        
        let from = H2DateFormatterUTC.date(from: sampleDict.keys.first!)!.timeIntervalSince1970
        let to = H2DateFormatterUTC.date(from: Array(sampleDict.keys).last!)!.timeIntervalSince1970
        let daySeconds: TimeInterval = (to - from) / Double(sampleDict.keys.count)
        print("keys: \(sampleDict.keys) from: \(from) to: \(to), daySeconds: \(daySeconds)")
        
//        let values = sampleDict.map { (key: String, value: Int) -> ChartDataEntry in
//            let x = H2DateFormatterUTC.date(from: key)!.timeIntervalSince1970
//            print("x: \(x) y: \(value)")
//            return ChartDataEntry(x: x, y: Double(value))
//        }
        
        let values:[ChartDataEntry] = [ChartDataEntry(x: 1490313600, y: 162), ChartDataEntry(x: 2851200 + 1490313600, y: 139),
        ChartDataEntry(x: 5184000 + 1490313600, y: 142), ChartDataEntry(x: 7862400 + 1490313600, y: 154),
        ChartDataEntry(x: 1529712000, y: 174)]

        print("values:\(values)")
        
        let set1 = LineChartDataSet(values: values, label: "test")
        set1.colors = [.blue]
        set1.circleColors = [.red, .blue, .blue, .red]
        set1.drawCircleHoleEnabled = false

        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        chartView.data = data
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
