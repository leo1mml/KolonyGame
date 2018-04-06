//
//  GameLayer.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//
import SpriteKit

class GameLayer: SKNode {
    
    var size: CGSize?
    var entityManager : EntityManagerGameLayer?
    var blackHole : BlackHoleEntity?
    var planetOne : PlanetEntity?
    var planetTwo : PlanetEntity?
    var rocketToLaunch : RocketEntity?
    var rocketList = [RocketEntity]()
    
    init(size: CGSize) {
        super.init()
        self.size = size
        entityManager = EntityManagerGameLayer(gameLayer: self)
    }
    
    func configureLayer() {
        createBlackHole()
        createRocketList()
    }
    
    func createBlackHole() {
        let size = CGSize(width: (self.size?.height)! * 0.31, height: (self.size?.height)! * 0.31)
        self.blackHole = BlackHoleEntity(imageName: "blackhole", size: size)
        if let spriteComponent = blackHole?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73)
        }
        entityManager?.add(blackHole!)
        createPlanetRed()
        createPlanetBlue()
        createPlanetGreen()
        createPlanetYellow()
        self.blackHole?.rotationComponent?.startRotate(angle: CGFloat.pi * 2, duration: 8)
    }
    
    func createPlanetBlue() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetOne = PlanetEntity(imageName: "planetblue", size: size)
        if let planetSpriteComponent = planetOne?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: 0, y: -(blackHoleSprite.node.size.height/2))
                entityManager?.addPlanet(self.planetOne!)
                self.planetOne?.startRotating(angle: -Double.pi * 2, duration: 4)
            }
        }
    }
    
    func createPlanetGreen() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetTwo = PlanetEntity(imageName: "planetgreen", size: size)
        if let planetSpriteComponent = planetTwo?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: 0, y: +(blackHoleSprite.node.size.height/2))
                entityManager?.addPlanet(self.planetTwo!)
                self.planetTwo?.startRotating(angle: -Double.pi * 2, duration: 5)
            }
        }
    }
    
    func createPlanetRed() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetTwo = PlanetEntity(imageName: "planetred", size: size)
        if let planetSpriteComponent = planetTwo?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: (blackHoleSprite.node.size.height/2), y: 0)
                entityManager?.addPlanet(self.planetTwo!)
                self.planetTwo?.startRotating(angle: -Double.pi * 2, duration: 3.5)
            }
        }
    }
    
    func createPlanetYellow() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetTwo = PlanetEntity(imageName: "planetyellow", size: size)
        if let planetSpriteComponent = planetTwo?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: -(blackHoleSprite.node.size.height/2), y: 0)
                entityManager?.addPlanet(self.planetTwo!)
                self.planetTwo?.startRotating(angle: -Double.pi * 2, duration: 3)
            }
        }
    }
    
    func createRocketList() {
        var positionX = (self.size?.width)! / 2
        for index in 0...2 {
            let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
            let rocket = RocketEntity(imageName: "nave", size: size)
            
            if(index == 0){
                self.rocketToLaunch = rocket
            }
            
            if let sprite = rocket.component(ofType: SpriteComponent.self) {
                sprite.node.position = CGPoint(x: positionX, y: (self.size?.height)! / 8)
            }
            positionX += (self.size?.width)!/10
            entityManager?.add(rocket)
            self.rocketList.append(rocket)
        }
    }
    
    func configureRandomRocketShip(ship: RocketEntity) {
        let type = Int(arc4random_uniform(4))
        let texture = generateRandomTexture(type: type)
        
        
    }
    
    func generateRandomTexture(type: Int) -> SKTexture {
        switch type {
        case 0:
            return SKTexture(imageNamed: "planetblue")
        case 1:
            return SKTexture(imageNamed: "planetgreen")
        case 2:
            return SKTexture(imageNamed: "planetred")
        case 3:
            return SKTexture(imageNamed: "planetyellow")
        default:
            return SKTexture(imageNamed: "")
        }
    }
    
    func lauchRocket() {
        rocketToLaunch?.applyForce(force: CGVector(dx: 0, dy: 800))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let tupla = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        switch tupla {
        case (PhysicsCategory.RedPlanet, PhysicsCategory.RedRocket):
            print("contact")
            break
        case (PhysicsCategory.RedRocket, PhysicsCategory.RedPlanet):
            print("contact")
            break
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lauchRocket()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
