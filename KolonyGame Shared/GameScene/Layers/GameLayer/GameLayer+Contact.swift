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
            getPlanet(contact: contact, type: PlanetProperties.red)
            break
        case ("blue", "blue"):
            getPlanet(contact: contact, type: PlanetProperties.blue)
            break
        case ("green", "green"):
            getPlanet(contact: contact, type: PlanetProperties.green)
            break
        case ("yellow", "yellow"):
            getPlanet(contact: contact, type: PlanetProperties.yellow)
            break
        default:
            print("You Lose")
            break
        }
    }
    
    func getPlanet(contact: SKPhysicsContact, type: PlanetProperties) {
        
        var planet: SKNode
        
        if contact.bodyA.node?.physicsBody?.categoryBitMask == PhysicsCategory.Planet {
            planet = contact.bodyA.node!
        } else {
            planet = contact.bodyB.node!
        }
        
        addFlag(planet: planet, contactPoint: contact.contactPoint)
        
    }
    
    func addFlag(planet: SKNode, contactPoint: CGPoint) {
        
        var texture: SKTexture
        var flag: SKSpriteNode
        
        switch planet.name {
        case PlanetProperties.red.type:
            
            texture = SKTexture(imageNamed: "bandeira1")
            flag = SKSpriteNode(texture: texture)
            blackHole?.spriteComponent?.node.addChild(flag)
            
            break
        case PlanetProperties.blue.type:
            
            break
        case PlanetProperties.green.type:
            
            break
        case PlanetProperties.yellow.type:
            
            break
        default:
            break
        }
        
    }
    
}
