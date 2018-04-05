//
//  BackgroundEntity.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 12/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//


import SpriteKit
import GameplayKit

class BackgroundEntity : BackgroundBasicEntity {
 
    override init(imageName: String, size: CGSize) {
        super.init(imageName: imageName, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
