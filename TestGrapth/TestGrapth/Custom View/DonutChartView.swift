//
//  DonutChartView.swift
//  TestGrapth
//
//  Created by jlai on 2021/9/22.
//

import UIKit

struct PercentagesModel {
    let percentages: CGFloat
    let percentageLayerColor: CGColor
}

struct DonutChartViewModel {
    let lineWidth: CGFloat
    let percentagesModel: [PercentagesModel]
}

class DonutChartView: UIView {
    //initWithFrame to init view from code
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //common func to init our view
    func setupView(viewModel: DonutChartViewModel) {
        let aDegree = CGFloat.pi / 180
        let lineWidth = viewModel.lineWidth
        let radius: CGFloat = (frame.width / 2) - (lineWidth / 2)
        var startDegree: CGFloat = 270
        let radiusPlusLineWidth = radius + lineWidth
        let RingView = UIView(frame: CGRect(x: 0, y: 0, width: 2 * radiusPlusLineWidth, height: 2 * radiusPlusLineWidth))
        let exerciseImage = UIImageView(image: UIImage(named: "exercise"))
        let imageCircleWidth = 2 * (frame.size.width / 2 - lineWidth)
        exerciseImage.frame = CGRect(x: lineWidth, y: lineWidth, width: imageCircleWidth, height: imageCircleWidth)
        RingView.addSubview(exerciseImage)

        let center = CGPoint(x: frame.width / 2, y: frame.width / 2)
        for percentage in viewModel.percentagesModel {
            let endDegree = startDegree + 360 * percentage.percentages / 100
            let percentagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            percentageLayer.strokeColor  = percentage.percentageLayerColor
            percentageLayer.lineWidth = lineWidth
            percentageLayer.fillColor = UIColor.clear.cgColor
            RingView.layer.addSublayer(percentageLayer)
            startDegree = endDegree
        }
        
        addSubview(RingView)
    }
}
