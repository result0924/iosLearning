//
//  ViewController.swift
//  VerifyTextFieldTest
//
//  Created by lai Kuan-Ting on 2021/7/28.
//

import UIKit

class ViewController: UIViewController {
    enum textViewType: Int {
        case firstName
        case lastName
    }

    struct checkItem {
        let item: textViewType
        var isValid: Bool
    }
    
    @IBOutlet private weak var lastNameView: CustomTextView!
    @IBOutlet private weak var firstNameView: CustomTextView!
    @IBOutlet private weak var completeButton: UIButton!
    private var checkItemArray: [checkItem] = [.init(item: .firstName, isValid: false), .init(item: .lastName, isValid: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let regexString = "[a-z]{0,6}"
        let warningString = "word must be english and can't more than six"
        lastNameView.updateCheckInfo(tag: textViewType.lastName.rawValue, regex: regexString, warning: warningString)
        lastNameView.delegate = self
        firstNameView.updateCheckInfo(tag: textViewType.firstName.rawValue, regex: regexString, warning: warningString)
        firstNameView.delegate = self
    }

    func checkItemStatus(textFiledTag: Int, isValid: Bool) {
        checkItemArray.indices.forEach {
            if checkItemArray[$0].item.rawValue == textFiledTag {
                checkItemArray[$0].isValid = isValid
            }
        }
        
        completeButton.isEnabled = checkItemArray.filter({$0.isValid == true}).count == checkItemArray.count
        
    }
    
    @IBAction func tapCompleteButton(_ sender: Any) {
        print("tapCompleteButton")
    }
}

extension ViewController: CustomTextViewDelegate {
    func textIsValid(textFiledTag: Int, isValid: Bool) {
        checkItemStatus(textFiledTag: textFiledTag, isValid: isValid)
    }
}
