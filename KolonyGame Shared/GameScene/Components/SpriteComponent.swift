//
//  SpriteComponent.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//
import SpriteKit
import GameplayKit

// 2
class SpriteComponent: GKComponent {
    
    // 3
    let node: SKSpriteNode
    
    // 4
    init(texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: .white, size: size)
        super.init()
    }
    
    // 5
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scaleAction (timeBetweenScale: TimeInterval, scaleMultiplier: CGFloat) -> SKAction {
        
        let scaleUp = SKAction.scale(to: scaleMultiplier, duration: timeBetweenScale)
        let scaleDown = SKAction.scale(to: 1, duration: timeBetweenScale)
        
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatForever = SKAction.repeatForever(sequence)
        return repeatForever
        
        
    }
    
}

