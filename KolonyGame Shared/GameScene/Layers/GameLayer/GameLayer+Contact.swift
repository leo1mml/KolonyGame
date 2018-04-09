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
            
            texture = SKTexture(imageNamed: "flagred")
            flag = SKSpriteNode(texture: texture)
            self.planetRed?.addFlag(flag: flag)
            
            break
        case PlanetProperties.blue.type:
            
            texture = SKTexture(imageNamed: "flagblue")
            flag = SKSpriteNode(texture: texture)
            self.planetBlue?.addFlag(flag: flag)
            
            break
        case PlanetProperties.green.type:
            
            texture = SKTexture(imageNamed: "flaggreen")
            flag = SKSpriteNode(texture: texture)
            self.planetGreen?.addFlag(flag: flag)
            
            break
        case PlanetProperties.yellow.type:
            
            texture = SKTexture(imageNamed: "flagyellow")
            flag = SKSpriteNode(texture: texture)
            self.planetYellow?.addFlag(flag: flag)
            
            break
        default:
            break
        }
        
    }
    
}
