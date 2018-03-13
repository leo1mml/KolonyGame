//
//  PhysicBodyComponent.swift
//  KolonyGame iOS
//
//  Created by Augusto on 13/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import Foundation
import GameplayKit

// 2
class PhysicBodyComponent: GKComponent {
    
    // 3
    let physicBody: SKPhysicsBody
    
    // 4
    init(size: CGSize) {
        
        physicBody = SKPhysicsBody(circleOfRadius: max(size.width / 2.7,
                                                       size.height / 2.7))
        super.init()
    }
    
    // 5
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
