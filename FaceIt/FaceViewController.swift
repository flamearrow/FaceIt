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
    var expression = FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smile) {
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
            happierSwiperRec.direction = .up
            faceView.addGestureRecognizer(happierSwiperRec)
            
            let sadderSwiperRec = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.makeSadder))
            sadderSwiperRec.direction = .down
            faceView.addGestureRecognizer(sadderSwiperRec)
            updateUI()
        }
    }
    
    @IBAction func changeBrow(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .changed,.ended:
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

    @IBAction func toggleEye(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
        switch expression.eyes {
        case .open:
            expression.eyes = .closed
        case .closed:
            expression.eyes = .open
        case .squinting:
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
    fileprivate var mouthCurvs = [FacialExpression.Mouth.frown:-1.0, FacialExpression.Mouth.smirk:-0.5, FacialExpression.Mouth.neutural:0.0, FacialExpression.Mouth.grin:0.5, FacialExpression.Mouth.smile: 1.0]
    
    fileprivate var eyeBrowTilts = [FacialExpression.EyeBrows.furrowed:CGFloat(-0.5),FacialExpression.EyeBrows.relaxed:CGFloat(0.5),FacialExpression.EyeBrows.normal:CGFloat(0.0)]
    
    // note updateUI might be called before faceView is set e.g prepareSegue, so need to do nil check here
    fileprivate func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .closed:
                faceView.eyeClosed = true
            case .open:
                faceView.eyeClosed = false
            case .squinting:
                faceView.eyeClosed = true
            }
            
            faceView.mouthCur = mouthCurvs[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
}

