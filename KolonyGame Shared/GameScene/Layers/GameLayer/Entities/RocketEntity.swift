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
    var flame: SKSpriteNode!
    var rocketType: RocketType?
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        QueueState(rocket: self),
        IdleState(rocket: self),
        LaunchState(rocket: self)
        ])
    
    init(size: CGSize, rocketType: RocketType) {
        
        super.init()
        
        self.rocketType = rocketType
        
        let texture = rocketType.texture
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.physicsBodyComponent = PhysicBodyComponent(circleOfRadius: size.height/2, contactTestBitMask: PhysicsCategory.BlackHole | PhysicsCategory.Planet, collisionBitMask: PhysicsCategory.Planet, physicCategory: PhysicsCategory.Rocket, friction: 0.0, linearDamping: 0.0, restitution: 0.0)
        self.spriteComponent?.node.physicsBody = self.physicsBodyComponent?.physicBody
        self.spriteComponent?.node.zPosition = 70
        
        self.spriteComponent?.node.name = rocketType.type
        
        IdleFlame()
    }
    
    func setup(size: CGSize, rocketType: RocketType) {
        
        self.rocketType = rocketType
        let sprite = self.spriteComponent?.node
        sprite?.zPosition = 50
        sprite?.texture = rocketType.texture
        sprite?.name = rocketType.type
    }
    
    func launchFlame(){
        let node = self.spriteComponent?.node
        
        flame = SKSpriteNode()
        
        flame.zPosition = (node?.zPosition)! - 1
        
        flame.position = CGPoint(x: 0, y: -(node?.size.height)! * 0.96)
        
        flame.size = CGSize(width: (node?.size.width)!/2.3, height: (node?.size.height)!)
        
        let animation = SKAction.animate(with: (rocketType?.fire)!, timePerFrame: 0.2)
        
        let repeatForever = SKAction.repeatForever(animation)
        
        flame.run(repeatForever)
        
        self.spriteComponent?.node.addChild(flame)
    }
    
    func IdleFlame(){
        let node = self.spriteComponent?.node
        
        flame = SKSpriteNode()
        
        flame.zPosition = (node?.zPosition)! - 1
        
        flame.position = CGPoint(x: 0, y: -(node?.size.height)! * 0.61)
        
        flame.size = CGSize(width: (node?.size.width)! * 0.3712, height: (node?.size.height)! * 0.2266)
        
        let animation = SKAction.animate(with: (rocketType?.idleFire)!, timePerFrame: 0.2)
        
        let repeatForever = SKAction.repeatForever(animation)
        
        flame.run(repeatForever)
        
        self.spriteComponent?.node.addChild(flame)
    }
    
    func resizeFlame(size: CGSize) {
        flame.position = CGPoint(x: 0, y: -size.height * 0.61)
        
        flame.size = CGSize(width: size.width * 0.3712, height: size.height * 0.2266)
        
    }
    
    func launch(velocity: CGVector) {
        self.spriteComponent?.node.physicsBody?.velocity = velocity
        launchSound()
    }
    
    func launchSound() {
        let audioNode = SKAudioNode(fileNamed: "launchSound")
        
        let wait = SKAction.wait(forDuration: 2)
        let remove = SKAction.run {
            audioNode.removeFromParent()
        }
        
        audioNode.run(SKAction.changeVolume(by: 0.5, duration: 0.1))
        
        let action = SKAction.sequence([wait, remove])
        audioNode.run(action)
        
        self.spriteComponent?.node.addChild(audioNode)
    }
    
    func moveIdle() {
        if let sprite = self.component(ofType: SpriteComponent.self)?.node {
            let moveUp = SKAction.moveTo(y: sprite.position.y + (sprite.size.height/4), duration: 0.8)
            let moveDown = SKAction.moveTo(y: sprite.position.y - (sprite.size.height/4), duration: 0.8)
            let sequence = SKAction.sequence([moveUp, moveDown])
            let repeatForever = SKAction.repeatForever(sequence)
            sprite.run(repeatForever)
        }
    }
    
    func stop() {
        self.spriteComponent?.node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
