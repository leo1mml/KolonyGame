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
    
    let STARS_AMOUNT = 100
    
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
        
        size = CGSize(width: (self.size?.height)! * 0.01, height: (self.size?.height)! * 0.01)
        let stars = createPoolStars(size, "stardefault")
        setup(stars)
        
        size = CGSize(width: (self.size?.height)! , height: (self.size?.height)!)
        let mist = StarEntity(imageName: "nevoas", size: size)
        
        setupEntity(entity: mist, position: CGPoint.zero, zPosition: nil)
        setupEntity(entity: bg, position: CGPoint.zero, zPosition: -5)
       
        self.addEntitiesInBackgroundLayer([bg, mist])
        self.entityManager?.addAll(stars)
        
    }
    
    func addEntitiesInBackgroundLayer (_ entities : [BackgroundBasicEntity]) {
        for i in entities {
            self.entityManager?.add(i)
        }
    }
    
    
    //Create ramdon position for stars and configure they
    func setup (_ stars: [StarEntity]) {
        for  i in stars {
            var x = CGFloat(arc4random_uniform(UInt32(size!.width)))
            x -= (size?.width)! / 2
            var y = CGFloat(arc4random_uniform(UInt32(size!.height)))
            y -= (size?.height)! / 2
            setupEntity(entity: i, position: CGPoint(x: x, y: y), zPosition: nil)
        }
    }
    
    
    //Create many stars for background
    func createPoolStars(_ size : CGSize, _ imageName: String) -> [StarEntity] {
        var stars = [StarEntity]()
        for _ in 0...STARS_AMOUNT {
            stars.append(StarEntity(imageName: imageName, size: size))
        }
        return stars
    }
    
    func setupEntity<T: GKEntity>(entity: T, position: CGPoint, zPosition: CGFloat?) {
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            if let zPosition = zPosition {
                spriteComponent.node.zPosition = zPosition
            }
//                spriteComponent.node.run(spriteComponent.scaleAction(timeBetweenScale: 1, scaleMultiplier: 1.3))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
