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

fileprivate func HourInClock(angle: CGFloat) -> UInt {
    
    if angle > 360 {
        
        return UInt(round((angle - 360) / 360 * 12) + 12)
        
    }
        
    else {
        
        return UInt(round(angle / 360 * 12))
        
    }
    
}

fileprivate func AngleInHour(hour: UInt) -> CGFloat {
    
    var display_hour = hour
    
    if hour == 0 { display_hour = 12 }
        
    else if hour > 12 { display_hour = hour - 12 }
    
    let angle = (0.5 * CGFloat(60 * display_hour))
    
    return angle
    
}

fileprivate func DeltaOfAngle(last: CGFloat, current: CGFloat) -> CGFloat {
    
    if last < 90 && current > 270 {
        
        return (current - 360)
        
    }
    
    else if last > 270 && current < 90 {
        
        return (360 + current) - last
        
    }
    
    else {
        
        return current - last
        
    }
    
}

public enum PLTimeSliderValueType {
    
    case start, end
    
}

public protocol PLTimeSliderDelegate: NSObjectProtocol {
    
    func slider(slider: PLTimeSlider, valueDidChanged value: UInt, type: PLTimeSliderValueType)
    
}

@IBDesignable public class PLTimeSlider: UIView {
    
    @IBInspectable public var thumbWidth: CGFloat = 40
    
    @IBInspectable public var lineWidth: CGFloat = 40
    
    @IBInspectable public var strokeColor: UIColor = UIColor.lightGray
    
    @IBInspectable public var fillColor: UIColor = UIColor.orange
    
    public weak var delegate: PLTimeSliderDelegate?
    
    var startThumb: PLTimeSliderThumb!
    
    var endThumb: PLTimeSliderThumb!
    
    var startAngle: CGFloat = 0
    
    var endAngle: CGFloat = 0
    
    @IBInspectable public var startHour: UInt {
        
        set {
            
            self.startAngle = CGFloat(360 / 12 * newValue)
            
            self.layoutSubviews()
            
        }
        
        get {
            
            return HourInClock(angle: self.startAngle)
            
        }
    
    }
    
    @IBInspectable public var endHour: UInt {
        
        set {
            
            self.endAngle = CGFloat(360 / 12 * newValue)
            
            self.layoutSubviews()
            
        }
        
        get {
            
            return HourInClock(angle: self.endAngle)
            
        }
        
    }
    
    var startBtnGesture: UIPanGestureRecognizer!
    
    var endBtnGesture: UIPanGestureRecognizer!
    
    var path: UIBezierPath!
    
    var arcLayer: CAShapeLayer!
    
    var isInit: Bool = false
    
    // MARK: Gesture Methods
    
