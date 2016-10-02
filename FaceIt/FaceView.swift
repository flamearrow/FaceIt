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
            setNeedsDisplay()
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
    var color: UIColor = UIColor.blueColor(){
        didSet {
            // request redraw
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var lineWidth:CGFloat = 5.0{
        didSet {
            // request redraw
            setNeedsDisplay()
        }
    }

    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break;
        }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x:bounds.midX, y:bounds.midY)
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToEyeMouthWidth: CGFloat = 1
        static let SkullRadiusToEyeMouthHeight: CGFloat = 3
        static let SkullRadiusToEyeMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
        
    }
    
    private func pathForMouth() -> UIBezierPath {
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
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    // radius: internal/external names
    private func pathForCircleCenterAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        if eyeClosed {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLineToPoint(CGPoint(x:eyeCenter.x+eyeRadius, y:eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        } else {
            return pathForCircleCenterAtPoint(eyeCenter, withRadius: eyeRadius)
        }
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left:
            tilt *= -1.0
        case .Right:
            break;
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x:browCenter.x + eyeRadius, y:browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        // frame is the rec cotaning this view, don't use it
        // bounds is the bound of current view
        color.set()
        // draw the shit
        pathForCircleCenterAtPoint(skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        pathForBrow(.Left).stroke()
        pathForBrow(.Right).stroke()
    }

}
