//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Chen Cen on 9/27/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import Foundation

// model
struct FacialExpression {
    // rawValue will be assigned from 0 for int typed enums
    // rawvalue will be assigned as the param name for string typed enums
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    enum EyeBrows: Int {
        case relaxed
        case normal
        case furrowed
        // try to switch to another enum value, if there's no matching value, return the extreme(Relaxed or Furrowed)
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .relaxed
        } 

        func moreFurrowedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .furrowed
        }
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutural
        case grin
        case smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
}
