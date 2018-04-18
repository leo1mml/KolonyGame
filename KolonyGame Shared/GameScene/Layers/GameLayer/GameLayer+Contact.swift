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
        
        let categories = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        switch categories {
            
        case (PhysicsCategory.Planet, PhysicsCategory.Rocket):
            handlePlanetAndRocket(planet: contact.bodyA.node!, rocket: contact.bodyB.node!)
            break
        case (PhysicsCategory.Rocket, PhysicsCategory.Planet):
            handlePlanetAndRocket(planet: contact.bodyB.node!, rocket: contact.bodyA.node!)
            break
            
        case (PhysicsCategory.BlackHole, PhysicsCategory.Rocket):
            if let spriteBlackHole = self.blackHole?.component(ofType: SpriteComponent.self) {
                flushRocketTo(centerPoint: (spriteBlackHole.node.position), startRadius: contact.contactPoint.y.distance(to: spriteBlackHole.node.position.y), endRadius: 0, angle: CGFloat.pi * 2, duration: 3)
            }
            break
        case (PhysicsCategory.Rocket, PhysicsCategory.BlackHole):
            if let spriteBlackHole = self.blackHole?.component(ofType: SpriteComponent.self) {
                flushRocketTo(centerPoint: (spriteBlackHole.node.position), startRadius: contact.contactPoint.y.distance(to: spriteBlackHole.node.position.y), endRadius: 0, angle: CGFloat.pi * 2, duration: 3)
            }
            break
        default:
            print("You Lose")
            break
        }
    }
    
    func handlePlanetAndRocket(planet: SKNode, rocket: SKNode) {
        
        if(planet.name == rocket.name){
            addFlag(planet: planet)
            if let parent = self.parent as? GameScene {
                parent.incrementScore()
            }
        }
        recicleShip(rocket: self.rocketToLaunch!)
    }
    
    func addFlag(planet: SKNode) {
        
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
