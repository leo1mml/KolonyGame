//
//  LittleStar.swift
//  KolonyGame
//
//  Created by Isaias Fernandes on 05/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class LittleStar : BackgroundBasicEntity {
    
    override init(imageName: String, size: CGSize) {
        super.init(imageName: imageName, size: size)
    }
    
    override init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
