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
        DispatchQueue.main.async {
            
            self.scene.stopBackgroundSound()
            
            self.scene.shakeScene(duration: 1.5) {
                self.scene.gameLayer?.playSound()
                self.scene.gameLayer?.startGameOverEffect(finished: nil)
                self.scene.backgroundLayer?.startGameOverEffect(finished: nil)
                self.scene.hudLayer?.startGameOverEffect()
            }
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
