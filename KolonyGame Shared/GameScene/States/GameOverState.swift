//
//  GameOverState.swift
//  KolonyGame iOS
//
//  Created by Augusto on 12/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.shakeScene(duration: 2)
        if let backgroundLayer = self.scene.backgroundLayer {
            if let manager = backgroundLayer.entityManager {
                for item in manager.entities {
                    if let spriteComponent = item.component(ofType: SpriteComponent.self) {
                        spriteComponent.node.position = (self.scene.gameLayer?.blackHolePosition())!
                    }
                }
            }
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
