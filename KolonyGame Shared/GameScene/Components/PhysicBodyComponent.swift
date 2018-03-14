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

    init(node: SKSpriteNode, physicCategory: UInt32 ) {
        
        switch physicCategory {
        case PhysicsCategory.Planet:
            
            physicBody = SKPhysicsBody(circleOfRadius: max(node.size.width / 2.8,
                                                           node.size.height / 2.8))
            
            break
        case PhysicsCategory.Rocket:
            
            physicBody = SKPhysicsBody(circleOfRadius: max(node.size.width / 2,
                                                           node.size.height / 2))
            
            break
        case PhysicsCategory.BlackHole:
            
            physicBody = SKPhysicsBody(circleOfRadius: max(node.size.width / 2,
                                                           node.size.height / 2))
            
            break
        case PhysicsCategory.Obstacle:
            
            physicBody = SKPhysicsBody(circleOfRadius: max(node.size.width / 2,
                                                           node.size.height / 2))
            
            break
        default:
            physicBody = SKPhysicsBody()
            break
        }
        
        physicBody.categoryBitMask = physicCategory
        physicBody.collisionBitMask = 0
        physicBody.affectedByGravity = false
        
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
