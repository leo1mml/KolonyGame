//
//  GameScene.swift
//  KolonyGame Shared
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gameLayer: GameLayer?
    let backgroundLayer: BackgroundLayer?
    let hudLayer: HudLayer?
    
    var initialState: AnyClass
    
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    var backgroundMusic1: AVAudioPlayer?
    var backgroundMusic2: AVAudioPlayer?
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        PlayingState(scene: self),
        GameOverState(scene: self),
        RetryState(scene: self)
        ])
    
    init(size: CGSize, stateClass: AnyClass) {
        
        initialState = stateClass
        
        self.gameLayer = GameLayer(size: size)
        self.backgroundLayer = BackgroundLayer(size: size)
        self.hudLayer = HudLayer(size: size)
        self.gameLayer?.zPosition = 0
        self.hudLayer?.zPosition = 5
        super.init(size: size)
        prepareBackgroundSound()
        
        self.setup(backgroundLayer: backgroundLayer!)
        self.physicsWorld.contactDelegate = self
        self.addLayers()

    }
    
    func initializingGamePlay() {
        self.gameLayer?.fadeInBlackHoleAndPlanets()
        self.hudLayer?.initialize()
    }

    
    func shakeScene(duration: Float, finished: @escaping () -> Void) {
        let shakeBackground = self.shakeCamera(layer: self.backgroundLayer!, duration: duration)
        let shakeGameLayer = self.shakeCamera(layer: self.gameLayer!, duration: duration)
        let shakeHudLayer = self.shakeCamera(layer: self.hudLayer!, duration: duration)
        
        self.gameLayer?.run(shakeGameLayer)
        self.hudLayer?.run(shakeHudLayer)
        self.backgroundLayer?.run (shakeBackground) {
            DispatchQueue.main.async {
                finished()
            }
            
        }
    }
    
    func incrementScore() {
        if let hud = self.hudLayer {
            hud.incrementScore()
        }
    }
    
    func changeState(state: AnyClass) {
        self.stateMachine.enter(state)
    }
    
    func setup (backgroundLayer: BackgroundLayer) {
        self.backgroundLayer?.zPosition = -15
        self.backgroundLayer?.position = CGPoint(x: (self.scene?.size.width)! / 2, y: (self.scene?.size.height)! / 2)
    }
    
    func addLayers() {
        self.addChild(self.backgroundLayer!)
        self.addChild(self.gameLayer!)
        self.addChild(self.hudLayer!)
    }
    
    override func didMove(to view: SKView) {
        stateMachine.enter(initialState)
        self.backgroundColor = .clear
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        self.gameLayer?.update(deltaTime: currentTime)
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        stateMachine.update(deltaTime: deltaTime)
        gameLayer?.update(deltaTime: deltaTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        gameLayer?.didBegin(contact)
    }
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameLayer?.touchesBegan(touches, with: event)
    }
    #endif
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.type == .select {
                gameLayer?.pressesBegan(presses, with: event)
            }
        }
    }
    
    func prepareBackgroundSound() {
        do{
            self.backgroundMusic1 =  try AVAudioPlayer(contentsOf:URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundSound1", ofType: "mp3")!))
            self.backgroundMusic1?.numberOfLoops = -1
        }catch{
            print(error)
        }
        
        do{
            self.backgroundMusic2 =  try AVAudioPlayer(contentsOf:URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundSound2", ofType: "mp3")!))
            self.backgroundMusic2?.numberOfLoops = -1
        }catch{
            print(error)
        }
    }
    
    func playBackgroundSound() {
        self.backgroundMusic1?.play()
        self.backgroundMusic2?.play()
    }
    
    func stopBackgroundSound() {
        self.backgroundMusic1?.stop()
        self.backgroundMusic2?.stop()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

