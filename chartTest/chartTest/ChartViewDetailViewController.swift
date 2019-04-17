//
//  ChartViewDetailViewController.swift
//  chartTest
//
//  Created by justin on 2019/3/25.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit
import Charts

class ChartViewDetailViewController: UIViewController {
    
    var chartType: ChartType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = chartType?.rawValue ?? "Unknow chart type"
    }

}

extension ChartViewDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chart", for: indexPath) as! ChartTableViewCell
        cell.updateChartData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
