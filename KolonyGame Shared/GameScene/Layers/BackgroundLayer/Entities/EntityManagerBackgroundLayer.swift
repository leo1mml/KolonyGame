//
//  EntityManagerBackgroundLayer.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 12/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import Foundation
import GameplayKit

public class EntityManagerBackgroundLayer : GKEntity {
    var entities = Set<GKEntity>()
    var bgLayer: BackgroundLayer
    //    lazy var componentSystems : [GKComponentSystem] = {
    //        return []
    //    }
    var toRemove = Set<GKEntity>()
    
    init(bgLayer: BackgroundLayer) {
        self.bgLayer = bgLayer
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            bgLayer.addChild(spriteNode)
        }
        
        //        for componentSystem in componentSystems {
        //            componentSystem.addComponent(foundIn: entity)
        //        }
    }
    
    func add (particles: SKEmitterNode) {
        self.bgLayer.addChild(particles)
    }
    
    func addAll(_ entities: [GKEntity]) {
        
        for i in entities {
            self.entities.insert(i)
            
            if let spriteNode = i.component(ofType: SpriteComponent.self)?.node {
                bgLayer.addChild(spriteNode)
            }
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
