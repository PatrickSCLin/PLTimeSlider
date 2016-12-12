//
//  PLTimeSliderThumb.swift
//  PLTimeSlider
//
//  Created by Patrick Lin on 12/12/2016.
//  Copyright © 2016 Patrick Lin. All rights reserved.
//

import UIKit

@IBDesignable class PLTimeSliderThumb: UIView {

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        UIColor.clear.setFill()
        
        UIRectFill(rect)
        
        UIColor.white.setFill()
        
        UIBezierPath(ovalIn: rect.insetBy(dx: 1, dy: 1)).fill()
        
    }
    
    // MARK: Init Methods
    
    func commonInit() {
        
        self.isOpaque = false
        
        self.clipsToBounds = true
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.commonInit()
        
    }

}
