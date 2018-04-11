//
//  Launched.swift
//  KolonyGame iOS
//
//  Created by Augusto on 11/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class LaunchState: GKState {
    unowned let rocket: RocketEntity
    
    init(rocket: GKEntity) {
        self.rocket = rocket as! RocketEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        rocket.spriteComponent?.node.removeAllActions()
        rocket.launch(velocity: CGVector(dx: 0, dy: 400))
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is QueueState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
