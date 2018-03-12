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
    
    init(size: CGSize) {
        super.init()
        self.size = size
        entityManager = EntityManagerGameLayer(gameLayer: self)
        
        
    }
    
    
    func configureLayer() {
        createPlanetOne()
    }
    
//    let humanCastle = Castle(imageName: "castle1_atk", team: .team1)
//    if let spriteComponent = humanCastle.component(ofType: SpriteComponent.self) {
//        spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width/2, y: size.height/2)
//    }
//    entityManager.add(humanCastle)
    
    func createPlanetOne() {
        let planetOne = PlanetEntity(imageName: "planet1")
        if let spriteComponent = planetOne.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)!/2)
        }
        entityManager?.add(planetOne)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
