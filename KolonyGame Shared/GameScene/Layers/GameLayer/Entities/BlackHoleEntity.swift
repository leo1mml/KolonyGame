//
//  BlackHoleEntity.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 12/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class BlackHoleEntity: GKEntity {
    
    var spriteComponent : SpriteComponent?
    var planet1 : PlanetEntity?
    var rotationComponent: RotationComponent?
    var physicsBodyComponent: PhysicBodyComponent?
    
    init(imageName: String, size: CGSize) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.rotationComponent = RotationComponent(entity: self)
        self.rotationComponent?.startRotate(angle: CGFloat.pi * 2, duration: 3)
        
        self.physicsBodyComponent = PhysicBodyComponent(node: (spriteComponent?.node)!, physicCategory: PhysicsCategory.BlackHole)
        self.spriteComponent?.node.physicsBody = physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = "blackHole"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
