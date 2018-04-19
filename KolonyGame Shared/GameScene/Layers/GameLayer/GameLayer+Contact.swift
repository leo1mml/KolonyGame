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
                handleRocketAndBlackHole(rocket: contact.bodyB.node!, blackHole: contact.bodyA.node!)
            }
            
            break
        case (PhysicsCategory.Rocket, PhysicsCategory.BlackHole):
            if let spriteBlackHole = self.blackHole?.component(ofType: SpriteComponent.self) {
                flushRocketTo(centerPoint: (spriteBlackHole.node.position), startRadius: contact.contactPoint.y.distance(to: spriteBlackHole.node.position.y), endRadius: 0, angle: CGFloat.pi * 2, duration: 3)
                handleRocketAndBlackHole(rocket: contact.bodyA.node!, blackHole: contact.bodyB.node!)
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
        }else {
            if let parent = self.parent as? GameScene {
                addSmoke(contactPoint: contactPoint)
                parent.changeState(state: GameOverState.self)
            }
            
        }
        recicleShip(rocket: self.rocketToLaunch!)
        
    }
    
    
    func handleRocketAndBlackHole (rocket: SKNode, blackHole: SKNode) {
        if let parent = self.parent as? GameScene {
            parent.changeState(state: GameOverState.self)
        }
    }
    
    
     func addFireworks(contactPoint: CGPoint) {
        
        let planetSize = planetRed?.spriteComponent?.node.size
        
        let firework = SKSpriteNode(texture: SKTexture(imageNamed: "fireworks_0"))
        firework.zPosition = 50
        firework.size = CGSize(width: (planetSize?.width)! * 1.2, height: (planetSize?.height)! * 1.2)
        firework.position = contactPoint
        
        var textures = [SKTexture]()
        
        for i in 0...16 {
            let name = "fireworks_\(i)"
            textures.append(SKTexture(imageNamed: name))
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.06)
        
        self.addChild(firework)
        
        firework.run(animation){
            firework.removeFromParent()
        }
        
    }
    
    func addSmoke(contactPoint: CGPoint) {
        var smoke: SKEmitterNode?
        
        guard let emitter = SKEmitterNode(fileNamed: "Smoke.sks") else {
            return
        }
        
        emitter.name = "smoke"
        emitter.targetNode = self
        smoke = emitter
        smoke?.position = contactPoint
        smoke?.particleZPosition = 50
        
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
    
    func addFlag(planet: SKNode, contactPoint: CGPoint) {
        
        let convertedPoint = self.convert(contactPoint, to: planet)
        
        addFireworks(contactPoint: contactPoint)
        
        switch planet.name {
        case PlanetProperties.red.type:
            
            self.planetRed?.addFlag(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.blue.type:
            
            self.planetBlue?.addFlag(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.green.type:
            
            self.planetGreen?.addFlag(contactPoint: convertedPoint)
            
            break
        case PlanetProperties.yellow.type:
            
            self.planetYellow?.addFlag(contactPoint: convertedPoint)
            
            break
        default:
            break
        }
        
    }
    
}
