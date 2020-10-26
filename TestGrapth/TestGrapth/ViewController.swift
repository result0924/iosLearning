//
//  ViewController.swift
//  TestGrapth
//
//  Created by jlai on 2020/10/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataList: [ContentCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 0.5
        dataList = [
            ContentCellModel.init(leftContent: "wakeup".localized, lowest: 50, low: 82, high: 143, middle: 131, highest: 250, rightContent: "27%"),
            ContentCellModel.init(leftContent: "bedtime".localized, lowest: 50, low: 93, high: 137, middle: 128, highest: 250, rightContent: "50%"),
            ContentCellModel.init(leftContent: "wakeup".localized, lowest: 50, low: 87, high: 200, middle: 137, highest: 250, rightContent: "92%"),
            ContentCellModel.init(leftContent: "breakfast".localized, lowest: 50, low: 84, high: 148, middle: 117, highest: 250, rightContent: "100%"),
            ContentCellModel.init(leftContent: "midnight".localized, lowest: 50, low: 60, high: 100, middle: 88, highest: 250, rightContent: "61%"),
            ContentCellModel.init(leftContent: "lunch".localized, lowest: 50, low: nil, high: nil, middle: nil, highest: 250, rightContent: "-"),
            ContentCellModel.init(leftContent: "dinner".localized, lowest: 50, low: 88, high: 135, middle: 111, highest: 250, rightContent: "53%")]
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ScoreTableViewCell.self, for: indexPath)
        if indexPath.section == 0 {
            cell.updateTitleCell(viewModel: TitleCellModel.init(leftContent: "time".localized, centerContent: "title".localized, rightContent: "scope".localized))
        } else {
            cell.updateContentCell(viewModel: dataList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        if section == 0 {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.text = "section 1 title".localized
            view.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        } else {
            let width = tableView.frame.width / 5
            let centerWidth = width * 3
            let centerWidthSpace = centerWidth / 4
            
            for i in 1...5 {
                let firstX = width - centerWidthSpace / 2
                let label = UILabel.init(frame: CGRect(x: firstX + centerWidthSpace * CGFloat(i - 1), y: 0, width: centerWidthSpace, height: 30))
                label.text = "\(50 * i)"
                label.textAlignment = .center
                label.textColor = .lightGray
                view.addSubview(label)
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let view = UIView()
        let rectangleView = UIView()
        rectangleView.backgroundColor = .systemGreen
        rectangleView.layer.cornerRadius = 2
        view.addSubview(rectangleView)
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        rectangleView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        rectangleView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        rectangleView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let scopeLabel = UILabel.init()
        scopeLabel.text = "foot content 1".localized
        view.addSubview(scopeLabel)
        scopeLabel.translatesAutoresizingMaskIntoConstraints = false
        scopeLabel.leadingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: 5).isActive = true
        scopeLabel.centerYAnchor.constraint(equalTo: rectangleView.centerYAnchor, constant: 0).isActive = true
        
        let averageView = UIView()
        averageView.backgroundColor = .lightGray
        averageView.layer.cornerRadius = 1
        view.addSubview(averageView)
        averageView.translatesAutoresizingMaskIntoConstraints = false
        averageView.leadingAnchor.constraint(equalTo: scopeLabel.trailingAnchor, constant: 20).isActive = true
        averageView.centerYAnchor.constraint(equalTo: scopeLabel.centerYAnchor, constant: 0).isActive = true
        averageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        averageView.widthAnchor.constraint(equalToConstant: 4).isActive = true

        let averageLabel = UILabel.init()
        averageLabel.text = "foot content 2".localized
        view.addSubview(averageLabel)
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        averageLabel.leadingAnchor.constraint(equalTo: averageView.trailingAnchor, constant: 5).isActive = true
        averageLabel.centerYAnchor.constraint(equalTo: averageView.centerYAnchor, constant: 0).isActive = true
        return view
    }
    
}
