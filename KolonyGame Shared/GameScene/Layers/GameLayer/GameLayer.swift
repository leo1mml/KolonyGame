//
//  GameLayer.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//
import SpriteKit
import AVFoundation

class GameLayer: SKNode {
    
    // MARK: - VARIABLES
    
    ///Game layer size reference.
    var size: CGSize?
    var rocketSize: CGSize?
    
    ///Entity manager that manages all entities within the game layer.
    var entityManager : EntityManagerGameLayer?
    
    ///The black hole entity reference
    var blackHole : BlackHoleEntity?
    
    ///This variable is used to tell if the game layer is allowed in user interaction or not.
    var cantLaunchRocket: Bool = false
    
    ///This variable is used to inform if the game can enter the next state.
    var nextState: Bool = true
    
    /// Checks if the user has to give a tap before launching the rocket.
    var tapToLaunch = true
    
    /// The rocket reference of the first element in rocket list. When its value is changed  it makes some configurations to itself.
    var rocketToLaunch : RocketEntity? {
        didSet {
            if let sprite = rocketToLaunch?.component(ofType: SpriteComponent.self)?.node{
                sprite.physicsBody?.isDynamic = true
            }
        }
    }
    
    ///The rocket list in order of launch.
    var rocketList = [RocketEntity]()
    
    /// The variation of time between updates.
    var deltaTime: TimeInterval = 0
    
    /// The random interval which the black hole should invert its rotation.
    var actionInterval: TimeInterval = NumbersUtil.randomDouble(min: 10, max: 20)
    
    /// The reference to the red planet.
    var planetRed : PlanetEntity?
    
    /// The reference to the blue planet.
    var planetBlue : PlanetEntity?
    
    /// The reference to the green planet.
    var planetGreen : PlanetEntity?
    
    /// The reference to the yellow planet.
    var planetYellow : PlanetEntity?
    
