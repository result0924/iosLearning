//
//  AGPTableViewCell.swift
//  TestGrapth
//
//  Created by jlai on 2021/5/5.
//

import UIKit

class AGPTableViewCell: UITableViewCell {
    var graphView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupConstraint()
    }
    
    private func setupConstraint() {
        contentView.addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        graphView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        graphView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40).isActive = true
        graphView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
    }

    func updateContent() {
        // UIBezierPath
//        graphView.backgroundColor = .red
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.black.cgColor
        // 可以把 move 想像為起點，addline 則是下一個點的位置
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 200, y: 0))
        shapeLayer.path = path.cgPath
        graphView.layer.addSublayer(shapeLayer)
    }

}
