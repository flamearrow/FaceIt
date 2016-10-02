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
        case Open
        case Closed
        case Squinting
    }
    
    enum EyeBrows: Int {
        case Relaxed
        case Normal
        case Furrowed
        // try to switch to another enum value, if there's no matching value, return the extreme(Relaxed or Furrowed)
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        } 

        func moreFurrowedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutural
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
}