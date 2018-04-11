//
//  ToLaunch.swift
//  KolonyGame iOS
//
//  Created by Augusto on 11/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class IdleState: GKState {
    unowned let rocket: RocketEntity
    
    init(rocket: GKEntity) {
        self.rocket = rocket as! RocketEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        self.rocket.moveIdle()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LaunchState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
