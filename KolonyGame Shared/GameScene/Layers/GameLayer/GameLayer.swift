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
    
    init(size: CGSize) {
        super.init()
        self.size = size
        entityManager = EntityManagerGameLayer(gameLayer: self)
    }
    
    func configureLayer() {
        createBlackHole()
        createRocketRed()
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
        self.planetOne = PlanetEntity(imageName: "planetblue", size: size, typeColor: TypeColor.blue)
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
        self.planetTwo = PlanetEntity(imageName: "planetgreen", size: size, typeColor: TypeColor.green)
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
        self.planetTwo = PlanetEntity(imageName: "planetred", size: size, typeColor: TypeColor.red)
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
        self.planetTwo = PlanetEntity(imageName: "planetyellow", size: size, typeColor: TypeColor.yellow)
        if let planetSpriteComponent = planetTwo?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: -(blackHoleSprite.node.size.height/2), y: 0)
                entityManager?.addPlanet(self.planetTwo!)
                self.planetTwo?.startRotating(angle: -Double.pi * 2, duration: 3)
            }
        }
    }
    
    func createRocketBlue() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocket = RocketEntity(imageName: "nave", size: size, typeColor: TypeColor.blue)
        
        if let sprite = rocket?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
    }
    
    func createRocketGreen() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocket = RocketEntity(imageName: "nave", size: size, typeColor: TypeColor.green)
        
        if let sprite = rocket?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
        entityManager?.add(rocket!)
    }
    
    func createRocketRed() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocket = RocketEntity(imageName: "nave", size: size, typeColor: TypeColor.red)
        print("\(String(describing: rocket?.spriteComponent?.node.name))")
        
        if let sprite = rocket?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
        entityManager?.add(rocket!)
    }
    
    func createRocketYellow() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocket = RocketEntity(imageName: "nave", size: size, typeColor: TypeColor.yellow)
        
        if let sprite = rocket?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
        entityManager?.add(rocket!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rocketToLaunch?.applyForce(force: CGVector(dx: 0, dy: 800))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
