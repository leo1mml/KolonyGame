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
    var node: SKSpriteNode
    
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
    
    func alphaAction (alphaValue: CGFloat, duration: TimeInterval) -> SKAction {
        
        let downAlpha = SKAction.fadeAlpha(by: alphaValue, duration: duration)
        
        let defaultAlpha = SKAction.fadeAlpha(by: 1, duration: duration)
        
        let sequenceFade = SKAction.sequence([downAlpha, defaultAlpha])
        
        let repeatForever = SKAction.repeatForever(sequenceFade)
        
        return repeatForever
    }
    

}

