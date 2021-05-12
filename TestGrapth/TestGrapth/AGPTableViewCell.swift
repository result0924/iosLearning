//
//  AGPTableViewCell.swift
//  TestGrapth
//
//  Created by jlai on 2021/5/5.
//

import UIKit

enum AGPDataType {
    case ten
    case twentyFive
    case median
    case seventyFive
    case ninety
}

class AGPTableViewCell: UITableViewCell {
    @IBOutlet weak var agpChart: AGPChart!
    
    private lazy var startInterval: TimeInterval = {
        let date = Date()
        let components = date.get(.day, .month, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            let dateComponents = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
            return dateComponents.date?.timeIntervalSince1970 ?? 0
        }
        
        return 0
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateContent() {
        agpChart.updateChartData(chartModel: AGPChartModel(startInterval: startInterval, tenPercentDatas: generateData(type: .ten), twentyFivePercentDatas: generateData(type: .twentyFive), medianDatas: generateData(type: .median), seventyFivePercentDatas: generateData(type: .seventyFive), ninetyPercentDatas: generateData(type: .ninety), lowestTargetRange: 122, highestTargetRange: 208))
    }
    
    private func generateData(type: AGPDataType) -> [PointEntry] {
        var intRandomRange: Int
        
        var dataArray: [PointEntry] = []
        let date = Date()
        let components = date.get(.day, .month, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            let dateComponents = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
            let startInterval = dateComponents.date?.timeIntervalSince1970 ?? 0
            let quarterSecondNumber: Int = 15 * 60
            let quarterInDay: Int = 96
            
            for index in Array(0...quarterInDay) {
                
                switch type {
                case .ten:
                    intRandomRange = Int.random(in: 100...120)
                case .twentyFive:
                    intRandomRange = Int.random(in: 130...140)
                case .median:
                    intRandomRange = Int.random(in: 150...160)
                case .seventyFive:
                    intRandomRange = Int.random(in: 175...190)
                case .ninety:
                    intRandomRange = Int.random(in: 210...230)
                }
                
                let date = Date(timeIntervalSince1970: startInterval + Double((quarterSecondNumber * index)))
                dataArray.append(PointEntry(value: intRandomRange, date: date))
            }
            
            return dataArray
            
        }
        
        return []
    }
    
}
