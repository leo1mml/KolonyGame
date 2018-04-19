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
    
    var hasBeganToPlay = false
    var backgroundMusic1: AVAudioPlayer?
    var backgroundMusic2: AVAudioPlayer?
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        PlayingState(scene: self),
        GameOverState(scene: self)
        ])
    
    init(size: CGSize, stateClass: AnyClass) {
        
        initialState = stateClass
        
        self.gameLayer = GameLayer(size: size)
        self.backgroundLayer = BackgroundLayer(size: size)
        self.hudLayer = HudLayer(size: size)
        self.gameLayer?.zPosition = 0
        self.hudLayer?.zPosition = 5
        super.init(size: size)
        
        self.playSound()
        
        self.setup(backgroundLayer: backgroundLayer!)
        self.physicsWorld.contactDelegate = self
        self.addLayers()
        
        let shakeBackground = self.shakeCamera(layer: self.backgroundLayer!, duration: 10)
        let shakeGameLayer = self.shakeCamera(layer: self.gameLayer!, duration: 10)
        let shakeHudLayer = self.shakeCamera(layer: self.hudLayer!, duration: 10)
        
        self.gameLayer?.run(shakeGameLayer)
        self.hudLayer?.run(shakeHudLayer)
        self.backgroundLayer?.run (shakeBackground)
        
    }
    
    func incrementScore() {
        if let hud = self.hudLayer {
            hud.incrementScore()
        }
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
    
    func playSound() {
        if !self.hasBeganToPlay {
            do{
                self.backgroundMusic1 =  try AVAudioPlayer(contentsOf:URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundSound1", ofType: "wav")!))
                self.backgroundMusic1?.numberOfLoops = -1
                self.backgroundMusic1?.play()
                
                self.backgroundMusic2 =  try AVAudioPlayer(contentsOf:URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundSound2", ofType: "mp3")!))
                self.backgroundMusic2?.numberOfLoops = -1
                self.backgroundMusic2?.play()
                
                
                self.hasBeganToPlay = true
            }catch{
                print(error)
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

