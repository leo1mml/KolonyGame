//
//  RotatingState.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 26/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import GameplayKit
import SpriteKit

class RotatingState: GKState {
    unowned let blackHole : BlackHoleEntity
    
    init(blackHole: BlackHoleEntity) {
        self.blackHole = blackHole
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        self.blackHole.rotationComponent?.rotate()
    }
    
    override func willExit(to nextState: GKState) {
        self.blackHole.spriteComponent?.node.removeAction(forKey: "repeatRotation")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BreakState.Type
    }
    
    
}
