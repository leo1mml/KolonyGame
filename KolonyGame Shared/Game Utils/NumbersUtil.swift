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
    
}
