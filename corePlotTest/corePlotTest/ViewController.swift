//
//  ViewController.swift
//  corePlotTest
//
//  Created by justin on 2019/4/19.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit
import CorePlot

class ViewController: UIViewController {

    @IBOutlet weak var hostView: CPTGraphHostingView!
    
    lazy var graph: CPTXYGraph = {
        let graph = CPTXYGraph()
        return graph
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hostView.hostedGraph = graph
    }


}

