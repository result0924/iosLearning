//
//  NotificationCenterSampleViewController.swift
//  CombineTest
//
//  Created by lai Kuan-Ting on 2022/5/30.
//

import UIKit
import Combine

class NotificationCenterSampleViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    let zipOneNotificationName = Notification.Name("zipOne")
    let zipTwoNotificationName = Notification.Name("zipTwo")
    let defaultNotification = Notification.Name("com.donnywals.customNotification")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
        let testDefault = UIButton()
        testDefault.setTitle("test default", for: .normal)
        testDefault.addTarget(self, action: #selector(tapTestDefaultNotification), for: .touchUpInside)
        testDefault.backgroundColor = .gray
        
        let testZip = UIButton()
        testZip.setTitle("test zip", for: .normal)
        testZip.addTarget(self, action: #selector(tapTestZipNotification), for: .touchUpInside)
        testZip.backgroundColor = .red
        
        let testZip2 = UIButton()
        testZip2.setTitle("test zip 2", for: .normal)
        testZip2.addTarget(self, action: #selector(tapZIP2), for: .touchUpInside)
        testZip2.backgroundColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [testDefault, testZip, testZip2])
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.axis = .vertical
        stackView.spacing = 16
    }
    
    @IBAction func tapTestZipNotification() {
        let firstNotification = Notification(name: zipOneNotificationName)
        let secondNotification = Notification(name: zipTwoNotificationName)
        let first = NotificationCenter.default.publisher(for: zipOneNotificationName)
        let second = NotificationCenter.default.publisher(for: zipTwoNotificationName)
//        Publishers.Zip(first, second).sink(receiveValue: { val in
//            print(val, "zipped")
//        }).store(in: &cancellables)
        
        first.zip(second).sink(receiveValue: { val in print(val, "zipped")
        }).store(in: &cancellables)

        print("send first")
        NotificationCenter.default.post(firstNotification)
        print("send second")
        NotificationCenter.default.post(secondNotification)
        print("send third")
        NotificationCenter.default.post(firstNotification)
        print("send fourth")
        NotificationCenter.default.post(secondNotification)
        
        cancellables.removeAll()
    }
    
    @IBAction func tapTestDefaultNotification() {
        NotificationCenter.default.publisher(for: defaultNotification).handleEvents(receiveCancel: {
            print(">> cancel")
        })
        .sink(receiveValue: { notification in print("Received a notification!")
        }).store(in: &cancellables)
        
        NotificationCenter.default.post(Notification(name: defaultNotification))
        cancellables.removeAll()
    }
    
    @IBAction func tapZIP2() {
        let left = CurrentValueSubject<Int, Never>(1)
        let right = CurrentValueSubject<Int, Never>(1)
        left.zip(right).sink(receiveValue: { value in print(value)
        }).store(in: &cancellables)
        left.value = 1
        left.value = 2
        left.value = 3
        right.value = 2
        right.value = 2
        cancellables.removeAll()
    }

}