    /// The black hole sound.
    var blackHoleSound: AVAudioPlayer?
    
    
    // MARK: - INIT
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.rocketSize = CGSize(width: (self.size?.height)! * 0.046, height: (self.size?.height)! * 0.053)
        entityManager = EntityManagerGameLayer(gameLayer: self)
        prepareBlackHoleSound()
    }

    // MARK: - SOUND
    func playBlackHoleSound() {
        self.blackHoleSound?.play()
    }
    
    func stopBlackHoleSound() {
        if (self.blackHoleSound?.isPlaying)! {
            self.blackHoleSound?.stop()
        }
    }
    
    func prepareBlackHoleSound() {
        do{
            self.blackHoleSound =  try AVAudioPlayer(contentsOf:URL.init(fileURLWithPath: Bundle.main.path(forResource: "blackHole", ofType: "mp3")!))
            self.blackHoleSound?.numberOfLoops = 0
        }catch{
            print(error)
        }
    }
    
    // MARK: - CONFIGURATION
    func configureLayer() {
        createBlackHole()
        createRocketList()
    }
    
    
    ///Creates a black hole in the screen, sets it to its specific position and adds its children, the planets.
    func createBlackHole() {
        let size = CGSize(width: (self.size?.height)! * 0.31, height: (self.size?.height)! * 0.31)
        self.blackHole = BlackHoleEntity(size: size)
        if let spriteComponent = blackHole?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73)
            spriteComponent.node.alpha = 0
        }
        let blackholelight = SKSpriteNode(texture: SKTexture(imageNamed: "blackholelight"))
        blackholelight.size = CGSize(width: size.width * 3.14, height: size.height * 3.14)
        blackholelight.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73)
        blackholelight.zPosition = -10
        self.addChild(blackholelight)
        entityManager?.add(blackHole!)
        createPlanets()
        self.blackHole?.stateMachine.enter(RotatingState.self)
    }
    /**
     Get the black hole position
     - Parameters:
     - layer: the layer which the position should be calculated
     - Returns: The position of the sprite relative to the layer passed as argument, or de point zero to the current layer.
     */
    func blackHolePosition(layer: SKNode) -> CGPoint {
        if let spriteComponent = blackHole?.component(ofType: SpriteComponent.self) {
            let position = spriteComponent.node.position
            return self.convert(position, to: layer)
        }
        return CGPoint.zero
    }
    
    /**
     Create all the planets around the black hole
     */
    func createPlanets() {
        if let blackHoleSprite = self.blackHole?.component(ofType: SpriteComponent.self){
            self.planetBlue = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: PlanetProperties.blue, position: CGPoint(x: 0, y: -(blackHoleSprite.node.size.height/2)), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
            self.planetRed = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: PlanetProperties.red, position: CGPoint(x: (blackHoleSprite.node.size.height/2), y: 0), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
            self.planetGreen = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: PlanetProperties.green, position: CGPoint(x: 0, y: +(blackHoleSprite.node.size.height/2)), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
            self.planetYellow = createPlanet(size: CGSize(width: (self.size?.height)! * 0.11, height: (self.size?.height)! * 0.11), properties: .yellow, position: CGPoint(x: -(blackHoleSprite.node.size.height/2), y: 0), zPosition: 20, rotationAngle: -Double.pi * 2, duration: 3)
        }
    }
    
    
    /**
     Creates a planet on the screen
     - Parameters:
     - size: The planet's size
     - properties: The enum with the properties of the planet, default values: blue, yellow, green, red.
     - position: The planet position relative to its layer
     - zPosition: The zPosition of the planet, it's used to avoid overlaying of other items.
     - rotationAngle: The angle in radians that the planet should spin, the rotation is usually used to cancel the default rotation of the black hole.
     - duration: The duration that the planet should perform the rotation.
     - Returns: The planet entity to be added to the entity manager
     */
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
    
    
    /**
     Create the rockets, place them in the right positions, and add them to the layer and entity manager.
     */
    func createRocketList() {
        var positionX = (self.size?.width)! / 2
        for index in 0...2 {
            let rocket = RocketEntity(size: rocketSize!, rocketType: RocketType.generateRandomShipProperties())
            
            if(index == 0){
                self.rocketToLaunch = rocket
                resizeRocketToBig(rocket: self.rocketToLaunch!)
            }else {
                resizeRocketToNormal(rocket: rocket)
            }
            
            if let sprite = rocket.component(ofType: SpriteComponent.self) {
                sprite.node.position = CGPoint(x: positionX, y: (self.size?.height)! / 8)
                if index == 0 {
                    positionX += sprite.node.size.width * 1.75
                }else {
                    positionX += sprite.node.size.width * 1.5
                }
            }
            entityManager?.add(rocket)
            self.rocketList.append(rocket)
        }
    }
    
    // MARK: - UTILS
    
    /**
     Resize the planet to a bigger size
     - Parameters:
     - rocket: The rocket entity which contains the sprite to be resized.
     */
    func resizeRocketToBig(rocket: RocketEntity) {
        if let sprite = rocket.component(ofType: SpriteComponent.self)?.node {
            let resizeAction = SKAction.scale(to: 1, duration: 0.5)
            sprite.run(resizeAction) {
                rocket.stateMachine.enter(IdleState.self)
            }
        }
    }
    
    /**
     Resize the planet to a smaller size
     - Parameters:
     - rocket: The rocket entity which contains the sprite to be resized.
     */
    func resizeRocketToNormal(rocket: RocketEntity) {
        if let sprite = rocket.component(ofType: SpriteComponent.self)?.node {
            let resizeAction = SKAction.scale(to: 0.75, duration: 0.5)
            sprite.run(resizeAction)
        }
    }
    
    /**
     This method is used to recicle a rocket entity after its collision. After the recicle the entity will now be configured with new random properties.
     - Parameters:
     - rocket: The rocket entity to be recicled.
     */
    func recicleShip(rocket: RocketEntity) {
        rocket.stop()
        let properties = RocketType.generateRandomShipProperties()
        
        if let sprite = rocket.component(ofType: SpriteComponent.self)?.node {
            
            rocket.setup(size: sprite.size, rocketType: properties)
            
            sprite.removeAllActions()
            
            sprite.run(SKAction.move(to: CGPoint(x: (rocketList[rocketList.count - 1].spriteComponent?.node.position.x)! + ((rocketList[rocketList.count - 1].spriteComponent?.node.size.width)! * 1.5), y: (self.size?.height)!/8), duration: 0)){
                self.cantLaunchRocket = false
            }
        }
        resizeRocketToNormal(rocket: rocket)
        rocket.stateMachine.enter(QueueState.self)
        self.rocketList.append(rocket)
    }
    
    ///After a rocket is launched this method can move the list and prepare the next ship in line to be Idle, but it can't be launched yet.
    func moveRocketList() {
        for index in 0...rocketList.count - 1 {
            if let sprite = rocketList[index].component(ofType: SpriteComponent.self)?.node {
                if(index == 0){
                    let moveAction = SKAction.move(to: CGPoint(x: (self.size?.width)!/2 , y: (self.size?.height)!/8), duration: 0.5)
                    sprite.run(moveAction)
                    resizeRocketToBig(rocket: rocketList[index])
                    rocketList[index].stateMachine.enter(IdleState.self)
                }else{
                    let moveAction = SKAction.move(to: CGPoint(x: sprite.position.x - (sprite.size.width * 1.5), y: (self.size?.height)!/8), duration: 0.5)
                    sprite.run(moveAction)
                }
            }
        }
    }
    
    ///Launch the rocket at the beginning of the queue and removes it from the rocket list.
    func lauchRocket() {
        if(rocketList.count > 0){
            self.rocketToLaunch = nil
            self.cantLaunchRocket = true
            self.rocketToLaunch = self.rocketList.remove(at: 0)
            if(rocketToLaunch != nil){
                rocketToLaunch?.stateMachine.enter(LaunchState.self)
                moveRocketList()
            }
        }
    }
    
    
    /**
     Makes the rocket disappear in a spiral movement until it gets to a specific point.
     - Parameters:
     - centerPoint: The point which the black hole should go with the spiral movement.
     - startRadius: The distance between the center point and the rocket to be flushed.
     - endRadius: The final distance between the center point and the rocket at the end of the movement.
     - angle: The angle which the movement should go through.
     - duration: The duration of the movement.
     */
    func flushRocketTo(centerPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat, angle: CGFloat, duration: TimeInterval){
        self.nextState = false
        if let sprite = self.rocketToLaunch?.component(ofType: SpriteComponent.self){
            sprite.node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let scaleDown = SKAction.scale(to: 0, duration: 4)
            let spiralMovement = SKAction.spiral(startRadius: startRadius, endRadius: endRadius, angle: angle, centerPoint: centerPoint, duration: duration)
            let rotationMovement = SKAction.rotate(byAngle: CGFloat.pi * CGFloat(2), duration: TimeInterval(0.2))
            let repeatRotationForever = SKAction.repeat(rotationMovement, count: Int((self.size?.height)!/30))
            sprite.node.run(SKAction.group([scaleDown, spiralMovement, repeatRotationForever])){
                self.nextState = true
            }
        }
    }
    
    
    // MARK: - REPPLAY
    
    /**
     Starts the game over animations
     - Parameter finished: A callback that should be performed once the animations are over.
     */
    func startGameOverEffect(finished: (() -> Void)?) {
        DispatchQueue.main.async {
            
            self.blackHole?.movePlanetsToCenterBlackHole()
            
            var time = 0.133
            
            self.blackHole?.rotationComponent?.rotationDuration = 4.0
            
            for rocket in self.rocketList {
                self.moveToBlackHoleposition(node: (rocket.spriteComponent?.node)!, duration: TimeInterval(time), durantionDecreaseAlpha: TimeInterval(0.7), nextPosition: (rocket.spriteComponent?.node.position)! , nextScale: 1, finished: nil)
                time += 0.133
            }
            
            let group = SKAction.group([SKAction.move(to: CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2), duration: TimeInterval(0.7)), SKAction.scale(to: 6, duration: TimeInterval(0.7))])
            
            self.blackHole?.spriteComponent?.node.run(group){
                finished?()
            }
            
        }
        
    }
    
    /**
     Reconfigures the game layer elements to its specific positions.
     */
    func resetupGameLayer () {
        
        let group = SKAction.group([SKAction.move(to: CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)! * 0.73), duration: TimeInterval(1)), SKAction.scale(to: 1, duration: TimeInterval(1))])
        self.blackHole?.spriteComponent?.node.run(group)
        for rocket in self.rocketList {
            rocket.spriteComponent?.node.run(SKAction.fadeIn(withDuration: TimeInterval(1))){
                rocket.resizeFlame(size: self.rocketSize!)
            }
        }
        
        planetRed?.animate()
        planetBlue?.animate()
        planetGreen?.animate()
        planetYellow?.animate()
        
    }
    
    
    /**
     Moves a node to the black hole position
     - Parameters:
     - node: The node that should perform the move action
     - duration: The duration of the movement.
     - durantionDecreaseAlpha: The duration of the decrease size action of the node.
     - nextPosition: The position that the element should go after the game over effect.
     - nextScale: The scale size which the element should be after it concludes the movement.
     - finished: The callback that should be performed once the animation is over.
     */
    private func moveToBlackHoleposition (node: SKSpriteNode, duration: TimeInterval, durantionDecreaseAlpha: TimeInterval, nextPosition: CGPoint, nextScale: Float, finished: (() -> Void)?) {
        
        //move to black hole position, set scale 0 and remove of screen
        
        let position = CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2 )
        let sequence = SKAction.sequence([SKAction.move(to: position, duration: duration), SKAction.fadeAlpha(to: 0, duration: durantionDecreaseAlpha)])
        //
        //run sequence and remove all actions of node after actions
        node.run(sequence) {
            DispatchQueue.main.async {
                finished?()
                self.reconfigureSprite(node, nextPosition)
            }
        }
    }
    
    /**
     Moves the sprite node to a position
     - Parameters:
     - node: The node that should move
     - nextPosition: The position of the node when the movement ends.
     */
    func reconfigureSprite (_ node: SKSpriteNode, _ nextPosition: CGPoint) {
        node.run(SKAction.move(to: nextPosition, duration: TimeInterval(0.1)))
        
    }
    
    
    /**
     Gets the scene reference, the scene which this layer is at.
     */
    private func sceceReference () ->  GameScene! {
        if let parent = self.parent as? GameScene {
            return parent
        }
        return nil
    }
    
    // MARK: - TOUCH
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch()
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        touch()
    }
    
    func touch() {
        
        if let parent = self.parent as? GameScene {
            if parent.stateMachine.currentState is GameOverState && nextState{
                parent.stateMachine.enter(RetryState.self)
            }
        }
        if(rocketList.count == 3 && !cantLaunchRocket && !self.tapToLaunch && sceceReference().stateMachine.currentState is PlayingState){
            lauchRocket()
            
        }else {
            self.tapToLaunch = false
        }
        
    }
    
    // MARK: - UPDATE
    /**
     The update abstraction that should be called within the gameScene.
     - Parameter deltaTime: the time interval between one update and the previous one.
     */
    func update(deltaTime: TimeInterval) {
                if deltaTime < 12000{
                    self.deltaTime = self.deltaTime + deltaTime
                }
                if(self.deltaTime >= self.actionInterval){
                    self.deltaTime = 0
                    self.actionInterval = generateRandomInterval()
                    self.blackHole?.stateMachine.enter(BreakState.self)
                }
    }
    
    func generateRandomInterval() -> Double {
        if let score = self.sceceReference().hudLayer?.score{
            if(score < 10){
                return NumbersUtil.randomDouble(min: 20, max: 25)
            }else if(score >= 10 && score < 15) {
                return NumbersUtil.randomDouble(min: 15, max: 20)
            }else if(score >= 15 && score < 20) {
                return NumbersUtil.randomDouble(min: 10, max: 15)
            }else if(score >= 20 && score < 25) {
                return NumbersUtil.randomDouble(min: 5, max: 10)
            }
            return NumbersUtil.randomDouble(min: 3, max: 5)
        }
        return NumbersUtil.randomDouble(min: 20, max: 25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
