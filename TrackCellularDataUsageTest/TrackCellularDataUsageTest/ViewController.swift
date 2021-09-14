//
//  ViewController.swift
//  TrackCellularDataUsageTest
//
//  Created by lai Kuan-Ting on 2021/9/14.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private let imageUrls:[String] = ["https://s2.best-wallpaper.net/wallpaper/1024x768/2109/Morning-field-trees-house-green-sunshine_1024x768.jpg", "https://s2.best-wallpaper.net/wallpaper/1024x768/2109/Scotland-lake-clouds-mountains_1024x768.jpg", "https://s2.best-wallpaper.net/wallpaper/1024x768/2108/Beautiful-space-planets-stars-water-lake-creative-design-picture_1024x768.jpg", "https://s2.best-wallpaper.net/wallpaper/1024x768/2109/Gray-kitten-look-face-cute-pet_1024x768.jpg", "https://s2.best-wallpaper.net/wallpaper/1024x768/2105/Art-painting-village-river-people-trees-boats_1024x768.jpg", "https://s2.best-wallpaper.net/wallpaper/1024x768/2105/Anime-girl-umbrella-waterfall-red-leaves-autumn_1024x768.jpg"].shuffled()
    @IBOutlet weak private var changeImageButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var downloadDataByteLabel: UILabel!
    @IBOutlet weak private var cellularDataUsageLabel: UILabel!
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadImageAndReload()
    }

    @IBAction func tapChangeImageButton(_ sender: Any) {
        downloadImageAndReload()
    }
    
    private func downloadImageAndReload() {
        let imageUrl = imageUrls[currentIndex]

        Alamofire.request(imageUrl).responseData(completionHandler: { response in
            if let imageData = response.data {
                self.downloadDataByteLabel.text = "\(imageData)"
                self.imageView.image = UIImage(data: imageData)
                // increment the index to cycle through items
                self.currentIndex = (self.currentIndex + 1) % self.imageUrls.count
            }
        })
        
    }
    
}

