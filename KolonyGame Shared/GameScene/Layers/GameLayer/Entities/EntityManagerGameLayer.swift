//
//  EntityManager.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 12/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityManagerGameLayer {
    var entities = Set<GKEntity>()
    let gameLayer: GameLayer
//    lazy var componentSystems : [GKComponentSystem] = {
//        return []
//    }
    var toRemove = Set<GKEntity>()
    
    init(gameLayer: GameLayer) {
        self.gameLayer = gameLayer
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            gameLayer.addChild(spriteNode)
        }
        
//        for componentSystem in componentSystems {
//            componentSystem.addComponent(foundIn: entity)
//        }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        // 1
//        for componentSystem in componentSystems {
//            componentSystem.update(deltaTime: deltaTime)
//        }
        
        // 2
//        for currentRemove in toRemove {
//            for componentSystem in componentSystems {
//                componentSystem.removeComponent(foundIn: currentRemove)
//            }
//        }
        toRemove.removeAll()
    }
    
}
