//
//  TranslationComponent.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 14/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class TranslationComponent : GKComponent {
    let spriteComponent: SpriteComponent
    
    init(entity: GKEntity) {
        
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    func startRotate(angle: CGFloat, duration: TimeInterval) {
        let spriteNode = spriteComponent.node
        
        // CGFloat.pi * 2
        
        let oneRevolution:SKAction = SKAction.rotate(byAngle: angle, duration: duration)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        spriteNode.anchorPoint = CGPoint.zero
        spriteNode.run(repeatRotation, withKey: "rotation")
        
    }
    
    func stopRotate(){
        let spriteNode = spriteComponent.node
        
        spriteNode.removeAction(forKey: "rotation")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
