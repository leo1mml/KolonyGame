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
            var smoke: SKEmitterNode?
            
            guard let emitter = SKEmitterNode(fileNamed: "Smoke.sks") else {
                return
            }
            
            emitter.name = "smoke"
            emitter.targetNode = self
            smoke = emitter
            smoke?.position = contactPoint
            
            let add = SKAction.run {
                self.addChild(smoke!)
            }
            
            let wait = SKAction.wait(forDuration: 3)
            
            let remove = SKAction.run {
                smoke?.removeFromParent()
            }
            
            let sequence = SKAction.sequence([add, wait, remove])
            
            self.run(sequence)
          
        }
        recicleShip(rocket: self.rocketToLaunch!)
    }
    
    func addFlag(planet: SKNode, contactPoint: CGPoint) {
        
        switch planet.name {
        case PlanetProperties.red.type:
            
            self.planetRed?.addFlag(contactPoint: self.convert(contactPoint, to: planet))
            
            break
        case PlanetProperties.blue.type:
            
            self.planetBlue?.addFlag(contactPoint: self.convert(contactPoint, to: planet))
            
            break
        case PlanetProperties.green.type:
            
            self.planetGreen?.addFlag(contactPoint: self.convert(contactPoint, to: planet))
            
            break
        case PlanetProperties.yellow.type:
            
            self.planetYellow?.addFlag(contactPoint: self.convert(contactPoint, to: planet))
            
            break
        default:
            break
        }
        
    }
    
}
