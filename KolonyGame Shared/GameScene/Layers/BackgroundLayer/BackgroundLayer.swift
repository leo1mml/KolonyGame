//
//  BackgroundLayer.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 12/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class BackgroundLayer: SKNode {
    var size: CGSize?
   var entityManager : EntityManagerBackgroundLayer?
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.entityManager = EntityManagerBackgroundLayer(bgLayer: self)
    }
    
    
    func setupLayer () {
        
        var size = CGSize(width: (self.size?.width)!, height: (self.size?.height)!)
        let bg = BackgroundEntity(imageName: "bg", size: size)

        size = CGSize(width: (self.size?.height)! * 0.018, height: (self.size?.height)! * 0.018)
        let star = StarEntity(imageName: "star", size: size)

        setupEntity(entity: bg, position: CGPoint.zero)
        setupEntity(entity: star, position: CGPoint.zero)
        
        self.entityManager?.add(bg)
        self.entityManager?.add(star)
        
    }

    
    
    func setupEntity<T: GKEntity>(entity: T, position: CGPoint) {
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


}
