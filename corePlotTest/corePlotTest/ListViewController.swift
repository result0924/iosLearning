//
//  ListViewController.swift
//  corePlotTest
//
//  Created by jlai on 2020/10/27.
//  Copyright © 2020 h2. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    let dataArray = ["Test Graph 1", "Test Graph 2"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let test1 = storyboard.instantiateViewController(withIdentifier: "ViewController")
            navigationController?.pushViewController(test1, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let test2 = storyboard.instantiateViewController(withIdentifier: "GraphViewController")
            navigationController?.pushViewController(test2, animated: true)
        }
    }
    
}
