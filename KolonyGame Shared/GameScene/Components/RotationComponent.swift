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
    var rotationDuration: TimeInterval = 4 {
        didSet {
            rotate()
        }
    }
    
    var clockWise = false {
        didSet {
            invertRotation()
        }
    }
    
    init(entity: GKEntity) {
        
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    func rotate() {
        if(self.clockWise){
            runRotationAction(angle: CGFloat.pi * 2)
        }else {
            runRotationAction(angle: -CGFloat.pi * 2)
        }
    }
    
    func runRotationAction(angle: CGFloat) {
        self.spriteComponent.node.removeAllActions()
        let rotation = SKAction.rotate(byAngle: angle, duration: rotationDuration)
        let repeatRotation = SKAction.repeatForever(rotation)
        self.spriteComponent.node.run(repeatRotation)
    }
    
    func invertRotation(){
        let angle = CGFloat.pi * 2
        self.spriteComponent.node.removeAllActions()
        if(self.clockWise){
            runInvertRotationAction(angle: -angle)
        }else {
            runInvertRotationAction(angle: angle)
        }
    }

    func runInvertRotationAction (angle: CGFloat) {
        self.spriteComponent.node.removeAllActions()
        let rotation = SKAction.rotate(byAngle: angle, duration: rotationDuration)
        let breakAction = SKAction.rotate(byAngle: -angle/2, duration: rotationDuration/1.5)
        breakAction.timingMode = .easeOut
        let repeatRotation = SKAction.repeatForever(rotation)
        let sequence = SKAction.sequence([breakAction, repeatRotation])
        self.spriteComponent.node.run(sequence)
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
