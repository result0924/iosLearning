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
    @IBOutlet weak var dashViewOne: DashLineView!
    @IBOutlet weak var dashViewTwo: DashLineView!
    @IBOutlet weak var dashViewThree: DashLineView!
    private var viewBar = UIView()
    private var viewMiddleBar = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBar.backgroundColor = UIColor.systemGreen
        viewBar.layer.cornerRadius = 2
        addSubview(viewBar)
        viewMiddleBar.backgroundColor = .lightGray
        viewMiddleBar.layer.cornerRadius = 1
        addSubview(viewMiddleBar)
    }
    
    func updateContentCell(viewModel: ContentCellModel) {
        leftContentLabel.text = viewModel.leftContent
        rightContentLabel.text = viewModel.rightContent
        
        let cellSpace = frame.width / 5
        
        let centerWidth = frame.width / 5 * 3
        if let middle = viewModel.middle, let lowest = viewModel.lowest, let highest = viewModel.highest, let low = viewModel.low, let high = viewModel.high {
            centerContentLabel.text = ""
            let allScope = highest - lowest
            let unitInView = centerWidth / allScope
            let viewBarX = cellSpace + unitInView * (low - lowest)
            let viewBarWidth = unitInView * high - unitInView * low
            
            viewBar.frame = CGRect(x: viewBarX, y: 10, width: viewBarWidth, height: 10)
            viewMiddleBar.frame = CGRect(x: cellSpace + unitInView * (middle - lowest) - 2.5, y: 8, width: 5, height: 14)
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
        dashViewOne.isHidden = true
        dashViewTwo.isHidden = true
        dashViewThree.isHidden = true
    }

}
