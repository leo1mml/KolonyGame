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
    var rocketToLaunch : RocketEntity?
    var rocketList = [RocketEntity]()
    
    var planetRed : PlanetEntity?
    var planetBlue : PlanetEntity?
    var planetGreen : PlanetEntity?
    var planetYellow : PlanetEntity?
    
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
        planetGreen?.animate()
        createPlanetYellow()
        self.blackHole?.rotationComponent?.startRotate(angle: CGFloat.pi * 2, duration: 8)
    }
    
    func createPlanetBlue() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetBlue = PlanetEntity(property: PlanetProperties.blue, size: size)
        if let planetSpriteComponent = planetBlue?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: 0, y: -(blackHoleSprite.node.size.height/2))
                entityManager?.addPlanet(self.planetBlue!)
                self.planetBlue?.startRotating(angle: -Double.pi * 2, duration: 4)
            }
        }
    }
    
    func createPlanetGreen() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetGreen = PlanetEntity(property: PlanetProperties.green, size: size)
        if let planetSpriteComponent = planetGreen?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: 0, y: +(blackHoleSprite.node.size.height/2))
                entityManager?.addPlanet(self.planetGreen!)
                self.planetGreen?.startRotating(angle: -Double.pi * 2, duration: 5)
            }
        }
    }
    
    func createPlanetRed() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetRed = PlanetEntity(property: PlanetProperties.red, size: size)
        if let planetSpriteComponent = planetRed?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: (blackHoleSprite.node.size.height/2), y: 0)
                entityManager?.addPlanet(self.planetRed!)
                self.planetRed?.startRotating(angle: -Double.pi * 2, duration: 3.5)
            }
        }
    }
    
    func createPlanetYellow() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetYellow = PlanetEntity(property: PlanetProperties.yellow, size: size)
        if let planetSpriteComponent = planetYellow?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: -(blackHoleSprite.node.size.height/2), y: 0)
                entityManager?.addPlanet(self.planetYellow!)
                self.planetYellow?.startRotating(angle: -Double.pi * 2, duration: 3)
            }
        }
    }
    
    func createRocketList() {
        var positionX = (self.size?.width)! / 2
        for index in 0...2 {
            let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
            let rocket = RocketEntity(size: size, typeColor: RocketType.generateRandomShipProperties())
            
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
    
    func lauchRocket() {
        rocketToLaunch?.applyForce(force: CGVector(dx: 0, dy: 800))
    }
    
    func createRocketGreen() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocketToLaunch = RocketEntity(size: size, typeColor: RocketType.green)
        
        if let sprite = rocketToLaunch?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
        entityManager?.add(rocketToLaunch!)
    }
    
    func createRocketRed() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocketToLaunch = RocketEntity(size: size, typeColor: .red)
        print("\(String(describing: rocketToLaunch?.spriteComponent?.node.name))")
        
        if let sprite = rocketToLaunch?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
        entityManager?.add(rocketToLaunch!)
    }
    
    func createRocketYellow() {
        let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        self.rocketToLaunch = RocketEntity(size: size, typeColor: .yellow)
        
        if let sprite = rocketToLaunch?.component(ofType: SpriteComponent.self) {
            sprite.node.position = CGPoint(x: (self.size?.width)! / 2, y: (self.size?.height)! / 8)
        }
        entityManager?.add(rocketToLaunch!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lauchRocket()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
