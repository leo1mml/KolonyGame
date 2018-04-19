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
    var size: CGSize?
    var layers : [SKSpriteNode] = []
    
    init(size: CGSize) {
        super.init()
        self.spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "bgblackhole"), size: size)
        self.addComponent(self.spriteComponent!)
        self.size = size
        createLayers()
        self.rotationComponent = RotationComponent(entity: self)
        self.rotationComponent?.clockWise = false
        
        self.physicsBodyComponent = PhysicBodyComponent(circleOfRadius: size.height/2.8, contactTestBitMask: PhysicsCategory.Rocket, collisionBitMask: PhysicsCategory.BlackHole, physicCategory: PhysicsCategory.BlackHole, friction: 0.0, linearDamping: 0.0, restitution: 0.0)
        self.spriteComponent?.node.physicsBody = physicsBodyComponent?.physicBody
        
        self.spriteComponent?.node.name = "blackHole"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLayers() {
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)! * 0.51, height: (self.size?.height)! * 0.51), zPosition: 8, texture: SKTexture(imageNamed: "blackhole1")))
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)! * 0.55, height: (self.size?.height)! * 0.55), zPosition: 7, texture: SKTexture(imageNamed: "blackhole2")))//40
        layers[1].alpha = 0.6
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)! * 0.6, height: (self.size?.height)! * 0.6), zPosition: 6, texture: SKTexture(imageNamed: "blackhole3")))//30
        layers[2].alpha = 0.7
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)! * 0.65, height: (self.size?.height)! * 0.65), zPosition: 5, texture: SKTexture(imageNamed: "blackhole4")))//20
        layers[3].alpha = 0.8
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)! * 0.7, height: (self.size?.height)! * 0.7), zPosition: 4, texture: SKTexture(imageNamed: "blackhole5")))//30
        layers[4].alpha = 0.7
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)! * 0.8, height: (self.size?.height)! * 0.8), zPosition: 3, texture: SKTexture(imageNamed: "blackhole6")))//20
        layers[5].alpha = 0.8
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)! * 0.9, height: (self.size?.height)! * 0.9), zPosition: 2, texture: SKTexture(imageNamed: "blackhole7")))//10
        layers[6].alpha = 0.9
        self.layers.append(createLayer(size: CGSize(width: (self.size?.width)!, height: (self.size?.height)!), zPosition: 2, texture: SKTexture(imageNamed: "blackhole8")))//10
        layers[6].alpha = 0.95
        if let sprite = self.component(ofType: SpriteComponent.self) {
            self.layers.append(sprite.node)
        }
        pulseAllLayers()
    }
    
    func pulseAllLayers() {
        pulseLayer(duration: 0.4, sizeMultiplier1: 1.04, sizeMultiplier2: 0.96, sprite: self.layers[1])
        pulseLayer(duration: 0.5, sizeMultiplier1: 1.015, sizeMultiplier2: 0.8, sprite: self.layers[2])
        pulseLayer(duration: 0.7, sizeMultiplier1: 1.02, sizeMultiplier2: 0.8, sprite: self.layers[3])
        pulseLayer(duration: 2, sizeMultiplier1: 1.025, sizeMultiplier2: 0.95, sprite: self.layers[4])
        pulseLayer(duration: 2.4, sizeMultiplier1: 1.1, sizeMultiplier2: 1, sprite: self.layers[5])
        pulseLayer(duration: 2.75, sizeMultiplier1: 1.2, sizeMultiplier2: 1.1, sprite: self.layers[6])
        pulseLayer(duration: 3, sizeMultiplier1: 1.3, sizeMultiplier2: 1.1, sprite: self.layers[7])
    }
    
    func pulseLayer(duration: TimeInterval, sizeMultiplier1: CGFloat, sizeMultiplier2: CGFloat, sprite: SKSpriteNode) {
        let pulseAction = SKAction.scale(to: sizeMultiplier1, duration: duration)
        let backToNormal = SKAction.scale(to: sizeMultiplier2, duration: duration)
        let sequence = SKAction.sequence([pulseAction, backToNormal])
        let repeatForever = SKAction.repeatForever(sequence)
        sprite.run(repeatForever)
    }
    
    func createLayer(size: CGSize, zPosition: CGFloat, texture: SKTexture) -> SKSpriteNode {
        let layerSprite = SKSpriteNode(texture: texture)
        layerSprite.size = size
        layerSprite.zPosition = zPosition
        if let containerSprite = self.component(ofType: SpriteComponent.self) {
            containerSprite.node.zPosition = -8
            containerSprite.node.addChild(layerSprite)
        }
        return layerSprite
    }
    
    func moveOtherWay() {
        self.rotationComponent?.clockWise = !(self.rotationComponent?.clockWise)!
    }
}

