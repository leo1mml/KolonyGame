//
//  PlayingState.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class RetryState: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.backgroundLayer?.setup((scene.backgroundLayer?.stars!)!)
        scene.backgroundLayer?.setup(littleStars: (scene.backgroundLayer?.littleStars!)!)
            scene.hudLayer?.resetupHudLayer()
            scene.gameLayer?.resetupGameLayer()
        scene.gameLayer?.blackHole?.resetupPlanets {
            self.scene.stateMachine.enter(PlayingState.self)
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
