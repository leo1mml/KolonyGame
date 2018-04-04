//
//  RocketEntity.swift
//  KolonyGame
//
//  Created by Augusto on 14/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class RocketEntity: GKEntity {
    
    var spriteComponent : SpriteComponent?
    var physicsBodyComponent: PhysicBodyComponent?
    
    init(imageName: String, size: CGSize) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.physicsBodyComponent = PhysicBodyComponent(node: (spriteComponent?.node)!, physicCategory: PhysicsCategory.Rocket)
        self.spriteComponent?.node.physicsBody = self.physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = "rocket"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
