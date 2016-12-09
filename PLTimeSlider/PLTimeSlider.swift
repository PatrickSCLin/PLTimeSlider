//
//  PLTimeSlider.swift
//  PLTimeSlider
//
//  Created by Patrick Lin on 09/12/2016.
//  Copyright © 2016 Patrick Lin. All rights reserved.
//

import UIKit

@IBDesignable class PLTimeSlider: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 30
    
    @IBInspectable var strokeColor: UIColor = UIColor.lightGray
    
    var startBtn: UIView!
    
    var endBtn: UIView!
    
    var startHour: UInt = 12
    
    var endHour: UInt = 12
    
    var startBtnGesture: UIPanGestureRecognizer!
    
    var endBtnGesture: UIPanGestureRecognizer!
    
    var path: UIBezierPath!
    
    var isInit: Bool = false
    
    // MARK: Gesture Methods
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        switch gesture.state {
            
        case .began:
            
            print("began")
            
            break
            
        case .ended:
            
            print("ended")
            
            break
            
        case .changed:
            
            print("changed")
            
            let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            
            let point = gesture.location(in: self)
            
            //point.y - center.y, center.x - point.x
            
            var degree = (atan2(point.y - center.y, center.x - point.x) * 180 / CGFloat(M_PI))
            
            if degree < 0 { degree += 360 }
            
            print("degree: \(degree)")
            
            break
            
        case .cancelled:
            
            print("cancelled")
            
            break
            
        default:
            
            break
            
        }
        
    }
    
    // MARK: Layout Methods
    
    func updateBtnLayout(btn: UIView, hour: UInt) {
        
        self.layoutIfNeeded()
        
        let inset = self.lineWidth / 2
        
        let rect = self.bounds.insetBy(dx: inset, dy: inset)
        
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        let radius = rect.width / 2
        
        let angel = (0.5 * CGFloat(60 * hour)) - 90
        
        let point = self.pointOfCircle(center: center, radius: radius, angle: angel)
        
        btn.frame = CGRect(x: 0, y: 0, width: self.lineWidth, height: self.lineWidth)
        
        btn.center = point
        
        btn.layer.cornerRadius = self.lineWidth / 2
        
        btn.layer.backgroundColor = UIColor.white.cgColor
        
    }
    
    func pointOfCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        
        let x = center.x + (radius * cos(angle * CGFloat(M_PI) / 180))
        
        let y = center.y + (radius * sin(angle * CGFloat(M_PI) / 180))
        
        return CGPoint(x: x, y: y)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.isInit == false { self.commonInit() }
        
        self.updateBtnLayout(btn: self.startBtn, hour: self.startHour)
        
        self.updateBtnLayout(btn: self.endBtn, hour: self.endHour)
        
    }
    
    // MARK: Draw Methods

    override func draw(_ rect: CGRect) {
     
        super.draw(rect)
        
        self.strokeColor.setStroke()
        
        let inset = self.lineWidth / 2
        
        self.path = UIBezierPath(ovalIn: rect.insetBy(dx: inset, dy: inset))
        
        self.path.lineWidth = self.lineWidth
        
        self.path.stroke()
        
    }
    
    // MARK: Init Methods
    
    func commonInit() {
        
        self.startBtnGesture = UIPanGestureRecognizer(target: self, action: #selector(PLTimeSlider.tap(_:)))
        
        self.endBtnGesture = UIPanGestureRecognizer(target: self, action: #selector(PLTimeSlider.tap(_:)))
        
        self.startBtn = UIView()
        
        self.endBtn = UIView()
        
        self.addSubview(self.startBtn)
        
        self.addSubview(self.endBtn)
        
        self.startBtn.addGestureRecognizer(self.startBtnGesture)
        
        self.endBtn.addGestureRecognizer(self.endBtnGesture)
        
        self.isInit = true
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }

}
