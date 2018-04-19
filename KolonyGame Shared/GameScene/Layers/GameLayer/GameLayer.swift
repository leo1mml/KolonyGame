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
    var deltaTime: TimeInterval = 0
    var actionInterval: TimeInterval = NumbersUtil.randomDouble(min: 10, max: 20)
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
        createPlanets()
        self.blackHole?.rotationComponent?.rotate()
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
    
  
    
    func createPlanets() {
        if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
            self.planetBlue = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: PlanetProperties.blue, position: CGPoint(x: 0, y: -(blackHoleSprite.node.size.height/2)), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
            self.planetRed = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: PlanetProperties.red, position: CGPoint(x: (blackHoleSprite.node.size.height/2), y: 0), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
            self.planetGreen = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: PlanetProperties.green, position: CGPoint(x: 0, y: +(blackHoleSprite.node.size.height/2)), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
            self.planetYellow = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: .yellow, position: CGPoint(x: -(blackHoleSprite.node.size.height/2), y: 0), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
        }
    }
    
    func createPlanet(size: CGSize, properties: PlanetProperties, position: CGPoint, zPosition: CGFloat, rotationAngle: Double, duration: Double) -> PlanetEntity{
        let planet = PlanetEntity(property: properties, size: size)
        if let planetSprite = planet.component(ofType: SpriteComponent.self) {
            planetSprite.node.position = position
            planetSprite.node.zPosition = zPosition
            entityManager?.addPlanet(planet)
            planet.startRotating(angle: -Double.pi * 2, duration: 3)
        }
        return planet
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
    
    func flushRocketTo(centerPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat, angle: CGFloat, duration: TimeInterval){
        if let sprite = self.rocketToLaunch?.component(ofType: SpriteComponent.self){
            sprite.node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            sprite.node.physicsBody?.applyAngularImpulse(0.004)
            let scaleDown = SKAction.scale(to: 0, duration: 4)
            let spiralMovement = SKAction.spiral(startRadius: startRadius, endRadius: endRadius, angle: angle, centerPoint: centerPoint, duration: duration)
            sprite.node.run(SKAction.group([scaleDown, spiralMovement])){
                sprite.node.removeFromParent()
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
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if(rocketList.count == 3 && !cantTouchThis){
            lauchRocket()
        }
    }
    
    func update(deltaTime: TimeInterval) {
        if deltaTime < 12000{
            self.deltaTime = self.deltaTime + deltaTime
        }
        if(self.deltaTime >= self.actionInterval){
            self.deltaTime = 0
            self.actionInterval = NumbersUtil.randomDouble(min: 3, max: 5)
            print("inverteu")
            self.blackHole?.rotationComponent?.invertRotation()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
