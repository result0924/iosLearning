//
//  GraphViewController.swift
//  corePlotTest
//
//  Created by jlai on 2020/10/27.
//  Copyright © 2020 h2. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension GraphViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ScatterTableViewCell.self, for: indexPath)
        if indexPath.section == 0 {
            cell.updateScatterCell()
        } else if indexPath.section == 1 {
            cell.updateBarCell()
        } else if indexPath.section == 2 {
            cell.updateScatterBarCell()
        } else if indexPath.section == 3 {
            cell.updateScaleScatterCell()
        } else if indexPath.section == 4 {
            cell.updateYearScatterCell()
        }
        
        return cell
    }
    
}

extension GraphViewController: UITableViewDelegate {
    
}
