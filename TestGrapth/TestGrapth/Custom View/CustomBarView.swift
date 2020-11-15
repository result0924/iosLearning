//
//  CustomBarView.swift
//  TestGrapth
//
//  Created by lai Kuan-Ting on 2020/11/15.
//

import UIKit

class CustomBarView: UIView {
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        let topPoint = CGPoint(x: 0, y: self.bounds.minY)
        let bottomPoint = CGPoint(x: 0, y: self.bounds.maxY)
        self.createDashedLine(from: topPoint, to: bottomPoint, color: self.backgroundColor ?? UIColor.red, strokeLength: 2, gapLength: 4, width: 0.5)
        self.backgroundColor = .clear
    }
}
