//
//  BreakState.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 26/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import GameplayKit
import SpriteKit

class BreakState: GKState {
    unowned let blackHole : BlackHoleEntity
    
    init(blackHole: BlackHoleEntity) {
        self.blackHole = blackHole
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        self.blackHole.rotationComponent?.breakRotation(angle: CGFloat.pi/2, callback: {
            self.blackHole.rotationComponent?.clockWise = !(self.blackHole.rotationComponent?.clockWise)!
            self.blackHole.stateMachine.enter(RotatingState.self)
        })
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if(self.blackHole.stateMachine.currentState == self){
            return stateClass is RotatingState.Type
        }
        return false
    }
    
    
}
