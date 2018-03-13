//
//  BackgroundEntity.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 12/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//


import SpriteKit
import GameplayKit

class BackgroundEntity : GKEntity {
    
    var spriteComponent : SpriteComponent?
    
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        self.spriteComponent = SpriteComponent(texture: texture)
        self.addComponent(self.spriteComponent!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
