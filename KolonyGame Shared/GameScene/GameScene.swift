//
//  GameScene.swift
//  KolonyGame Shared
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gameLayer: GameLayer?
    let backgroundLayer: BackgroundLayer?
    
    var initialState: AnyClass
    
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        PlayingState(scene: self),
        GameOverState(scene: self)
        ])
    
    init(size: CGSize, stateClass: AnyClass) {
        
        initialState = stateClass
        gameLayer = GameLayer(size: size)
        backgroundLayer = BackgroundLayer(size: size)
        self.gameLayer?.zPosition = 0
        super.init(size: size)
        self.setup(backgroundLayer: backgroundLayer!)
        self.physicsWorld.contactDelegate = self
        self.addLayers()
    }
    
    
    func setup (backgroundLayer: BackgroundLayer) {
        let x = self.scene?.size.width
        let y = self.scene?.size.height
        self.backgroundLayer?.zPosition = -1
        self.backgroundLayer?.position = CGPoint(x: x! / 2, y: y! / 2)
    }
    
    func addLayers() {
        self.addChild(self.backgroundLayer!)
        self.addChild(self.gameLayer!)
    }
    
    override func didMove(to view: SKView) {
        stateMachine.enter(initialState)
        self.backgroundColor = .clear
        
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        stateMachine.update(deltaTime: deltaTime)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        gameLayer?.didBegin(contact)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameLayer?.touchesBegan(touches, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

