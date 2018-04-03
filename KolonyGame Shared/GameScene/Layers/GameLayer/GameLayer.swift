//
//  GameLayer.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//
import SpriteKit

class GameLayer: SKNode {
    
    var size: CGSize?
    var entityManager : EntityManagerGameLayer?
    var blackHole : BlackHoleEntity?
    var rocket: RocketEntity?
    
    init(size: CGSize) {
        super.init()
        self.size = size
        entityManager = EntityManagerGameLayer(gameLayer: self)
    }
    
    
    func configureLayer() {
        createBlackHole()
        createRocket()
    }
    
    
    func createBlackHole() {
        let size = CGSize(width: (self.size?.height)! * 0.31, height: (self.size?.height)! * 0.31)
        self.blackHole = BlackHoleEntity(imageName: "blackhole", size: size)
        if let spriteComponent = blackHole?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73)
        }
        entityManager?.add(blackHole!)
        createPlanetOne()
    }
    
    func createPlanetOne() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        let planetOne = PlanetEntity(imageName: "planet1", size: size)
        if let planetSpriteComponent = planetOne.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = blackHole?.component(ofType: SpriteComponent.self) {
                planetSpriteComponent.node.position.x = 0
                planetSpriteComponent.node.position.y = -(blackHoleSprite.node.size.height/2)
                entityManager?.addPlanet(planetOne)
            }
        }
    }
    
    func createRocket() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocket = RocketEntity(imageName: "nave", size: size)
        
        if let sprite = rocket?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
        
        entityManager?.add(rocket!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "planet" && contact.bodyB.node?.name == "rocket") || (contact.bodyB.node?.name == "planet" && contact.bodyA.node?.name == "rocket") {
            print("acertou")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let sprite = rocket?.component(ofType: SpriteComponent.self) {
            sprite.node.physicsBody?.applyForce(CGVector(dx: 0, dy: 400))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
