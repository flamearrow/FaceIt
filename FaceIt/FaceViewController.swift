//
//  ViewController.swift
//  FaceIt
//
//  Created by Chen Cen on 9/25/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

// controller
// controls View and Model, take value from model and reflect it on UI when value changes
class FaceViewController: UIViewController {
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smile) {
        didSet {
            // note this is not call in init, need to explicit set it to make this called
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            // this will be called when faceView is hooked up
            // #selector returns an function with one parameters(_:)
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView,
                action: #selector(FaceView.changeScale(_:))))
            let happierSwiperRec = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.makeHappier))
            happierSwiperRec.direction = .Up
            faceView.addGestureRecognizer(happierSwiperRec)
            
            let sadderSwiperRec = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.makeSadder))
            sadderSwiperRec.direction = .Down
            faceView.addGestureRecognizer(sadderSwiperRec)
            updateUI()
        }
    }
    
    @IBAction func changeBrow(sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .Changed,.Ended:
            if sender.rotation > CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                sender.rotation = 0.0
            } else if sender.rotation < -CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                sender.rotation = 0.0
            }
        default:
            break
        }
    }

    @IBAction func toggleEye(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
        switch expression.eyes {
        case .Open:
            expression.eyes = .Closed
        case .Closed:
            expression.eyes = .Open
        case .Squinting:
            break
        }
        }
    }

    func makeHappier() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func makeSadder() {
        expression.mouth = expression.mouth.sadderMouth()
    }

    // a dictionary mapping enum to int
    private var mouthCurvs = [FacialExpression.Mouth.Frown:-1.0, FacialExpression.Mouth.Smirk:-0.5, FacialExpression.Mouth.Neutural:0.0, FacialExpression.Mouth.Grin:0.5, FacialExpression.Mouth.Smile: 1.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Furrowed:CGFloat(-0.5),FacialExpression.EyeBrows.Relaxed:CGFloat(0.5),FacialExpression.EyeBrows.Normal:CGFloat(0.0)]
    
    // note updateUI might be called before faceView is set e.g prepareSegue, so need to do nil check here
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Closed:
                faceView.eyeClosed = true
            case .Open:
                faceView.eyeClosed = false
            case .Squinting:
                faceView.eyeClosed = true
            }
            
            faceView.mouthCur = mouthCurvs[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
}

