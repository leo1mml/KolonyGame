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
            jackpotSound()
            addFlag(planet: planet, contactPoint: contactPoint)
            if let parent = self.parent as? GameScene {
                self.blackHole?.rotationComponent?.rotationDuration = (self.blackHole?.rotationComponent?.rotationDuration)! - 0.02
                parent.incrementScore()
            }
            
        } else {
            
            if let parent = self.parent as? GameScene {
                addSmoke(contactPoint: contactPoint)
                missSound()
                parent.changeState(state: GameOverState.self)
                self.tapToLaunch = true
            }
            
        }
        
        recicleShip(rocket: self.rocketToLaunch!)
        
    }
    
    
    func handleRocketAndBlackHole (rocket: SKNode, blackHole: SKNode) {
        if let parent = self.parent as? GameScene {
            parent.changeState(state: GameOverState.self)
            self.tapToLaunch = true
        }
    }
    
    func blackHoleSound() {
        
        let audioNode = SKAudioNode(fileNamed: "blackHole")
        let audioNode2 = SKAudioNode(fileNamed: "blackHole2")
        
        (self.parent as! GameScene).backgroundMusic1?.stop()
        (self.parent as! GameScene).backgroundMusic2?.stop()
        
        let waitNode = SKAction.wait(forDuration: 9)
        let waitNode2 = SKAction.wait(forDuration: 52)
        
        let removeNode = SKAction.run {
            audioNode.removeFromParent()
        }
        let removeNode2 = SKAction.run {
            audioNode2.removeFromParent()
        }
        
        let action = SKAction.sequence([waitNode, removeNode])
        let action2 = SKAction.sequence([waitNode2, removeNode2])
        
        let audio1 = SKAction.run {
            audioNode.run(action)
            self.addChild(audioNode)
        }
        let audio2 = SKAction.run {
            audioNode2.run(action2)
            self.addChild(audioNode2)
        }
        
        let sequence = SKAction.sequence([audio1, audio2])
        self.run(sequence)
        
    }
    
    func jackpotSound() {
        let audioNode = SKAudioNode(fileNamed: "point")
        
        let wait = SKAction.wait(forDuration: 2)
        let remove = SKAction.run {
            audioNode.removeFromParent()
        }
        
        let action = SKAction.sequence([wait, remove])
        audioNode.run(action)
        
        self.addChild(audioNode)
    }
    
    func missSound() {
        let audioNode = SKAudioNode(fileNamed: "explosion")
        
        let wait = SKAction.wait(forDuration: 2)
        let remove = SKAction.run {
            audioNode.removeFromParent()
        }
        
        let action = SKAction.sequence([wait, remove])
        audioNode.run(action)
        
        self.addChild(audioNode)
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
