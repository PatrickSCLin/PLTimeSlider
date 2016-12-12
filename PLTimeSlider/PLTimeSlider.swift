//
//  PLTimeSlider.swift
//  PLTimeSlider
//
//  Created by Patrick Lin on 09/12/2016.
//  Copyright © 2016 Patrick Lin. All rights reserved.
//

import UIKit

fileprivate func ToRadian(degree: CGFloat) -> CGFloat {
    
    return CGFloat(M_PI) * degree / 180.0
    
}

fileprivate func ToDegree(radian: CGFloat) -> CGFloat {
    
    return 180.0 * radian / CGFloat(M_PI)
    
}

fileprivate func AngleInClock(center: CGPoint, point: CGPoint) -> CGFloat {
    
    var v = CGPoint(x: point.x - center.x, y: point.y - center.y)
    
    let vmag = sqrt((v.x * v.x) + (v.y * v.y))
    
    var angle: CGFloat = 0
    
    v.x /= vmag
    
    v.y /= vmag
    
    let radian = atan2(v.y, v.x)
    
    angle = ToDegree(radian: radian)
    
    if angle < 0 { angle += 360 }
    
    let currentAngle = Int(floor(angle))
    
    angle = CGFloat(360 - 90 - currentAngle)
    
    return (angle < 0) ? (-angle) : (270 - angle + 90)
    
}

fileprivate func PointInClock(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
    
    let x = center.x + radius * cos(ToRadian(degree: angle - 90))
    
    let y = center.y + radius * sin(ToRadian(degree: angle - 90))
    
    return CGPoint(x: x, y: y)
    
}

public enum PLTimeSliderValueType {
    
    case start, end
    
}

public protocol PLTimeSliderDelegate: NSObjectProtocol {
    
    func slider(slider: PLTimeSlider, valueDidChanged value: UInt, type: PLTimeSliderValueType)
    
}

@IBDesignable public class PLTimeSlider: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 30
    
    @IBInspectable var strokeColor: UIColor = UIColor.lightGray
    
    public weak var delegate: PLTimeSliderDelegate?
    
    var startThumb: PLTimeSliderThumb!
    
    var endThumb: PLTimeSliderThumb!
    
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
            
            if let thumb = gesture.view as? PLTimeSliderThumb {
                
                if thumb == self.startThumb { self.updateThumbLayout(thumb: self.startThumb, hour: self.startHour) }
                    
                else if thumb == self.endThumb { self.updateThumbLayout(thumb: self.endThumb, hour: self.endHour) }
                
            }
            
            break
            
        case .changed:
            
            print("changed")
            
            let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            
            let point = gesture.location(in: self)
            
            let angle = AngleInClock(center: center, point: point)
            
            self.updateThumbLayout(thumb: gesture.view as! PLTimeSliderThumb, angle: angle)
            
            if let thumb = gesture.view as? PLTimeSliderThumb {
                
                var hour = UInt(round((angle / 360) * 12))
                
                if hour == 0 { hour = 12 }
                
                if thumb == self.startThumb {
                    
                    self.startHour = hour
                
                    self.delegate?.slider(slider: self, valueDidChanged: self.startHour, type: .start)
                
                }
                
                else if thumb == self.endThumb {
                    
                    self.endHour = hour
                    
                    self.delegate?.slider(slider: self, valueDidChanged: self.endHour, type: .end)
                
                }
                
            }
            
            break
            
        case .cancelled:
            
            print("cancelled")
            
            break
            
        default:
            
            break
            
        }
        
    }
    
    // MARK: Layout Methods
    
    func updateThumbLayout(thumb: PLTimeSliderThumb, hour: UInt) {
        
        let angle = (0.5 * CGFloat(60 * hour))
        
        self.updateThumbLayout(thumb: thumb, angle: angle)
        
    }
    
    func updateThumbLayout(thumb: PLTimeSliderThumb, angle: CGFloat) {
        
        let inset = self.lineWidth / 2
        
        let rect = self.bounds.insetBy(dx: inset, dy: inset)
        
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        let radius = rect.width / 2
        
        let point = PointInClock(center: center, radius: radius, angle: angle)
        
        thumb.frame = CGRect(x: 0, y: 0, width: self.lineWidth, height: self.lineWidth)
        
        thumb.center = point
        
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.layoutIfNeeded()
        
        if self.isInit == false { self.commonInit() }
        
        self.updateThumbLayout(thumb: self.startThumb, hour: self.startHour)
        
        self.updateThumbLayout(thumb: self.endThumb, hour: self.endHour)
        
    }
    
    // MARK: Draw Methods

    override public func draw(_ rect: CGRect) {
     
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
        
        self.startThumb = PLTimeSliderThumb()
        
        self.endThumb = PLTimeSliderThumb()
        
        self.addSubview(self.startThumb)
        
        self.addSubview(self.endThumb)
        
        self.startThumb.addGestureRecognizer(self.startBtnGesture)
        
        self.endThumb.addGestureRecognizer(self.endBtnGesture)
        
        self.isInit = true
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }

}
