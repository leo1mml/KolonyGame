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
    
    var property: PlanetProperties?
    
    init(property: PlanetProperties, size: CGSize) {
        super.init()
        
        self.property = property
        
        let texture = property.texture
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.physicsBodyComponent = PhysicBodyComponent(circleOfRadius: size.height/2, contactTestBitMask: PhysicsCategory.Rocket, collisionBitMask: PhysicsCategory.Rocket, physicCategory: PhysicsCategory.Planet, friction: 0.0, linearDamping: 0.0, restitution: 0.0)
        self.spriteComponent?.node.physicsBody = self.physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = property.type
        self.spriteComponent?.node.physicsBody?.isDynamic = false
        
        self.rotationComponent = RotationComponent(entity: self)
        self.animate()
        
        self.spriteComponent?.node.zPosition = 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // obs: o angulo 0 fica a esquerda.
    func addFlag(contactPoint: CGPoint){
        
        let flag = SKSpriteNode(texture: SKTexture(imageNamed: "flag"+(property?.type)!))
        flag.zPosition = (self.spriteComponent?.node.zPosition)! + 1
        flag.size = CGSize(width: (spriteComponent?.node.size.height)!/6, height: (spriteComponent?.node.size.height)!/4)
        
        // angulo em radianos
        let radian = atan2(contactPoint.y, contactPoint.x)
        
        flag.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        // rotaciona a bandeira
        flag.zRotation = radian - CGFloat(Double.pi / 2)
        
        //calculando a posição para inserir a bandeira
        flag.position = contactPoint
        
        self.spriteComponent?.node.addChild(flag)
        
        flag.run((property?.flagAction)!){
            flag.removeFromParent()
        }
        
    }
    
    func animate(){
        
        var textures = [SKTexture]()
        
        for i in 0...119 {
            let name = "planet"+(property?.type)!+"_\(i)"
            textures.append(SKTexture(imageNamed: name))
        }
        
        let rotate = SKAction.animate(with: textures, timePerFrame: 0.05)
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
