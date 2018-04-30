//
//  NoLaunch.swift
//  KolonyGame iOS
//
//  Created by Augusto on 11/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class QueueState: GKState {
    unowned let rocket: RocketEntity
    
    init(rocket: GKEntity) {
        self.rocket = rocket as! RocketEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {

        rocket.flame.removeFromParent()
        rocket.IdleFlame()
        rocket.spriteComponent?.node.zRotation = 0.0
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is IdleState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
