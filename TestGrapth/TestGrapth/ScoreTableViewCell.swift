//
//  ScoreTableViewCell.swift
//  TestGrapth
//
//  Created by jlai on 2020/10/22.
//

import UIKit

struct TitleCellModel {
    let leftContent: String
    let centerContent: String
    let rightContent: String
}

struct ContentCellModel {
    let leftContent: String
    let lowest: CGFloat?
    let low: CGFloat?
    let high: CGFloat?
    let middle: CGFloat?
    let highest: CGFloat?
    let rightContent: String
}

class ScoreTableViewCell: UITableViewCell {
    @IBOutlet weak var leftContentLabel: UILabel!
    @IBOutlet weak var centerContentLabel: UILabel!
    @IBOutlet weak var rightContentLabel: UILabel!
    @IBOutlet weak var leftViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContentCell(viewModel: ContentCellModel) {
        leftContentLabel.text = viewModel.leftContent
        rightContentLabel.text = viewModel.rightContent
        
        
        let cellSpace = frame.width / 5
        leftViewLeadingConstraint.constant = cellSpace
        rightViewTrailingConstraint.constant = cellSpace
        
        let centerWidth = frame.width / 5 * 3
        let centerWidthSpace = centerWidth / 4
        
        for i in 1...3 {
            let dashLineView = UIView.init(frame: CGRect(x: cellSpace + centerWidthSpace * CGFloat(i), y: 0, width: 0.5, height: frame.size.height))
            let topPoint = CGPoint(x: 0, y: dashLineView.bounds.minY)
            let bottomPoint = CGPoint(x: 0, y: dashLineView.bounds.maxY)
            dashLineView.createDashedLine(from: topPoint, to: bottomPoint, color: .lightGray, strokeLength: 2, gapLength: 4, width: 0.5)
            addSubview(dashLineView)
        }
        
        if let middle = viewModel.middle, let lowest = viewModel.lowest, let highest = viewModel.highest, let low = viewModel.low, let high = viewModel.high {
            centerContentLabel.text = ""
            let allScope = highest - lowest
            let unitInView = centerWidth / allScope
            let viewBarX = cellSpace + unitInView * (low - lowest)
            let viewBarWidth = unitInView * high - unitInView * low
            
            let viewBar = UIView.init(frame: CGRect(x: viewBarX, y: 10, width: viewBarWidth, height: 10))
            viewBar.backgroundColor = UIColor.systemGreen
            viewBar.layer.cornerRadius = 2
            addSubview(viewBar)
            
            let middleView = UIView.init(frame: CGRect(x: cellSpace + unitInView * (middle - lowest) - 2.5, y: 8, width: 5, height: 14))
            middleView.backgroundColor = .lightGray
            middleView.layer.cornerRadius = 1
            addSubview(middleView)
        } else {
            centerContentLabel.text = "無紀錄"
            centerContentLabel.textColor = .lightGray
            centerContentLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    func updateTitleCell(viewModel: TitleCellModel) {
        leftContentLabel.text = viewModel.leftContent
        rightContentLabel.text = viewModel.rightContent
        centerContentLabel.text = viewModel.centerContent
    }

}
