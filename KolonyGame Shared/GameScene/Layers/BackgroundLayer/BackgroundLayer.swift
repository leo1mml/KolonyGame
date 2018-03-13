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
        let bg = BackgroundEntity(imageName: "bg")
        if let spriteComponent = bg.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint.zero
            spriteComponent.node.size.height = (self.size?.height)!
            spriteComponent.node.size.width = ((self.size?.width)! )
        }
        entityManager?.add(bg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


}
