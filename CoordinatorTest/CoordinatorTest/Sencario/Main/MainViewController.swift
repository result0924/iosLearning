//
//  MainViewController.swift
//  CoordinatorTest
//
//  Created by justin on 2019/12/27.
//  Copyright © 2019 jlai. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func tapCellWithIndexPath(_ indexPath: IndexPath)
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Main"
    }

}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }

}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.tapCellWithIndexPath(indexPath)
    }
}

