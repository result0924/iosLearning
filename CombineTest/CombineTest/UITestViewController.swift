//
//  UITestViewController.swift
//  CombineTest
//
//  Created by lai Kuan-Ting on 2022/5/17.
//

import UIKit

enum UITestViewCase: CaseIterable {
    case slider
    case alertView
    
    var text: String {
        switch self {
        case .slider:
            return "slider"
        case .alertView:
            return "alertView"
        }
    }
}

class UITestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UI"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UITestViewCase.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = UITestViewCase.allCases[indexPath.row].text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uiCase = UITestViewCase.allCases[indexPath.row]
        
        switch uiCase {
        case .slider:
            let sliderVC = SliderViewController()
            navigationController?.pushViewController(sliderVC, animated: true)
        case .alertView:
            print("alert view")
        }
        
    }
}

