//
//  ScatterTableViewCell..swift
//  corePlotTest
//
//  Created by jlai on 2020/10/29.
//  Copyright © 2020 h2. All rights reserved.
//

import UIKit
import CorePlot

class ScatterTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var scatterChartView: ScatterChartView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var scatterBarChartView: ScatterBarChartView!
    @IBOutlet weak var scaleScatterChartView: ScaleScatterChartView!
    @IBOutlet weak var LabChartView: LabResultDetailChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseView.layer.masksToBounds = true
        baseView.layer.cornerRadius = 10
    }
    
    func updateScatterCell() {
        scatterChartView.isHidden = false
        barChartView.isHidden = true
        scatterBarChartView.isHidden = true
        scaleScatterChartView.isHidden = true
        LabChartView.isHidden = true
        scatterChartView.reloadCharts()
    }
    
    func updateBarCell() {
        scatterChartView.isHidden = true
        barChartView.isHidden = false
        scatterBarChartView.isHidden = true
        scaleScatterChartView.isHidden = true
        LabChartView.isHidden = true
        barChartView.reloadCharts()
    }
    
    func updateScatterBarCell() {
        scatterChartView.isHidden = true
        barChartView.isHidden = true
        scatterBarChartView.isHidden = false
        scaleScatterChartView.isHidden = true
        LabChartView.isHidden = true
        scatterBarChartView.reloadCharts()
    }
    
    func updateScaleScatterCell() {
        scatterChartView.isHidden = true
        barChartView.isHidden = true
        scatterBarChartView.isHidden = true
        scaleScatterChartView.isHidden = false
        LabChartView.isHidden = true
        scaleScatterChartView.reloadCharts()
    }
    
    func updateYearScatterCell() {
        scatterChartView.isHidden = true
        barChartView.isHidden = true
        scatterBarChartView.isHidden = true
        scaleScatterChartView.isHidden = true
        LabChartView.isHidden = false
        LabChartView.reloadCharts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
