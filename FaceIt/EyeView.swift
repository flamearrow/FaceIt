//
//  EyeView.swift
//  FaceIt
//
//  Created by Chen Cen on 10/30/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class EyeView: UIView {
    var lineWidth: CGFloat = 0.5 { didSet{ setNeedsDisplay()} }
    var color: UIColor = UIColor.blue { didSet{ setNeedsDisplay()} }
    var _eyeClosed: Bool = false { didSet{ setNeedsDisplay()} }
    
    var eyeClosed: Bool  {
        set {
            // the animation happens between two states of the view, the two states are defined in the animations block, the animation is calculated based on the options
            // in this case, the two states are a circle and a line, based on the options, the animation is calculated between the two states
            UIView.transition(
                with: self,
                duration: 0.2,
                options: [.transitionFlipFromTop, .curveLinear],
                animations: {
                    self._eyeClosed = newValue
                },
                completion: nil)
        }
        get {
            return self._eyeClosed
        }
    }
    
    override func draw(_ rect: CGRect) {
        var path: UIBezierPath!
        
        if eyeClosed {
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        } else {
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }

}
