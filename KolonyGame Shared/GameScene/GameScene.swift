//
//  GameScene.swift
//  KolonyGame Shared
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
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
        
        self.gameLayer = GameLayer(size: size)
        self.backgroundLayer = BackgroundLayer(size: size)
        
        super.init(size: size)
        self.setup(backgroundLayer: backgroundLayer!)
        
        self.addLayers()
    }
    
    
    func setup (backgroundLayer: BackgroundLayer) {
        self.backgroundLayer?.zPosition = -1
        self.backgroundLayer?.position = CGPoint(x: (self.scene?.size.width)! / 2, y: (self.scene?.size.height)! / 2)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

