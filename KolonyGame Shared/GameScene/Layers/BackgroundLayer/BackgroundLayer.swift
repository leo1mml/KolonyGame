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
        let star = StarEntity(imageName: "star", size: size)
        
        
        let stars = createPoolStars(size, "star")
        setup(stars)
        
        
        setupEntity(entity: star, position: CGPoint.zero)
        setupEntity(entity: bg, position: CGPoint.zero)
        
        bg.spriteComponent?.node.zPosition = -5
        
        self.entityManager?.add(bg)
        self.entityManager?.addAll(stars)
        
    }
    
    func setup (_ stars: [StarEntity]) {
        for (index, i ) in stars.enumerated() {
            
            var x = CGFloat(arc4random_uniform(UInt32(size!.width)))
            x -= (size?.width)! / 2
            var y = CGFloat(arc4random_uniform(UInt32(size!.height)))
            y -= (size?.height)! / 2
            setupEntity(entity: i, position: CGPoint(x: x, y: y))
        }
    }
    
    
    
    func createPoolStars(_ size : CGSize, _ imageName: String) -> [StarEntity] {
        var stars = [StarEntity]()
        for _ in 0...STARS_AMOUNT {
            stars.append(StarEntity(imageName: imageName, size: size))
        }
        return stars
    }
    
    func setupEntity<T: GKEntity>(entity: T, position: CGPoint) {
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            spriteComponent.node.run(spriteComponent.scaleAction(timeBetweenScale: 1, scaleMultiplier: 1.3))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
