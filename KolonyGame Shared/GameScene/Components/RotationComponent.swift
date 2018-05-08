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
    var rotationDuration: TimeInterval = 4
    
    var clockWise = true
    
    init(entity: GKEntity) {
        
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    func breakRotation(angle: CGFloat, callback: @escaping () -> ()){
        let angle = self.clockWise ? angle : -angle
        let breakAction = SKAction.rotate(byAngle: angle * (1/3), duration: rotationDuration * 0.25)
        breakAction.timingMode = .easeOut
        self.spriteComponent.node.run(breakAction){
            callback()
        }
    }
    
    func rotate() {
        if(self.clockWise){
            runRotationAction(angle: CGFloat.pi * 2)
        }else {
            runRotationAction(angle: -CGFloat.pi * 2)
        }
    }
    
    func runRotationAction(angle: CGFloat) {
        self.spriteComponent.node.removeAction(forKey: "repeatRotation")
        let rotation = SKAction.rotate(byAngle: angle, duration: rotationDuration)
        let repeatRotation = SKAction.repeatForever(rotation)
        self.spriteComponent.node.run(repeatRotation, withKey: "repeatRotation")
    }
    
    func stopRotate(){
        let spriteNode = spriteComponent.node
        spriteNode.removeAction(forKey: "repeatRotation")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
