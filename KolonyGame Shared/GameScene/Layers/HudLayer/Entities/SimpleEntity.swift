//
//  ScoreEntity.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 09/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import GameplayKit
import SpriteKit


class SimpleEntity : GKEntity {
    var spriteComponent: SpriteComponent?
    
    init(imageName: String, size: CGSize) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        if let component = self.spriteComponent {
            self.addComponent(component)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
