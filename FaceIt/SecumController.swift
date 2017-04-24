//
//  SecumController.swift
//  FaceIt
//
//  Created by Chen Cen on 4/23/17.
//  Copyright © 2017 Chen Cen. All rights reserved.
//

import UIKit

// controller
// controls View and Model, take value from model and reflect it on UI when value changes
class SecumController: UIViewController {
    
    @IBOutlet weak var counter: SecumCounter!
    
    @IBAction func debug(_ sender: Any) {
//        counter.text = "bglm";
        counter.setLabelText("bglm");
    }
    
    @IBAction func bounce(_ sender: Any) {
        counter.bounce();
    }
    
    @IBAction func pulse(_ sender: Any) {
        counter.pulse();
    }

    @IBAction func shake(_ sender: Any) {
        counter.shake();
    }

    @IBAction func explode(_ sender: Any) {
        counter.explode();
    }
    
    @IBAction func clear(_ sender: Any) {
        counter.clear();
    }
    
}
