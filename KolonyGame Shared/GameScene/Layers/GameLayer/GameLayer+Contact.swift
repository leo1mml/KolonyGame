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
            handlePlanetAndRocket(planet: contact.bodyA.node!, rocket: contact.bodyB.node!, contactPoint: contact.contactPoint)
            break
        case (PhysicsCategory.Rocket, PhysicsCategory.Planet):
            handlePlanetAndRocket(planet: contact.bodyB.node!, rocket: contact.bodyA.node!, contactPoint: contact.contactPoint)
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
    
    func handlePlanetAndRocket(planet: SKNode, rocket: SKNode, contactPoint: CGPoint) {
        
        if(planet.name == rocket.name){
            
            addFlag(planet: planet, contactPoint: contactPoint)
            if let parent = self.parent as? GameScene {
                parent.incrementScore()
            }
        } else {
            addSmoke(planet: planet, contactPoint: contactPoint)
        }
        recicleShip(rocket: self.rocketToLaunch!)
        
    }
    
    func addSmoke(planet: SKNode, contactPoint: CGPoint) {
        
        let convertedPoint = self.convert(contactPoint, to: planet)
        
        switch planet.name {
        case PlanetProperties.red.type:
            
            self.planetRed?.addSmoke(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.blue.type:
            
            self.planetBlue?.addSmoke(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.green.type:
            
            self.planetGreen?.addSmoke(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.yellow.type:
            
            self.planetYellow?.addSmoke(contactPoint: convertedPoint)
            
            break
        default:
            break
        }
    }
    
    func addFlag(planet: SKNode, contactPoint: CGPoint) {
        
        let convertedPoint = self.convert(contactPoint, to: planet)
        
        switch planet.name {
        case PlanetProperties.red.type:
            
            self.planetRed?.addFlag(contactPoint: convertedPoint)
            self.planetRed?.addFireworks(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.blue.type:
            
            self.planetBlue?.addFlag(contactPoint: convertedPoint)
            self.planetBlue?.addFireworks(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.green.type:
            
            self.planetGreen?.addFlag(contactPoint: convertedPoint)
            self.planetGreen?.addFireworks(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.yellow.type:
            
            self.planetYellow?.addFlag(contactPoint: convertedPoint)
            self.planetYellow?.addFireworks(contactPoint: convertedPoint)
            
            break
        default:
            break
        }
        
    }
    
}
