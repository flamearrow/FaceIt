//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Chen Cen on 10/2/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    fileprivate let emotionalFaces = [
        "angry": FacialExpression(eyes: .closed, eyeBrows: .furrowed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile),
        "worried": FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smirk),
        "mischievious": FacialExpression(eyes: .open, eyeBrows: .furrowed, mouth: .grin)
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
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
