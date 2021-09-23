//
//  CircleProgressViewController.swift
//  TestGrapth
//
//  Created by jlai on 2021/9/22.
//

import UIKit

class CircleProgressViewController: UIViewController {
    @IBOutlet weak var donutChartView: DonutChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let twentyPercentModel = PercentagesModel(percentages: 20, percentageLayerColor: UIColor.init(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor)
        let thirtyPercentModel = PercentagesModel(percentages: 30, percentageLayerColor: UIColor.init(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor)
        let fiftyPercentModel = PercentagesModel(percentages: 50, percentageLayerColor: UIColor.init(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor)
        let viewModel = DonutChartViewModel(lineWidth: 8, percentagesModel: [twentyPercentModel, thirtyPercentModel, fiftyPercentModel])
        donutChartView.setupView(viewModel: viewModel)
    }

}
