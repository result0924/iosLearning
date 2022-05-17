//
//  SliderViewController.swift
//  CombineTest
//
//  Created by lai Kuan-Ting on 2022/5/18.
//

import UIKit
import Combine

class SliderViewController: UIViewController {
    @IBOutlet weak private var slider: UISlider!
    @IBOutlet weak private var sliderLabel: UILabel!
    @IBOutlet weak private var computedSlider: UISlider!
    @IBOutlet weak private var computedLabel: UILabel!
    private var computedSliderValue: Float = 50 {
        didSet {
            computedSlider.value = computedSliderValue
            computedLabel.text = "Slider is at \(computedSliderValue)"
        }
    }
    @Published private var combineSliderValue: Float = 50
    var cancellable = Set<AnyCancellable>()
    @IBOutlet weak private var combineSlider: UISlider!
    @IBOutlet weak private var combineSliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider.addTarget(self, action: #selector(updateLabel), for: .valueChanged)
        computedSlider.addTarget(self, action: #selector(updateComputedLabel), for: .valueChanged)
        
        $combineSliderValue.map({ value in
            "combine slider is at :\(value)"
        }).assign(to: \.text, on: combineSliderLabel).store(in: &cancellable)
        combineSlider.addTarget(self, action: #selector(updateCombineLabel), for: .valueChanged)
    }
    
    @objc private func updateLabel() {
        sliderLabel.text = "slider is at \(slider.value)"
    }
    
    @objc private func updateComputedLabel() {
        computedSliderValue = computedSlider.value
    }
    
    @objc private func updateCombineLabel() {
        combineSliderValue = combineSlider.value
    }

}
