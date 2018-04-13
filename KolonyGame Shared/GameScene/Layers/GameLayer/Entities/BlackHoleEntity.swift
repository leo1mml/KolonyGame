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
    
    init(size: CGSize) {
        super.init()
        self.spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "blackhole8"), size: size)
        self.addComponent(self.spriteComponent!)
        if let mainSprite = self.component(ofType: SpriteComponent.self) {
            mainSprite.node.zPosition = -8
            for index in (1...7).reversed() {
                let texture = SKTexture(imageNamed: "blackhole\(index)")
                let sprite = SKSpriteNode(texture: texture)
                sprite.size = CGSize(width: mainSprite.node.size.width * CGFloat(index/10), height: mainSprite.node.size.height * CGFloat(index/10))
                sprite.zPosition = CGFloat(-index)
                mainSprite.node.addChild(sprite)
            }
        }
        
        self.rotationComponent = RotationComponent(entity: self)
        self.rotationComponent?.startRotate(angle: CGFloat.pi * 2, duration: 10)
        
        self.physicsBodyComponent = PhysicBodyComponent(circleOfRadius: size.height/2.8, contactTestBitMask: PhysicsCategory.Rocket, collisionBitMask: PhysicsCategory.BlackHole, physicCategory: PhysicsCategory.BlackHole, friction: 0.0, linearDamping: 0.0, restitution: 0.0)
        self.spriteComponent?.node.physicsBody = physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = "blackHole"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

