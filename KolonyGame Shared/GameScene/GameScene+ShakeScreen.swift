//
//  GameLayer+ShakeScreen.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 13/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit

extension GameScene {
    func shakeCamera (layer: SKNode, duration: Float) -> SKAction {
        let amplitudeX : Float = 10
        let amplitudeY : Float = 6
        let numberOfShakes = duration / 0.04
        
        var actions = [SKAction]()
        
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
            shakeAction.timingMode = SKActionTimingMode.easeOut
            actions.append(shakeAction)
            actions.append(shakeAction.reversed())
        }
        let actionSeq = SKAction.sequence(actions)
        return actionSeq
    }
}
