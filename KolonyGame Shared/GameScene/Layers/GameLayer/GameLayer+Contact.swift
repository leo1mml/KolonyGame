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
        
        let names = (contact.bodyA.node?.name, contact.bodyB.node?.name)
        
        switch names {
        case ("red", "red"):
            getPlanet(contact: contact)
            break
        case ("blue", "blue"):
            getPlanet(contact: contact)
            break
        case ("green", "green"):
            getPlanet(contact: contact)
            break
        case ("yellow", "yellow"):
            getPlanet(contact: contact)
            break
        default:
            print("You Lose")
            break
        }
    }
    
    func getPlanet(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.Planet {
            addFlag(node: contact.bodyA.node!, typeColor: TypeColor.red.rawValue, contactPoint: contact.contactPoint)
        } else {
            addFlag(node: contact.bodyB.node!, typeColor: TypeColor.red.rawValue, contactPoint: contact.contactPoint)
        }
    }
    
    func addFlag(node: SKNode, typeColor: String, contactPoint: CGPoint) {
        
        switch typeColor {
        case "red":
            let flag = SKSpriteNode(texture: SKTexture(imageNamed: "bandeira1"))
            flag.position = convert(contactPoint, from: self)
            print("RED")
            break
        case "blue":
            print("BLUE")
            break
        case "green":
            print("GREEN")
            break
        case "yellow":
            print("YELLOW")
            break
        default:
            print("You Lose")
        }
        
    }
    
}
