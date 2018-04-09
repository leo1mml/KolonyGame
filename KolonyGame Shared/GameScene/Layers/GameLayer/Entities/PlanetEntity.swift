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

        let aleatorio = NumbersUtil.randomDouble(min: 0, max: 2)
        let radianos = Double.pi * aleatorio
        let graus = CGFloat(Double(radianos * 180) / Double.pi)
        flag.zRotation = -graus
        
        flag.position = CGPoint(x: (self.spriteComponent?.node.size.height)!/2 * sin(graus) , y: ((self.spriteComponent?.node.size.height)!/2 + flag.size.height/2) * cos(graus))

         self.spriteComponent?.node.addChild(flag)
    }
    
    func animate(){
        
        var textures = [SKTexture]()
        
        for i in 72...98 {
            textures.append(SKTexture(imageNamed: "Ativo \(i)"))
        }
        
        let rotate = SKAction.animate(with: textures, timePerFrame: 0.06)
        let repeatForever = SKAction.repeatForever(rotate)
        self.spriteComponent?.node.run(repeatForever)
    }
    
    func startRotating(angle: Double, duration: Double) {
        let rotateAction = SKAction.rotate(byAngle: CGFloat(angle), duration: duration)
        let repeatForever = SKAction.repeatForever(rotateAction)
        if let sprite = self.component(ofType: SpriteComponent.self)?.node {
            sprite.run(repeatForever)
        }
    }
    
}
