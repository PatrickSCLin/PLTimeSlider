//
//  ViewController.swift
//  PLTimeSliderDemo
//
//  Created by Patrick Lin on 09/12/2016.
//  Copyright © 2016 Patrick Lin. All rights reserved.
//

import UIKit
import PLTimeSlider

class ViewController: UIViewController, PLTimeSliderDelegate {
    
    @IBOutlet var slider: PLTimeSlider!
    
    @IBOutlet var startLable: UILabel!
    
    @IBOutlet var endLable: UILabel!
    
    @IBOutlet var totalLabel: UILabel!
    
    // MARK: Time Slider Methods
    
    func slider(slider: PLTimeSlider, valueDidChanged value: UInt, type: PLTimeSliderValueType) {
        
        if type == .start {
            
            self.startLable.text = String(format: "%02d:00", value)
            
            self.monoFont(label: self.startLable, weight: UIFontWeightBold)
            
        }
        
        else if type == .end {
            
            self.endLable.text = String(format: "%02d:00", value)
            
            self.monoFont(label: self.endLable, weight: UIFontWeightBold)
            
        }
        
        let total = slider.endHour - slider.startHour
        
        self.totalLabel.text = "\(total)  Hours"
        
        self.monoFont(label: self.totalLabel, weight: UIFontWeightBold)
        
    }
    
    // MARK: Interal Methods
    
    func monoFont(label: UILabel, weight: CGFloat) {
        
        label.font = UIFont.monospacedDigitSystemFont(ofSize: label.font.pointSize, weight: weight)
        
    }
    
    // MARK: Init Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.slider.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}

