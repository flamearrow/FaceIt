//
//  SecumCounter.swift
//  FaceIt
//
//  Created by Chen Cen on 4/23/17.
//  Copyright © 2017 Chen Cen. All rights reserved.
//

import UIKit

class SecumCounter: UIView {
    var text:String = "mlgb" {
        didSet {
            setNeedsDisplay();
            setNeedsLayout();
        }
    }
    
    var heartImage:UIImage = UIImage(named: "heart_solid.png")!;
    
    override func draw(_ rect: CGRect) {
        // this should fix the black square issue
        self.isOpaque = false;
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return;
        }
        let size = self.bounds.size;
        
        let image = UIImage(named:"cat_timer.png")!;
        
        image.draw(in:rect);
        
        heartImage.draw(in: rect, blendMode: .normal, alpha: 0);
        
        context.translateBy (x: size.width / 2, y: size.height / 2);
        context.scaleBy (x: 1, y: -1);

        centre(text: self.text, context: context, radius: 0, angle: 0 , color: UIColor.black, font: UIFont.systemFont(ofSize: 30), slantAngle: 0);
        
    }
    
    
    private func centre(text str: String, context: CGContext, radius r:CGFloat, angle theta: CGFloat, color c: UIColor, font: UIFont, slantAngle: CGFloat) {
        // *******************************************************
        // This draws the String str centred at the position
        // specified by the polar coordinates (r, theta)
        // i.e. the x= r * cos(theta) y= r * sin(theta)
        // and rotated by the angle slantAngle
        // *******************************************************
        
        // Set the text attributes
        let attributes = [NSForegroundColorAttributeName: c,
                          NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: -1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(attributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy (x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }
    
    func explode() {
        UIView.animateKeyframes(
            withDuration: 1.0,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                    self.transform = CGAffineTransform(scaleX: 0, y: 0)
                });
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                });
                
        })

    }
    
    func clear() {
        self.layer.removeAllAnimations();
    }

    func bounce() {
        UIView.animateKeyframes(
            withDuration: 1.0,
            delay: 2,
            options: [.repeat],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                    self.frame.origin.y -= 50;
                });
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5, animations: {
                    self.frame.origin.y += 50;
                });
                
        })
    }
    
    
    func pulse() {
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 1.5,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    
    static let shakeDuration = 0.18;
    static let shakeAngle = CGFloat(Double.pi / 9);
    func shake() {
        UIView.animateKeyframes(
            withDuration: SecumCounter.shakeDuration,
            delay: 0.5,
            options: [.repeat],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                    self.transform = CGAffineTransform(rotationAngle: SecumCounter.shakeAngle);
                });
                    
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5, animations: {
                    self.transform = CGAffineTransform(rotationAngle: -SecumCounter.shakeAngle);
                });
                
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                    self.transform = CGAffineTransform(rotationAngle:0);
                });
            }
        )
    }
    
    func setLabelText(_ text:String) {
        self.text = text;
    }
}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
