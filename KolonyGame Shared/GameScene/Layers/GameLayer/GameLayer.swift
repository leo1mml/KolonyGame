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
    
    init(size: CGSize) {
        super.init()
        self.size = size
        entityManager = EntityManagerGameLayer(gameLayer: self)
        
    }
    
    
    func configureLayer() {
        createBlackHole()
    }
    
    
    func createBlackHole() {
        self.blackHole = BlackHoleEntity(imageName: "blackhole")
        if let spriteComponent = blackHole?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.size.height = (self.size?.height)! * 0.31
            spriteComponent.node.size.width = (self.size?.height)! * 0.31
            spriteComponent.node.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73)
        }
        entityManager?.add(blackHole!)
        createPlanetOne()
    }
    
    func createPlanetOne() {
        let planetOne = PlanetEntity(imageName: "planet1")
        if let planetSpriteComponent = planetOne.component(ofType: SpriteComponent.self) {
            planetSpriteComponent.node.size.height = (self.size?.height)! * 0.11
            planetSpriteComponent.node.size.width = (self.size?.height)! * 0.11
            if let blackHoleSprite = blackHole?.component(ofType: SpriteComponent.self) {
                planetSpriteComponent.node.position.x = 0
                planetSpriteComponent.node.position.y = -(blackHoleSprite.node.size.height/2)
//                blackHoleSprite.node.addChild(planetSpriteComponent.node)
                entityManager?.addPlanet(planetOne)
            }
            
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
