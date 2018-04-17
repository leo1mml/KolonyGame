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
    
    let STARS_AMOUNT = 45
    let LITLE_STARS_AMOUNT = 100
    
    //layer size
    var size: CGSize?
    var entityManager : EntityManagerBackgroundLayer?
    
    var bg : BackgroundEntity? = nil
    var mist: MistEntity? = nil
    var stars: [StarEntity]? = nil
    var littleStars: [LittleStar]? = nil
    var comets: SKEmitterNode? = nil
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.entityManager = EntityManagerBackgroundLayer(bgLayer: self)
    }

    func setupLayer () {
        
        //creating background
        var size = CGSize(width: (self.size?.width)!, height: (self.size?.height)!)
        self.bg = BackgroundEntity(imageName: "bg", size: size)
        
        //creating stars of background
        size = CGSize(width: (self.size?.height)! * 0.01, height: (self.size?.height)! * 0.01)
        self.stars = createPoolStars(size, BackgroundTextures.star)
        setup(stars!)
        
        //creating mist
        size = CGSize(width: (self.size?.height)! , height: (self.size?.height)!)
        self.mist = MistEntity(imageName: "nevoas", size: size)
        
        //creating little stars of background
        size = CGSize(width: (self.size?.height)! * 0.005, height: (self.size?.height)! * 0.005)
        self.littleStars = createPoolLittleStars(size, BackgroundTextures.littleStar)
        setup(littleStars: littleStars!)
        
        setupEntity(entity: mist!, position: CGPoint.zero, zPosition: -14)
        setupEntity(entity: bg!, position: CGPoint.zero, zPosition: -15)
       
        self.comets = createComet()
        
        self.addEntitiesInBackgroundLayer([bg!, mist!])
        self.entityManager?.addAll(stars!)
        self.entityManager?.addAll(littleStars!)
        self.entityManager?.add(particles: self.comets!)
        
    }
    
    private func addEntitiesInBackgroundLayer (_ entities : [BackgroundBasicEntity]) {
        for i in entities {
            self.entityManager?.add(i)
        }
    }
    
    private func setup (littleStars: [LittleStar]) {
        for i in littleStars {
            //get position x and y in a tuple -> (x: CGFloat, y:CGFloat)
            var pos = randomPosition()
            
            pos.x -= (size?.width)! / 2
            pos.y -=  (size?.height)! / 2
            setupEntity(entity: i, position: CGPoint(x: pos.x, y: pos.y), zPosition: -12)
            
            if let sprite = i.spriteComponent {
                sprite.node.setScale(NumbersUtil.randomCGFloat(min: 0.3, max: 1))
                sprite.node.run(sprite.alphaAction(alphaValue: 0, duration: TimeInterval(NumbersUtil.randomCGFloat(min: 1, max: 4))))
            }
        }
    }
    
    //Create ramdon position for stars and configure they
    private func setup (_ stars: [StarEntity]) {
        
        for  i in stars {
            
            //get position x and y in a tuple -> (x: CGFloat, y:CGFloat)

            var pos = self.randomPosition()
            
            if let size = self.size {
                pos.x -= size.width / 2
                pos.y -= size.height / 2
            }
        
            setupEntity(entity: i, position: CGPoint(x: pos.x, y: pos.y), zPosition: -12)
            
            if let sprite = i.spriteComponent {
                
                //configuring color of sprite
                sprite.node.color = GameColors.ramdomColor()
                sprite.node.colorBlendFactor = 1.0

                //configuring alpha effect
                sprite.node.run(sprite.alphaAction(alphaValue: NumbersUtil.randomCGFloat(min: 0.1, max: 0.4), duration: TimeInterval(NumbersUtil.randomCGFloat(min: 1, max: 3))))
            }
        }
    }

    
    private func randomPosition () -> (x: CGFloat, y: CGFloat) {

        if let size = self.size {
            let respawnDistributionX =  GKShuffledDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: Int(size.width))
            let respawnDistributionY =  GKShuffledDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: Int(size.height))
            
            let x = CGFloat(respawnDistributionX.nextInt())
            let y = CGFloat(respawnDistributionY.nextInt())
            
            return (x,  y)
        }
        
        //default value for exceptions case
        return (CGFloat(0), CGFloat(0))
    }
    
    //Create many stars for background
    private func createPoolStars(_ size : CGSize, _ typeTexture: BackgroundTextures) -> [StarEntity] {
        var stars = [StarEntity]()
        for _ in 0...STARS_AMOUNT {
            stars.append(StarEntity(texture: typeTexture.texture, size: size))
        }
        return stars
    }
    
    
    //Create many little stars for background
    private func createPoolLittleStars(_ size : CGSize, _ typeTexture: BackgroundTextures) -> [LittleStar] {
        var stars = [LittleStar]()
        for _ in 0...LITLE_STARS_AMOUNT {
            stars.append(LittleStar(texture: typeTexture.texture, size: size))
        }
        return stars
    }
    
    //configure properties of a gkEntity
    private func setupEntity<T: GKEntity>(entity: T, position: CGPoint, zPosition: CGFloat?) {
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            if let zPosition = zPosition {
                spriteComponent.node.zPosition = zPosition
            }
        }
    }
    
    //create comets particles
    private func createComet() -> SKEmitterNode {
        
        let particle = SKEmitterNode(fileNamed: "Comets.sks")
        let texture = SKTexture(image: #imageLiteral(resourceName: "cometa"))
        
        texture.filteringMode = .linear
        particle?.particleTexture = texture
        
        particle?.position = CGPoint(x: (size?.width)!/2 * -1, y: ((size?.height)!/2))
        particle?.zPosition = -13
        particle?.name = "comets"

        return particle!
    }
    
    private func moveSpritesToBlackHolePostion () {
        moveToBlackHoleposition(node: (self.mist?.spriteComponent?.node)!, duration: TimeInterval(1.5), durantionDecreaseScale: TimeInterval(2))
        moveStars(stars: self.stars!, duration: TimeInterval(NumbersUtil.randomInt(min: 1, max: 3)))
        moveStars(stars: self.littleStars!, duration: TimeInterval(NumbersUtil.randomInt(min: 1, max: 3)))
    }
    
    private func moveStars <T: BackgroundBasicEntity> (stars: [T], duration: TimeInterval) {
        for star in stars {
            moveToBlackHoleposition(node: (star.spriteComponent?.node)!, duration: duration, durantionDecreaseScale: TimeInterval(2))
        }
    }
    
    func startGameOverEffect () {
        self.moveSpritesToBlackHolePostion()
        self.comets?.numParticlesToEmit = 0
    }
    
    //Move a sprite node for blackHole position
    private func moveToBlackHoleposition (node: SKSpriteNode, duration: TimeInterval, durantionDecreaseScale: TimeInterval) {
        let scene = self.sceceReference()
        var position = CGPoint.zero
        if let gameLayer = scene?.gameLayer {
            position = gameLayer.blackHolePosition()
        }
        
        //move to black hole position, set scale 0 and remove of screen
        let sequence = SKAction.sequence([SKAction.move(to: position, duration: duration), SKAction.scale(to: 0, duration: durantionDecreaseScale), SKAction.removeFromParent()])
        
        //run sequence and remove all actions of node after actions
        node.run(sequence) {
            node.removeAllActions()
        }
    }
    
    private func sceceReference () ->  GameScene! {
        if let parent = self.parent as? GameScene {
            return parent
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
