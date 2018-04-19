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
  
    func addFlag(contactPoint: CGPoint){
        
        let flag = SKSpriteNode(texture: SKTexture(imageNamed: "flag"+(property?.type)!))
        flag.zPosition = (self.spriteComponent?.node.zPosition)! + 1
        flag.size = CGSize(width: (spriteComponent?.node.size.height)!/6, height: (spriteComponent?.node.size.height)!/4)
        
        // angulo em radianos
        let radian = atan2(contactPoint.y, contactPoint.x)
        
        // alterando ponto de ancoragem
        flag.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        // rotacionando a bandeira
        flag.zRotation = radian - CGFloat(Double.pi / 2)
        
        // inserindo a bandeira na posição da colisão
        flag.position = contactPoint
        
        self.spriteComponent?.node.addChild(flag)
        
        flag.run((property?.flagAction)!){
            flag.removeFromParent()
        }
        
    }
    
    func addFireworks(contactPoint: CGPoint) {
        
        let node = self.spriteComponent?.node
        
        let firework = SKSpriteNode(texture: SKTexture(imageNamed: "fireworks_0"))
        firework.zPosition = (node?.zPosition)! + 2
        firework.size = CGSize(width: (node?.size)!.width * 1.2, height: (node?.size)!.height  * 1.2)
        firework.position = contactPoint
        
        var textures = [SKTexture]()
        
        for i in 0...16 {
            let name = "fireworks_\(i)"
            textures.append(SKTexture(imageNamed: name))
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.06)
        
        node?.addChild(firework)
        
        firework.run(animation){
            firework.removeFromParent()
        }
        
    }
    
    func addSmoke(contactPoint: CGPoint) {
        var smoke: SKEmitterNode?
        
        guard let emitter = SKEmitterNode(fileNamed: "Smoke.sks") else {
            return
        }
        
        emitter.name = "smoke"
        emitter.targetNode = self.spriteComponent?.node
        smoke = emitter
        smoke?.position = contactPoint
        
        let add = SKAction.run {
            self.spriteComponent?.node.addChild(smoke!)
        }
        
        let wait = SKAction.wait(forDuration: 3)
        
        let remove = SKAction.run {
            smoke?.removeFromParent()
        }
        
        let sequence = SKAction.sequence([add, wait, remove])
        
        self.spriteComponent?.node.run(sequence)
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
