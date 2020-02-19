//
//  SettingsViewController.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/07.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class SettingsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeImageBGButton: UIButton!
    @IBOutlet weak var takePictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
        
        takePictureButton.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        removeImageBGButton.addTarget(self, action: #selector(removeImageBackground), for: .touchUpInside)
        removeImageBGButton.isHidden = true
        
    }
    
    @objc fileprivate func removeImageBackground() {
        guard let data = imageView.image?.jpegData(compressionQuality: 1) else {
            let alert = UIAlertController(title: "Can't fetch image data from image", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }

        // register your account in `https://www.remove.bg/api`, and you can get api key
        let removeBGAPIKey = "x1y6NY3tR8qNeeKZkvQc9GFM"
        
        Alamofire.upload(
                multipartFormData: { builder in
                    builder.append(
                        data,
                        withName: "image_file",
                        fileName: "file.jpg",
                        mimeType: "image/jpeg"
                    )
                },
                to: URL(string: "https://api.remove.bg/v1.0/removebg")!,
                headers: [
                    "X-Api-Key": removeBGAPIKey
                ]
            ) { result in
                switch result {
                case .success(let upload, _, _):
                    upload.validate(statusCode: 200..<300).responseJSON { imageResponse in
                            guard let imageData = imageResponse.data,
                                let image = UIImage(data: imageData) else {
                                    
                                    let alert = UIAlertController(title: "Can't transfer image from image data, maybe you forget to change your api key", message: nil, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                    return
                            }

                            self.imageView.image = image
                            self.removeImageBGButton.isHidden = true
                            return
                    }
                case .failure:
                    let alert = UIAlertController(title: "Remove Background Fail", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
    }
    
    fileprivate func checkCameraPermission(_ completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: ({ granted in
                completion(granted)
            }))
        } else {
            completion(status == .authorized)
        }
    }
    
    @objc fileprivate func cameraAction() {
        checkCameraPermission { (granted: Bool) in
            if granted {
                DispatchQueue.main.async {
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Camera Access Denied", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func handleImage(image: UIImage) {
        self.imageView.image = resizeImage(image: image, targetSize: CGSize(width: 512, height: 512))
        removeImageBGButton.isHidden = false
    }

    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage! // swiftlint:disable:this force_unwrapping
    }
}

extension SettingsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        handleImage(image: image)
    }
}
