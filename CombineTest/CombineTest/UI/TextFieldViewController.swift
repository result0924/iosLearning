//
//  TextFieldViewController.swift
//  CombineTest
//
//  Created by lai Kuan-Ting on 2022/5/27.
//

import UIKit
import Combine

class TextFieldViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @Published var searchQuery: String?
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        $searchQuery.assign(to: \.text, on: label).store(in: &cancellables)
//        $searchQuery.debounce(for: 0.3, scheduler: DispatchQueue.main).assign(to: \.text, on: label).store(in: &cancellables)
//        $searchQuery.debounce(for: 0.3, scheduler: DispatchQueue.main).filter({($0 ?? "").count > 2}).assign(to: \.text, on: label).store(in: &cancellables)
//        $searchQuery.debounce(for: 0.3, scheduler: DispatchQueue.main).filter({($0 ?? "").count > 2}).removeDuplicates().print().assign(to: \.text, on: label).store(in: &cancellables)
    }

    @objc func textChanged() {
        searchQuery = textField.text
    }

}
