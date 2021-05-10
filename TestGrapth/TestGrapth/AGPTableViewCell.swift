//
//  AGPTableViewCell.swift
//  TestGrapth
//
//  Created by jlai on 2021/5/5.
//

import UIKit

class AGPTableViewCell: UITableViewCell {
    @IBOutlet weak var agpChart: AGPChart!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateContent() {
        agpChart.updateChartData(chartModel: AGPLineModel(tenPercentDatas: generateTenEntries(), ninetyPercentDatas: generateNinetyEntries()))
    }
    
    private func generateNinetyEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        for i in 0..<5 {
            var value = 0
            
            if i == 0 {
                value = 250
            } else if i == 1 {
                value = 230
            } else if i == 2 {
                value = 270
            } else if i == 3 {
                value = 290
            } else {
                value = 240
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }
    
    private func generateTenEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        for i in 0..<5 {
            var value = 0
            
            if i == 0 {
                value = 160
            } else if i == 1 {
                value = 170
            } else if i == 2 {
                value = 130
            } else if i == 3 {
                value = 180
            } else {
                value = 150
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }

}