    func pan(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
            
        case .began:
            
            break
            
        case .ended:
            
            guard let thumb = gesture.view as? PLTimeSliderThumb else { return }
            
            if thumb == self.startThumb {
                
                self.updateThumbLayout(thumb: self.startThumb, hour: self.startHour)
                
                self.startAngle = CGFloat(self.startHour * (360 / 12))
            
            }
                
            else if thumb == self.endThumb {
                
                self.updateThumbLayout(thumb: self.endThumb, hour: self.endHour)
                
                self.endAngle = CGFloat(self.endHour * (360 / 12))
            
            }
            
            var startAngle = AngleInHour(hour: self.startHour)
            
            var endAngle = AngleInHour(hour: self.endHour)
            
            if (self.startHour == 0 && self.endHour == 12) || (self.startHour == 12 && self.endHour == 24) || (self.startHour == 0 && self.endHour == 24) {
                
                startAngle = 0
                
                endAngle = 360
                
            }
            
            self.updateArcPath(startAngle: startAngle, endAngle: endAngle)
            
            break
            
        case .changed:
            
            guard let thumb = gesture.view as? PLTimeSliderThumb else { return }
            
            let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            
            let point = gesture.location(in: self)
            
            let angle = AngleInClock(center: center, point: point)
            
            if thumb == self.endThumb {
                
                let last_angle = (self.endAngle > 360) ? (self.endAngle - 360) : self.endAngle
                
                let new_angle = self.endAngle + DeltaOfAngle(last: last_angle, current: angle)
                
                if new_angle < 0 {
                
                    self.endAngle = 0
                    
                    self.updateThumbLayout(thumb: thumb, angle: self.endAngle)
                    
                    return
                
                }
                
                if new_angle < self.startAngle {
                
                    self.endAngle = self.startAngle
                    
                    self.updateThumbLayout(thumb: thumb, angle: self.endAngle)
                    
                    return
                
                }
                
                if new_angle > 720 { return }
                
                self.endAngle = new_angle
                
                self.updateThumbLayout(thumb: thumb, angle: self.endAngle)
                
                self.delegate?.slider(slider: self, valueDidChanged: self.endHour, type: .end)
                
            }
            
            else if thumb == self.startThumb {
                
                let last_angle = (self.startAngle > 360) ? (self.startAngle - 360) : self.startAngle
                
                let new_angle = self.startAngle + DeltaOfAngle(last: last_angle, current: angle)
                
                if new_angle < 0 {
                
                    self.startAngle = 0
                    
                    self.updateThumbLayout(thumb: thumb, angle: self.startAngle)
                    
                    return
                
                }
                
                if new_angle > self.endAngle {
                
                    self.startAngle = self.endAngle
                    
                    self.updateThumbLayout(thumb: thumb, angle: self.startAngle)
                    
                    return
                
                }
                
                self.startAngle = new_angle
                
                self.updateThumbLayout(thumb: thumb, angle: self.startAngle)
                
                self.delegate?.slider(slider: self, valueDidChanged: self.startHour, type: .start)
                
            }
            
            break
            
        case .cancelled:
            
            break
            
        default:
            
            break
            
        }
        
    }
    
    // MARK: Layout Methods
    
    func updateThumbLayout(thumb: PLTimeSliderThumb, hour: UInt) {
        
        var display_hour = hour
        
        if hour == 0 { display_hour = 12 }
        
        else if hour > 12 { display_hour = hour - 12 }
        
        let angle = (0.5 * CGFloat(60 * display_hour))
        
        self.updateThumbLayout(thumb: thumb, angle: angle)
        
    }
    
    func updateThumbLayout(thumb: PLTimeSliderThumb, angle: CGFloat) {
        
        let inset = self.lineWidth / 2
        
        let rect = self.bounds.insetBy(dx: inset, dy: inset)
        
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        let radius = rect.width / 2
        
        let point = PointInClock(center: center, radius: radius, angle: angle)
        
        thumb.frame = CGRect(x: 0, y: 0, width: self.thumbWidth, height: self.thumbWidth)
        
        thumb.center = point
        
        let startAngle = (self.startAngle > 360) ? (self.startAngle - 360) : self.startAngle
        
        let endAngle = (self.endAngle > 360) ? (self.endAngle - 360) : self.endAngle
        
        self.updateArcPath(startAngle: startAngle, endAngle: endAngle)
        
    }
    
    func updateArcPath(startAngle: CGFloat, endAngle: CGFloat) {
        
        let inset = self.lineWidth / 2
        
        let rect = self.bounds.insetBy(dx: inset, dy: inset)
        
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        let radius = rect.width / 2
        
        self.arcLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: ToRadian(degree: startAngle - 90), endAngle: ToRadian(degree: endAngle - 90), clockwise: true).cgPath
        
        self.arcLayer.fillColor = UIColor.clear.cgColor
        
        self.arcLayer.strokeColor = self.fillColor.cgColor
        
        self.arcLayer.lineWidth = self.lineWidth
        
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
        
        self.startBtnGesture = UIPanGestureRecognizer(target: self, action: #selector(PLTimeSlider.pan(_:)))
        
        self.endBtnGesture = UIPanGestureRecognizer(target: self, action: #selector(PLTimeSlider.pan(_:)))
        
        self.arcLayer = CAShapeLayer()
        
        self.startThumb = PLTimeSliderThumb(frame: CGRect(x: 0, y: 0, width: self.thumbWidth, height: self.thumbWidth))
        
        self.endThumb = PLTimeSliderThumb(frame: CGRect(x: 0, y: 0, width: self.thumbWidth, height: self.thumbWidth))
        
        self.layer.addSublayer(self.arcLayer)
        
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
