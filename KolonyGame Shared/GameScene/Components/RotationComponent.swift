//
//  RotationComponent.swift
//  KolonyGame iOS
//
//  Created by Augusto on 13/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class RotationComponent: GKComponent {

    let spriteComponent: SpriteComponent
    
    init(entity: GKEntity) {
        
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    func startRotate() {
        let spriteNode = spriteComponent.node
        
        let rotateAction = SKAction.rotate(toAngle: CGFloat(Double.pi / 4), duration: 0)
        
        let rotateForever = SKAction.repeatForever(rotateAction)
        
        spriteNode.run(rotateForever)
        
    }
    
    func stopRotate(){
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
