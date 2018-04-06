//
//  GameLayer+Contact.swift
//  KolonyGame
//
//  Created by Augusto on 05/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit

extension GameLayer {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let tupla = (contact.bodyA.node?.name, contact.bodyB.node?.name)
        
        switch tupla {
        case ("red", "red"):
            print("RED")
            break
        case ("blue", "blue"):
            print("BLUE")
            break
        case ("green", "green"):
            print("GREEN")
            break
        case ("yellow", "yellow"):
            print("YELLOW")
            break
        default:
            print("You Lose")
            break
        }
    }
    
    func addFlag(node: SKNode, position: CGPoint) {
        
        
        
    }
    
}
