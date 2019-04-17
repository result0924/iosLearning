//
//  ChartViewController.swift
//  chartTest
//
//  Created by justin on 2019/3/8.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit

enum ChartType: String, CaseIterable {
    case lineChart = "Line Chart"
    case barChart = "Bar Chart"
    case horizontalBarChart = "Horizontal BarChart"
    case pieChart = "Pie Chart"
    case scatterChart = "Scatter Chart"
    case candleStickChart = "Candle Stick Chart"
    case bubbleChart = "Bubble Chart"
    case radarChart = "Radar Chart(spider web chart)"
    
    static let allValues = ChartType.allCases.map{$0.rawValue}
}

class ChartViewController: UIViewController {
    
    let chartType = ChartType.allValues

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goChartDetail", let detailVC = segue.destination as? ChartViewDetailViewController {
            detailVC.chartType = sender as? ChartType
        }
    }

}

extension ChartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = chartType[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectType = ChartType(rawValue: chartType[indexPath.row]) ?? .lineChart
        self.performSegue(withIdentifier: "goChartDetail", sender: selectType)
    }
}
