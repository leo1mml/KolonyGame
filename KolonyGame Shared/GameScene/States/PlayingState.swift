//
//  PlayingState.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        scene.playBackgroundSound()
        
        if previousState is GameOverState {
            scene.hudLayer?.resetupHudLayer()
            scene.gameLayer?.resetupGameLayer()
            scene.gameLayer?.blackHole?.resetupPlanets()
        } else {
            scene.backgroundLayer?.setupLayer()
            scene.gameLayer?.configureLayer()
            scene.hudLayer?.setupLayer()
        }
        
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
