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
    var cantTouchThis: Bool = false
    var rocketToLaunch : RocketEntity? {
        didSet {
            if let sprite = rocketToLaunch?.component(ofType: SpriteComponent.self)?.node{
                sprite.physicsBody?.isDynamic = true
            }
        }
    }
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
        self.blackHole = BlackHoleEntity(size: size)
        if let spriteComponent = blackHole?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73)
        }
        let blackholelight = SKSpriteNode(texture: SKTexture(imageNamed: "blackholelight"))
        blackholelight.size = CGSize(width: size.width * 3.14, height: size.height * 3.14)
        blackholelight.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73)
        blackholelight.zPosition = -10
        self.addChild(blackholelight)
        entityManager?.add(blackHole!)
        createPlanetRed()
        createPlanetBlue()
        createPlanetGreen()
        createPlanetYellow()
        self.blackHole?.rotationComponent?.startRotate(angle: CGFloat.pi * 2, duration: 3)
    }
    
    //Get the black hole position
    func blackHolePosition() -> CGPoint{
        if let spriteComponent = blackHole?.component(ofType: SpriteComponent.self) {
            let position = spriteComponent.node.position
            if let scene = self.parent as? GameScene {
                return self.convert(position, to: scene.backgroundLayer!)
            }
        }
        return CGPoint.zero
    }
    
    
    
    func createPlanetBlue() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetBlue = PlanetEntity(property: PlanetProperties.blue, size: size)
        if let planetSpriteComponent = planetBlue?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: 0, y: -(blackHoleSprite.node.size.height/2))
                planetSpriteComponent.node.zPosition = 20
                entityManager?.addPlanet(self.planetBlue!)
                self.planetBlue?.startRotating(angle: -Double.pi * 2, duration: 3)
            }
        }
    }
    
    func createPlanetGreen() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetGreen = PlanetEntity(property: PlanetProperties.green, size: size)
        if let planetSpriteComponent = planetGreen?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: 0, y: +(blackHoleSprite.node.size.height/2))
                planetSpriteComponent.node.zPosition = 20
                entityManager?.addPlanet(self.planetGreen!)
                self.planetGreen?.startRotating(angle: -Double.pi * 2, duration: 3)
            }
        }
    }
    
    
    func createPlanetRed() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetRed = PlanetEntity(property: PlanetProperties.red, size: size)
        if let planetSpriteComponent = planetRed?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: (blackHoleSprite.node.size.height/2), y: 0)
                planetSpriteComponent.node.zPosition = 20
                entityManager?.addPlanet(self.planetRed!)
                self.planetRed?.startRotating(angle: -Double.pi * 2, duration: 3)
            }
        }
    }
    
    func createPlanetYellow() {
        let size = CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11)
        self.planetYellow = PlanetEntity(property: PlanetProperties.yellow, size: size)
        if let planetSpriteComponent = planetYellow?.component(ofType: SpriteComponent.self) {
            if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
                planetSpriteComponent.node.position = CGPoint(x: -(blackHoleSprite.node.size.height/2), y: 0)
                planetSpriteComponent.node.zPosition = 20
                entityManager?.addPlanet(self.planetYellow!)
                self.planetYellow?.startRotating(angle: -Double.pi * 2, duration: 3)
            }
        }
    }
    
    func createRocketList() {
        var positionX = (self.size?.width)! / 2
        for index in 0...2 {
            let size = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
            let rocket = RocketEntity(size: size, rocketType: RocketType.generateRandomShipProperties())
            
            if(index == 0){
                self.rocketToLaunch = rocket
                resizeRocketToBig(rocket: self.rocketToLaunch!)
            }else {
                resizeRocketToNormal(rocket: rocket)
            }
            
            if let sprite = rocket.component(ofType: SpriteComponent.self) {
                sprite.node.position = CGPoint(x: positionX, y: (self.size?.height)! / 8)
            }
            positionX += (self.size?.width)!/8
            entityManager?.add(rocket)
            self.rocketList.append(rocket)
        }
    }
    
    func resizeRocketToBig(rocket: RocketEntity) {
        if let sprite = rocket.component(ofType: SpriteComponent.self)?.node {
            let resizeAction = SKAction.scale(to: 1, duration: 0.5)
            sprite.run(resizeAction) {
                rocket.stateMachine.enter(IdleState.self)
            }
        }
    }
    
    func resizeRocketToNormal(rocket: RocketEntity) {
        if let sprite = rocket.component(ofType: SpriteComponent.self)?.node {
            let resizeAction = SKAction.scale(to: 0.75, duration: 0.5)
            sprite.run(resizeAction)
        }
    }
    
    func recicleShip(rocket: RocketEntity) {
        rocket.stop()
        let properties = RocketType.generateRandomShipProperties()
        
        if let sprite = rocket.component(ofType: SpriteComponent.self)?.node {
            
            rocket.setup(size: sprite.size, rocketType: properties)
            
            
            sprite.removeAllActions()
            if(rocketList.count > 0){
                sprite.run(SKAction.move(to: CGPoint(x: (rocketList[rocketList.count - 1].spriteComponent?.node.position.x)! + (self.size?.width)!/8, y: (self.size?.height)!/8), duration: 0)){
                    self.cantTouchThis = false
                }
                
            }else {
                sprite.run(SKAction.move(to: CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)!/8), duration: 0)) {
                    self.cantTouchThis = false
                }
            }
            
        }
        resizeRocketToNormal(rocket: rocket)
        rocket.stateMachine.enter(QueueState.self)
        self.rocketList.append(rocket)
    }
    
    func moveRocketList() {
        for index in 0...rocketList.count - 1 {
            if let sprite = rocketList[index].component(ofType: SpriteComponent.self)?.node {
                if(index == 0){
                    let moveAction = SKAction.move(to: CGPoint(x: (self.size?.width)!/2 , y: (self.size?.height)!/8), duration: 0.5)
                    sprite.run(moveAction)
                    resizeRocketToBig(rocket: rocketList[index])
                    rocketList[index].stateMachine.enter(IdleState.self)
                }else {
                    let moveAction = SKAction.move(to: CGPoint(x: sprite.position.x - ((self.size?.width)!/8), y: (self.size?.height)!/8), duration: 0.5)
                    sprite.run(moveAction)
                }
            }
        }
    }
    
    func lauchRocket() {
        if(rocketList.count > 0){
            self.rocketToLaunch = nil
            self.cantTouchThis = true
            self.rocketToLaunch = self.rocketList.remove(at: 0)
            if(rocketToLaunch != nil){
                rocketToLaunch?.stateMachine.enter(LaunchState.self)
                moveRocketList()
            }
        }
    }
    
    func startGameOverEffect(finished: (() -> Void)?) {
        
        
        DispatchQueue.main.async {
            
            self.blackHole?.movePlanetsToCenterBlackHole()
            
            
            var time = 0.333
            
            
            for rocket in self.rocketList {
                rocket.spriteComponent?.node.physicsBody?.categoryBitMask = PhysicsCategory.None
                self.moveToBlackHoleposition(node: (rocket.spriteComponent?.node)!, duration: TimeInterval(time), durantionDecreaseScale: TimeInterval(1), finished: nil)
                time += 0.333
            }
            
            
            
            let group = SKAction.group([SKAction.move(to: CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2), duration: TimeInterval(1)), SKAction.scale(to: 6, duration: TimeInterval(1))])
            
            
            self.blackHole?.spriteComponent?.node.run(group){
                finished?()
            }
            
            
            
        }
        
    }
    
    
    
    //Move a sprite node for blackHole position
    private func moveToBlackHoleposition (node: SKSpriteNode, duration: TimeInterval, durantionDecreaseScale: TimeInterval, finished: (() -> Void)?) {

        //move to black hole position, set scale 0 and remove of screen
        
        let position = CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2 )
        let sequence = SKAction.sequence([SKAction.move(to: position, duration: duration), SKAction.scale(to: 0, duration: durantionDecreaseScale), SKAction.removeFromParent()])
        
        //run sequence and remove all actions of node after actions
        node.run(sequence) {
            node.removeAllActions()
            DispatchQueue.main.async {
                finished?()
            }
            //// mandando as naves pro meio da tela raz
        }
    }
    
    
    private func sceceReference () ->  GameScene! {
        if let parent = self.parent as? GameScene {
            return parent
        }
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(rocketList.count == 3 && !cantTouchThis){
            lauchRocket()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
