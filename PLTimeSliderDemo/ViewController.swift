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
    
    // MARK: Time Slider Methods
    
    func slider(slider: PLTimeSlider, valueDidChanged value: UInt, type: PLTimeSliderValueType) {
        
        if type == .start {
            
            self.startLable.text = String(format: "%02d:00", value)
            
        }
        
        else if type == .end {
            
            self.endLable.text = String(format: "%02d:00", value)
            
        }
        
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

