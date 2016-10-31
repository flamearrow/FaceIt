//
//  FaceView.swift
//  FaceIt
//
//  Created by Chen Cen on 9/25/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

// View
@IBDesignable
class FaceView: UIView {
    // instance vars are in init phase, until fully initialized, bounds can't be retrieved
    // instead, define a property to retrive it
    
    // let width = bounds.size.width
    
    // let height = bounds.size.height
    //    var skillRadius = min(width, height) / 2
    //    var skillCenter = CGPoint(x:bounds.midX, y:bounds.midY)

    @IBInspectable
    var scale: CGFloat = 0.90 {
        didSet {
            // request redraw
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    // 1 for smile, -1 for frown
    @IBInspectable
    var mouthCur: Double = 1.0 {
        didSet {
            // request redraw
            // call after the value is set
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var eyeClosed: Bool = false{
        didSet {
            // request redraw
            leftEye.eyeClosed = eyeClosed
            rightEye.eyeClosed = eyeClosed
        }
    }
    
    // 1 for forwn, -1 for relax
    @IBInspectable
    var eyeBrowTilt: CGFloat = -1.0 {
        didSet {
            // request redraw
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var color: UIColor = UIColor.blue{
        didSet {
            // request redraw
            setNeedsDisplay()
            leftEye.color = color
            rightEye.color = color
        }
    }

    @IBInspectable
    var lineWidth:CGFloat = 5.0{
        didSet {
            // request redraw
            setNeedsDisplay()
            leftEye.lineWidth = lineWidth
            rightEye.lineWidth = lineWidth
        }
    }

    func changeScale(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break;
        }
    }
    
    fileprivate var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    
    fileprivate var skullCenter: CGPoint {
        return CGPoint(x:bounds.midX, y:bounds.midY)
    }
    
    fileprivate struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToEyeMouthWidth: CGFloat = 1
        static let SkullRadiusToEyeMouthHeight: CGFloat = 3
        static let SkullRadiusToEyeMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 3
    }
    
    fileprivate enum Eye {
        case left
        case right
    }
    
    fileprivate func getEyeCenter(_ eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .left: eyeCenter.x -= eyeOffset
        case .right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
        
    }
    
    fileprivate func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToEyeMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToEyeMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToEyeMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        let smilOffset = CGFloat(max(-1, min(mouthCur, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x:mouthRect.minX + mouthRect.width / 3, y:mouthRect.minY + smilOffset)
        let cp2 = CGPoint(x:mouthRect.maxX - mouthRect.width / 3, y:mouthRect.minY + smilOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    // radius: internal/external names
    fileprivate func pathForCircleCenterAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        return eye
    }
    
    private func positionEye(eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.SkullRadiusToEyeRadius * 2
        eye.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    // this is the method in UIView to layout/position its subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(eye: leftEye, center: getEyeCenter(.left))
        positionEye(eye: rightEye, center: getEyeCenter(.right))
    }
    
//    fileprivate func pathForEye(_ eye: Eye) -> UIBezierPath {
//        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
//        let eyeCenter = getEyeCenter(eye)
//        if eyeClosed {
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLine(to: CGPoint(x:eyeCenter.x+eyeRadius, y:eyeCenter.y))
//            path.lineWidth = lineWidth
//            return path
//        } else {
//            return pathForCircleCenterAtPoint(eyeCenter, withRadius: eyeRadius)
//        }
//    }
    
    fileprivate func pathForBrow(_ eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .left:
            tilt *= -1.0
        case .right:
            break;
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x:browCenter.x + eyeRadius, y:browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        // frame is the rec cotaning this view, don't use it
        // bounds is the bound of current view
        color.set()
        // draw the shit
        pathForCircleCenterAtPoint(skullCenter, withRadius: skullRadius).stroke()
//        pathForEye(.left).stroke()
//        pathForEye(.right).stroke()
        pathForMouth().stroke()
        pathForBrow(.left).stroke()
        pathForBrow(.right).stroke()
    }

}
