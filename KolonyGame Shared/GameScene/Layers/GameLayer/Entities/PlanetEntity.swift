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
    
    init(property: PlanetProperties, size: CGSize) {
        super.init()
        
        let texture = property.texture
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.physicsBodyComponent = PhysicBodyComponent(circleOfRadius: size.height/2, contactTestBitMask: PhysicsCategory.Rocket, collisionBitMask: PhysicsCategory.Rocket, physicCategory: PhysicsCategory.Planet, friction: 0.0, linearDamping: 0.0, restitution: 0.0)
        self.spriteComponent?.node.physicsBody = self.physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = property.type
        self.spriteComponent?.node.physicsBody?.isDynamic = false
        
        self.rotationComponent = RotationComponent(entity: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addFlag(flag: SKSpriteNode){
        flag.zPosition = (self.spriteComponent?.node.zPosition)! + 1
        flag.size = CGSize(width: (spriteComponent?.node.size.height)!/6, height: (spriteComponent?.node.size.height)!/4)
        self.spriteComponent?.node.addChild(flag)


        let random = NumbersUtil.randomDouble(min: 0, max: 2)
        let radius = Double.pi * random
        let degreus = CGFloat(radius * 180 / Double.pi)
        flag.position = CGPoint(x: (self.spriteComponent?.node.size.height)!/2 * cos(degreus), y: (self.spriteComponent?.node.size.height)!/2 * sin(degreus))
            
        
        

    }
    
    func animate(){
        
        var textures = [SKTexture]()
        
        for i in 1...40 {
            textures.append(SKTexture(imageNamed: "nome\(i)"))
        }
        
        SKAction.animate(with: textures, timePerFrame: 60)
    }
    
    func startRotating(angle: Double, duration: Double) {
        let rotateAction = SKAction.rotate(byAngle: CGFloat(angle), duration: duration)
        let repeatForever = SKAction.repeatForever(rotateAction)
        if let sprite = self.component(ofType: SpriteComponent.self)?.node {
            sprite.run(repeatForever)
        }
    }
    
}
