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
}

