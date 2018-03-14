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
        let size = CGSize(width: (self.size?.width)!, height: (self.size?.height)!)
        let bg = BackgroundEntity(imageName: "bg", size: size)
        if let spriteComponent = bg.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint.zero
        }
        entityManager?.add(bg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


}
