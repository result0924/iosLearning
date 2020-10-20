//
//  ViewController.swift
//  CombineTest
//
//  Created by jlai on 2020/10/15.
//

import Combine
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var termSwitch: UISwitch!
    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollerView: UIScrollView!
    
    @Published private var acceptedTerms: Bool = false
    @Published private var acceptedPrivacy: Bool = false
    @Published private var name: String = ""
    
    private var stream: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Terms of Use"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollerView.addGestureRecognizer(tap)
        stream = validToSubmit.receive(on: RunLoop.main).assign(to: \.isEnabled, on: submitButton)
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
            adjustContentInsets(contentInsets)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        adjustContentInsets(.zero)
    }
    
    private func adjustContentInsets(_ contentInsets: UIEdgeInsets) {
        scrollerView.contentInset = contentInsets
        scrollerView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction private func acceptTerms(_ sender: UISwitch) {
        acceptedTerms = sender.isOn
    }

    @IBAction private func acceptPrivacy(_ sender: UISwitch) {
        acceptedPrivacy = sender.isOn
    }
    
    @IBAction private func nameChanged(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    
    @IBAction private func submitAction(_ sender: UIButton) {
        print("submit... \(name)")
    }
    
    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($acceptedTerms, $acceptedPrivacy, $name)
            .map { terms, privacy, name in
                terms && privacy && name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
            }.eraseToAnyPublisher()
    }
}


