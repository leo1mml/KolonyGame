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
    let fogo = SKSpriteNode(texture: SKTexture())
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
        
        self.spriteComponent?.node.name = rocketType.type
        
        self.IdleFlame()
        
    }
    
    func launchFlame(){
        let node = self.spriteComponent?.node
        
        fogo.zPosition = (node?.zPosition)! - 1
        
        fogo.position = CGPoint(x: 0, y: -(node?.size.height)! * 0.96)
        
        fogo.size =  CGSize(width: (node?.size.width)!/2.3, height: (node?.size.height)!)
        
        let animation = SKAction.animate(with: (rocketType?.fire)!, timePerFrame: 0.2)
        
        let repeatForever = SKAction.repeatForever(animation)
        
        fogo.run(repeatForever)
        
        self.spriteComponent?.node.addChild(fogo)
    }
    
    func IdleFlame(){
        let node = self.spriteComponent?.node
        
        fogo.zPosition = (node?.zPosition)! - 1
        
        fogo.position = CGPoint(x: 0, y: -(node?.size.height)! * 0.715)
        
        fogo.size =  CGSize(width: (node?.size.width)!/2.3, height: (node?.size.height)!/2)
        
        let animation = SKAction.animate(with: (rocketType?.idleFire)!, timePerFrame: 0.2)
        
        let repeatForever = SKAction.repeatForever(animation)
        
        fogo.run(repeatForever)
        
        self.spriteComponent?.node.addChild(fogo)
    }
    
    func launch(velocity: CGVector) {
        self.spriteComponent?.node.physicsBody?.velocity = velocity
    }
    
    func stop() {
        self.spriteComponent?.node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
