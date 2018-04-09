//
//  EntityManagerHudLayer.swift
//  KolonyGame
//
//  Created by Isaias Fernandes on 09/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import GameplayKit
import SpriteKit

class EntityManagerHudLayer: GKEntity {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    var hudLayer: HudLayer
    
    
    init(hudLayer: HudLayer) {
        self.hudLayer = hudLayer
        super.init()
        
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            hudLayer.addChild(spriteNode)
        }
        
        //        for componentSystem in componentSystems {
        //            componentSystem.addComponent(foundIn: entity)
        //        }
    }
    
    func add(_ label: SKLabelNode) {
        hudLayer.addChild(label)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
