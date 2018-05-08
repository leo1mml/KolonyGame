//
//  PhysicBodyComponent.swift
//  KolonyGame iOS
//
//  Created by Augusto on 13/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import Foundation
import GameplayKit

class PhysicBodyComponent: GKComponent {
    
    var physicBody: SKPhysicsBody
    
    init(circleOfRadius: CGFloat, contactTestBitMask: UInt32, collisionBitMask: UInt32, physicCategory: UInt32, friction: CGFloat, linearDamping: CGFloat, restitution: CGFloat) {
        
        physicBody = SKPhysicsBody(circleOfRadius: circleOfRadius)
        
        physicBody.contactTestBitMask = contactTestBitMask
        
        physicBody.collisionBitMask = collisionBitMask
        
        physicBody.friction = friction
        
        physicBody.linearDamping = linearDamping
        
        physicBody.restitution = restitution
        
        physicBody.categoryBitMask = physicCategory
        
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
