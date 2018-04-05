//
//  PlanetEntity.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlanetEntity: GKEntity {
    
    var spriteComponent : SpriteComponent?
    var physicsBodyComponent: PhysicBodyComponent?
    var rotationComponent: RotationComponent?
    
    init(imageName: String, size: CGSize) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.physicsBodyComponent = PhysicBodyComponent(circleOfRadius: size.height/2.8, contactTestBitMask: PhysicsCategory.RedRocket | PhysicsCategory.BlackHole, collisionBitMask: PhysicsCategory.RedRocket, physicCategory: PhysicsCategory.RedPlanet, friction: 0.0, linearDamping: 0.0, restitution: 0.0)
        self.spriteComponent?.node.physicsBody = self.physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = "planet"
        
        self.rotationComponent = RotationComponent(entity: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRotating(angle: Double, duration: Double) {
        let rotateAction = SKAction.rotate(byAngle: CGFloat(angle), duration: duration)
        let repeatForever = SKAction.repeatForever(rotateAction)
        if let sprite = self.component(ofType: SpriteComponent.self)?.node {
            sprite.run(repeatForever)
        }
    }
    
}
