//
//  NumbersUtil.swift
//  KolonyGame
//
//  Created by Isaias Fernandes on 05/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import Foundation
import SpriteKit

class NumbersUtil {
    
    static func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    static func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    
    static func randomDouble(min: Double, max: Double) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
}
