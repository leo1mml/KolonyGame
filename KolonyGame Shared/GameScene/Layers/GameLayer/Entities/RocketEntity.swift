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
    let fogo = SKSpriteNode(texture: SKTexture(imageNamed: "rocketBlueFire1"))
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        QueueState(rocket: self),
        IdleState(rocket: self),
        LaunchState(rocket: self)
        ])
    
    init(size: CGSize, typeColor: RocketType) {
        
        super.init()
        
        let texture = typeColor.texture
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.physicsBodyComponent = PhysicBodyComponent(circleOfRadius: size.height/2, contactTestBitMask: PhysicsCategory.BlackHole | PhysicsCategory.Planet, collisionBitMask: PhysicsCategory.Planet, physicCategory: PhysicsCategory.Rocket, friction: 0.0, linearDamping: 0.0, restitution: 0.0)
        self.spriteComponent?.node.physicsBody = self.physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = typeColor.type
        
        self.propulsionAnimation()
        
    }
    
    func propulsionAnimation(){
        let node = self.spriteComponent?.node
        
        fogo.position = CGPoint(x: 0, y: -(node?.size.height)!)
        
        fogo.size =  CGSize(width: (node?.size.width)!/2, height: (node?.size.height)!)
        
        let textures = [SKTexture(imageNamed: "rocketBlueFire1"), SKTexture(imageNamed: "rocketBlueFire2")]
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.2)
        
        let repeatForever = SKAction.repeatForever(animation)
        
        fogo.run(repeatForever)
        
        self.spriteComponent?.node.addChild(fogo)
    }
    
    func launch(velocity: CGVector) {
        self.spriteComponent?.node.physicsBody?.velocity = velocity
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
