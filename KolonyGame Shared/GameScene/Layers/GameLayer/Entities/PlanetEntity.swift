//
//  PlanetEntity.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlanetEntity: GKEntity {
    
    var spriteComponent : SpriteComponent?
    var physicsBodyComponent: PhysicBodyComponent?
    var translationComponent: TranslationComponent?
    
    init(imageName: String, size: CGSize) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        
        self.spriteComponent = SpriteComponent(texture: texture, size: size)
        self.addComponent(self.spriteComponent!)
        
        self.physicsBodyComponent = PhysicBodyComponent(node: (spriteComponent?.node)!, physicCategory: PhysicsCategory.Planet)
        self.spriteComponent?.node.physicsBody = self.physicsBodyComponent?.physicBody
        
        self.translationComponent = TranslationComponent(entity: self)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
