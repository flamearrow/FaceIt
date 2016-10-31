//
//  BlinkFaceViewController.swift
//  FaceIt
//
//  Created by Chen Cen on 10/30/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class BlinkFaceViewController: FaceViewController {
    var blinking: Bool = false {
        didSet {
            startBlink(timer: Timer())
        }
    }
    
    private struct BlinkRate {
        static let closeDuration = 1.0
        static let openDuration = 0.2
    }
    
    func startBlink(timer:Timer) {
        if blinking {
            faceView.eyeClosed = false
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: BlinkRate.closeDuration, repeats: false, block: endBlink)
            } else {
                Timer.scheduledTimer(
                    timeInterval: BlinkRate.closeDuration,
                    target: self,
                    selector: #selector(BlinkFaceViewController.endBlink(timer:)),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    
    func endBlink(timer:Timer) {
        if blinking {
            faceView.eyeClosed = true
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false, block: startBlink)
            } else {
                Timer.scheduledTimer(
                    timeInterval: BlinkRate.closeDuration,
                    target: self,
                    selector: #selector(BlinkFaceViewController.startBlink(timer:)),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blinking = false
    }
}
