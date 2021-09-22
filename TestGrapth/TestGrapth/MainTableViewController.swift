//
//  MainTableViewController.swift
//  TestGrapth
//
//  Created by lai Kuan-Ting on 2020/11/14.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "test graph:\(indexPath.row)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0 == indexPath.row, let vc = storyboard?.instantiateViewController(withIdentifier: "TestGraphVCFirst") as? ViewController {
            navigationController?.pushViewController(vc, animated: true)
        } else if 1 == indexPath.row, let vc = storyboard?.instantiateViewController(withIdentifier: "AGPGraphViewController") as? AGPGraphViewController {
            navigationController?.pushViewController(vc, animated: true)
        } else if 2 == indexPath.row, let vc = storyboard?.instantiateViewController(withIdentifier: "CircleProgressViewController") as? CircleProgressViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


