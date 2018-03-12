//
//  GameScene.swift
//  KolonyGame Shared
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var initialState: AnyClass
    
    init(size: CGSize, stateClass: AnyClass) {
        initialState = stateClass
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        stateMachine.enter(initialState)
    }
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        PlayingState(scene: self)
        ])
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

