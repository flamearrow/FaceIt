//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Chen Cen on 10/2/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    private let emotionalFaces = [
        "angry": FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationVC = segue.destinationViewController
        // instanceof, if null don't do anything
        // note here since the segue is navitating to a NavigationController leading a FaceViewController, 
        // we need to first cast it into a destinationVC and gets the wrapped visibileViewController inside
        if let navVC = destinationVC as? UINavigationController {
           destinationVC = navVC.visibleViewController ?? destinationVC
        }
        if let faceVC = destinationVC as? FaceViewController {
            if let id = segue.identifier {
                if let expression = emotionalFaces[id] {
                    faceVC.expression = expression
                }
                // set title
                if let senderButton = sender as? UIButton {
                    faceVC.navigationItem.title = senderButton.currentTitle
                }
            }
        }
        
    }

}
