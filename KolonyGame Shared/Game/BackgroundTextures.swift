//
//  BackgroundTextures.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 17/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit

enum BackgroundTextures {
    
    case star
    case littleStar
    
    private static let allValues = [star, littleStar]
    
    var texture: SKTexture {
        switch self {
        case .star:
            return SKTexture(imageNamed: "stardefault")
        case .littleStar:
            return SKTexture(imageNamed: "starbg")
        }
    }
}
