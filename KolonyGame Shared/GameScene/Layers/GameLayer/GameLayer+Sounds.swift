//
//  GameLayer+Sounds.swift
//  KolonyGame
//
//  Created by Augusto on 20/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit

extension GameLayer {
    
    func jackpotSound() {
        let audioNode = SKAudioNode(fileNamed: "point")
        
        let wait = SKAction.wait(forDuration: 2)
        let remove = SKAction.run {
            audioNode.removeFromParent()
        }
        
        let action = SKAction.sequence([wait, remove])
        audioNode.run(action)
        
        self.addChild(audioNode)
    }
    
    func missSound() {
        let audioNode = SKAudioNode(fileNamed: "explosion")
        
        let wait = SKAction.wait(forDuration: 2)
        let remove = SKAction.run {
            audioNode.removeFromParent()
        }
        
        let action = SKAction.sequence([wait, remove])
        audioNode.run(action)
        
        self.addChild(audioNode)
    }
    
}
