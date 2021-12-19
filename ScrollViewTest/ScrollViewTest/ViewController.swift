//
//  ViewController.swift
//  ScrollViewTest
//
//  Created by lai Kuan-Ting on 2021/12/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupContent()
    }
    
    private func setupContent() {
        let stringArray = ["READ THE TRANSCRIPT",
                           "The Hobson family had been meaning to buy some new furniture for ages, but somehow they never got round to it. There were always so many other things to do. Then one day there was a big shout from Joe's room.",
                           "The rest of the family ran to see what was the matter.",
                           "Joe's desk had collapsed. There were bits of wood and pens and papers all over the floor. And in the middle was - Joe!",
                           "I was just doing my homework,” he said, “and then – bang! The desk broke. Everything fell over. I was so surprised that I fell over too!",
                           "Bella giggled. “You do look funny!”",
                           "“That decides it,” said Mum. “We need to buy some new furniture before anything else breaks. Bella needs a new bed. And Joe definitely needs a desk, so that he can do his homework.”"]
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let endString = NSAttributedString(string: "\n\nHappy End",
                                           attributes: attributes)
        
        let attributeString = NSMutableAttributedString()
        var contentAttributed: [NSAttributedString.Key: Any] = [:]
        for (index, string) in stringArray.enumerated() {
            var editedString = string
            if index == 0 {
                contentAttributed[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 30, weight: .regular)
                contentAttributed[NSAttributedString.Key.foregroundColor] = UIColor.red
            } else {
                contentAttributed[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 20, weight: .regular)
                contentAttributed[NSAttributedString.Key.foregroundColor] = UIColor.lightGray
                editedString = "\n\n" + editedString
            }
            attributeString.append(NSAttributedString(string: editedString, attributes: contentAttributed))
        }
        attributeString.append(endString)
        setupView(content: attributeString)
    }
    
    private func setupView(content: NSMutableAttributedString) {
        let completeButton = UIButton()
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completeButton)
        completeButton.backgroundColor = UIColor.systemBlue
        completeButton.setTitle("Done", for: .normal)
        completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        completeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: completeButton.topAnchor).isActive = true

        let contentLayoutGuide = scrollView.contentLayoutGuide

        let completeImageView = UIImageView()
        completeImageView.translatesAutoresizingMaskIntoConstraints = false
        completeImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(completeImageView)
        completeImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        completeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        completeImageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 40).isActive = true
        completeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        completeImageView.image = UIImage(named: "sync_success_icon")

        let completeDetailTextView = UITextView()
        completeDetailTextView.backgroundColor = .clear
        completeDetailTextView.isScrollEnabled = false
        completeDetailTextView.isEditable = false
        completeDetailTextView.isSelectable = false
        completeDetailTextView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(completeDetailTextView)
        completeDetailTextView.topAnchor.constraint(equalTo: completeImageView.bottomAnchor, constant: 20).isActive = true
        completeDetailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        completeDetailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        completeDetailTextView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        completeDetailTextView.attributedText = content
    }

}

