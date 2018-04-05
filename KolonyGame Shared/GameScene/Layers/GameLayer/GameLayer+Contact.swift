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
        
        let tupla = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        switch tupla {
        case (PhysicsCategory.RedPlanet, PhysicsCategory.RedRocket):
            print("red")
            break
        case (PhysicsCategory.RedRocket, PhysicsCategory.RedPlanet):
            print("red")
            break
        case (PhysicsCategory.BluePlanet, PhysicsCategory.BlueRocket):
            print("blue")
            break
        case (PhysicsCategory.BlueRocket, PhysicsCategory.BluePlanet):
            print("blue")
            break
        case (PhysicsCategory.GreenPlanet, PhysicsCategory.GreenRocket):
            print("green")
            break
        case (PhysicsCategory.GreenRocket, PhysicsCategory.GreenPlanet):
            print("green")
            break
        case (PhysicsCategory.YellowPlanet, PhysicsCategory.YellowRocket):
            print("yellow")
            break
        case (PhysicsCategory.YellowRocket, PhysicsCategory.YellowPlanet):
            print("yellow")
            break
        default:
            print("erro")
            break
        }
    }
    
    func addFrag(node: SKNode, position: CGPoint) {
        
        
        
    }
    
}
