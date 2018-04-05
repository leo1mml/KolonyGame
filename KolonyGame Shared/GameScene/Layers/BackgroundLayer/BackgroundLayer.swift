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
    
    //layer size
    var size: CGSize?
    
    var entityManager : EntityManagerBackgroundLayer?
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.entityManager = EntityManagerBackgroundLayer(bgLayer: self)
    }

    func setupLayer () {
        
        //creating background
        var size = CGSize(width: (self.size?.width)!, height: (self.size?.height)!)
        let bg = BackgroundEntity(imageName: "bg", size: size)
        
        //creating stars of background
        size = CGSize(width: (self.size?.height)! * 0.01, height: (self.size?.height)! * 0.01)
        let stars = createPoolStars(size, "stardefault")
        setup(stars)
        
        //creating mist
        size = CGSize(width: (self.size?.height)! , height: (self.size?.height)!)
        let mist = StarEntity(imageName: "nevoas", size: size)
        
        setupEntity(entity: mist, position: CGPoint.zero, zPosition: nil)
        setupEntity(entity: bg, position: CGPoint.zero, zPosition: -5)
       
        self.addEntitiesInBackgroundLayer([bg, mist])
        self.entityManager?.addAll(stars)
        self.entityManager?.add(particles: createComet())
        
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
            
            if let sprite = i.spriteComponent {
                
                //configuring color of sprite
                sprite.node.color = GameColors.ramdomColor()
                sprite.node.colorBlendFactor = 1.0
                
                //configuring scale effect
                sprite.node.run(sprite.scaleAction(timeBetweenScale: 1, scaleMultiplier: NumbersUtil.randomCGFloat(min: 0.4, max: 1.5)))
                
                //configuring alpha fade effect
                sprite.node.run(sprite.alphaAction(alphaValue: NumbersUtil.randomCGFloat(min: 0, max: 0.8), duration: TimeInterval(NumbersUtil.randomCGFloat(min: 4, max: 6))))

            }
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
    
    //configure properties of a gkEntity
    func setupEntity<T: GKEntity>(entity: T, position: CGPoint, zPosition: CGFloat?) {
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            if let zPosition = zPosition {
                spriteComponent.node.zPosition = zPosition
            }
        }
    }
    
    //create comets particles
    func createComet() -> SKEmitterNode{
        
        let particle = SKEmitterNode(fileNamed: "Comets.sks")
        let texture = SKTexture(image: #imageLiteral(resourceName: "cometa"))
        
        texture.filteringMode = .linear
        particle?.particleTexture = texture
        
        particle?.position = CGPoint(x: 0, y: (self.size?.height)!)
        particle?.particlePositionRange = CGVector(dx: ((self.size?.width)! * 3), dy: 0)
        
        return particle!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
