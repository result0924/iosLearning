//
//  CustomTextView.swift
//  VerifyTextFieldTest
//
//  Created by lai Kuan-Ting on 2021/7/28.
//

import UIKit

protocol CustomTextViewDelegate: AnyObject {
    func textIsValid(textFiledTag: Int, isValid: Bool)
}

@IBDesignable
class CustomTextView: UIView, NibOwnerLoadable {

    @IBInspectable var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        textField.placeholder = placeholder
    }
    
    // MARK: IBOutlet
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var bottomLineView: UIView!
    private var regexString: String?
    private var warningString = ""
    weak var delegate: CustomTextViewDelegate?
    
    // MARK: Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    // MARK: Custom Init
    private func customInit() {
        loadNibContent()
        textField.delegate = self
    }
    
    // MARK: Awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.placeholder = placeholder
    }
    
    func updateCheckInfo(tag: Int, regex: String, warning: String) {
        regexString = regex
        warningString = warning
        textField.tag = tag
    }

}

extension CustomTextView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let regexString = regexString {
            let tempString = (text as NSString).replacingCharacters(in: range, with: string)
            let isValid = tempString.isValid(regularExpression: regexString)
            warningLabel.text = isValid || tempString.isEmpty ? "" : warningString
            delegate?.textIsValid(textFiledTag: textField.tag, isValid: isValid)
        }
        
        return true
    }
    
}

extension String {
    func isValid(regularExpression: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regularExpression).evaluate(with: self)
    }
}
