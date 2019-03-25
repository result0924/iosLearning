//
//  ViewController.swift
//  collectionViewTest
//
//  Created by justin on 2019/2/22.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView: UICollectionView? = nil
    let collectionViewCellReuseID = "itemCell"
    let collectionArray:[String] = ["1", "2", "3", "4", "5", "6"]
    let kScreenWidth = UIScreen.main.bounds.size.width
    let kScreenHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createCollectionView()
    }
    
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = self.view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
        
        if let collectionView = collectionView {
            self.view.addSubview(collectionView)
            self.collectionView?.register(customCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuseID)
        }
        
    }

    // MARK - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: customCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseID, for: indexPath) as! customCollectionViewCell
        cell.configure(str: collectionArray[indexPath.row])
        cell.backgroundColor = UIColor.random()
        
        return cell
    }
}

class customCollectionViewCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel.init(frame: CGRect(x: 15, y: 90, width: 100, height: 44))
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(str: String) {
        label.text = str
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

