//
//  HudLayer.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 09/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import UIKit

class HudLayer: SKNode {
    
    var size: CGSize?
    var entityManager : EntityManagerHudLayer?
    private var score = 0
    var scoreLabel: SKLabelNode?
    var scoreIcon: SimpleEntity?
    var gameOverSlogan: SimpleEntity?
    var newBestSprite: SimpleEntity?
    var highScoreLabel: SKLabelNode?
    var tapToLaunchAgainLabel: SKLabelNode?
    let HIGH_SCORE_KEY = "highScore"
    var originalPositionScoreLabel: CGPoint?
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.entityManager = EntityManagerHudLayer(hudLayer: self)
    }
    
    func setupLayer() {
        if let sizeLayer = self.size {
            self.scoreIcon = initializeEntity(textureImageName: "scoreicon", size: CGSize(width: sizeLayer.height * 0.07, height: sizeLayer.height * 0.03402), alpha: 1)
            self.gameOverSlogan = initializeEntity(textureImageName: "gameOverText", size: CGSize(width: sizeLayer.height * 0.4, height: (sizeLayer.height * 0.4) * 0.2), alpha: 0)
            self.tapToLaunchAgainLabel = initializeLabelNode(fontName: "Onramp", fontSize: 30, fontText: "TAP TO LAUCH AGAIN", alpha: 0, position: CGPoint(x: sizeLayer.width / 2, y: sizeLayer.height * 0.3), aligmentMode: .center)
            self.highScoreLabel = initializeLabelNode(fontName: "Onramp", fontSize: 44, fontText: "", alpha: 0, position: CGPoint(x: sizeLayer.width / 2, y: sizeLayer.height * 0.7), aligmentMode: .center)
           
            self.scoreLabel = initializeLabelNode(fontName: "Onramp", fontSize: 44, fontText: String(self.score), alpha: 1, position: CGPoint(x: (sizeLayer.width * 0.08) * 2  , y: sizeLayer.height * 0.95), aligmentMode: .left)
            self.originalPositionScoreLabel = self.scoreLabel?.position
            
            self.entityManager?.addAll([self.tapToLaunchAgainLabel!, self.highScoreLabel!, self.scoreLabel!])
            
            setupEntity(entity: scoreIcon!, position: CGPoint(x: sizeLayer.width * 0.08 , y: sizeLayer.height * 0.97), zPosition: nil)
            setupEntity(entity: gameOverSlogan!, position: centerPoint(), zPosition: nil)
    
            self.entityManager?.addAll(entities: [self.scoreIcon!, self.gameOverSlogan!])
        }
    }
    
    func initializeLabelNode (fontName: String, fontSize: CGFloat, fontText: String, alpha: CGFloat, position: CGPoint, aligmentMode: SKLabelHorizontalAlignmentMode) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: fontName)
        label.alpha = alpha
        label.fontSize = fontSize
        label.text = fontText
        label.position = position
        label.horizontalAlignmentMode = aligmentMode
        return label
    }
    
    
    func initializeEntity (textureImageName: String, size: CGSize, alpha: CGFloat) -> SimpleEntity {
        let entity = SimpleEntity(imageName: textureImageName, size: size)
        entity.spriteComponent?.node.alpha = alpha
        return entity
    }
    
    func startGameOverEffect () {

        self.updateHighScore()
        
        let sprite = (self.scoreIcon!.spriteComponent?.node)!
        var nextPos = CGPoint(x: (size?.width)! * 0.44, y: (size?.height)! * 0.8)
        
        self.moveToBlackHoleposition(node: sprite, duration: TimeInterval(0.7), durantionDecreaseAlpha: TimeInterval(0.7), nextPosition: nextPos, nextScale: 2)
        
        nextPos = CGPoint(x: (size?.width)! * 0.60, y: (size?.height)! * 0.77)
        moveScoreLabelToBlackHol(node: self.scoreLabel!, duration: TimeInterval(0.7), durantionDecreaseAlpha: TimeInterval(0.7), nextPosition: nextPos, nextScale: 1)
        
        
        
        
    }

    
    func centerPoint () -> CGPoint {
        return CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2)
    }
    
    
    
    func moveScoreLabelToBlackHol (node: SKLabelNode, duration: TimeInterval, durantionDecreaseAlpha: TimeInterval, nextPosition: CGPoint, nextScale: Float) {
        let sequence = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: durantionDecreaseAlpha)])
        self.scoreLabel?.run(sequence) {
            self.scoreLabel?.removeAllActions()
            self.scoreLabel?.fontSize = 44 * 1.5
            self.highScoreLabel?.text = "BEST: \(String(self.highScore()))"
            self.highScoreLabel?.run(SKAction.fadeIn(withDuration: 0.7))
            self.tapToLaunchAgainLabel?.run(SKAction.fadeIn(withDuration: 0.7)){
                self.sceceReference().gameLayer?.nextState = true
            }
            self.gameOverSlogan?.spriteComponent?.node.run(SKAction.fadeIn(withDuration: 0.7))
            self.reconfigureLabelNode(node, nextPosition, nextScale)
            
        }
    }
    
    func reconfigureLabelNode (_ node: SKLabelNode, _ nextPosition: CGPoint, _ scale: Float)  {
        let sequence = reconfigureActions(scale: scale, nextPosition: nextPosition)
        node.run(sequence) {
            node.removeAllActions()
        }
    }
    
    func updateHighScore () {
        let savedHighScore = UserDefaults.standard.object(forKey: HIGH_SCORE_KEY)
        if let highScore = savedHighScore as? Int {
            if highScore < self.score {
                save(highScoreValue: self.score)
            }
        } else {
            save(highScoreValue: self.score)
        }
    }
    
    func highScore() -> Int {
        let savedHighScore = UserDefaults.standard.object(forKey: HIGH_SCORE_KEY)
        if let highScore = savedHighScore as? Int {
            return highScore
        }
        return 0
    }
    

    func save (highScoreValue: Int) {
        UserDefaults.standard.set(highScoreValue, forKey: HIGH_SCORE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    
    private func moveToBlackHoleposition (node: SKSpriteNode, duration: TimeInterval, durantionDecreaseAlpha: TimeInterval, nextPosition: CGPoint, nextScale: Float) {
        
        node.zPosition = 50
        
        //move to black hole position, set scale 0 and remove of screen
        let sequence = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: durantionDecreaseAlpha)])
        
        //run sequence and remove all actions of node after actions
        node.run(sequence) {
            node.removeAllActions()
            self.reconfigureSprite(node, nextPosition, nextScale)
        }
    }
    
    
    func reconfigureSprite (_ node: SKSpriteNode, _ nextPosition: CGPoint, _ scale: Float) {
        let sequence = reconfigureActions(scale: scale, nextPosition: nextPosition)
        node.run(sequence) {
            node.removeAllActions()
        }
    }
    
    func reconfigureActions (scale: Float, nextPosition: CGPoint) -> SKAction {
        let sequence = SKAction.sequence([SKAction.move(to: nextPosition, duration: TimeInterval(0.1)), SKAction.scale(by: CGFloat(scale), duration: TimeInterval(0.1)), SKAction.fadeAlpha(by: 1, duration: TimeInterval(0.5))])
        
        return sequence
    }
    
    private func sceceReference () ->  GameScene! {
        if let parent = self.parent as? GameScene {
            return parent
        }
        return nil
    }
    
    func resetupHudLayer () {
        
        self.score = 0
        self.scoreLabel?.text = String(self.score)
        self.scoreIcon?.spriteComponent?.node.run(SKAction.fadeOut(withDuration: TimeInterval(1))){
            self.highScoreLabel?.removeAllActions()
        }
        
        self.scoreLabel?.run(SKAction.fadeOut(withDuration: TimeInterval(1)))
        self.gameOverSlogan?.spriteComponent?.node.run(SKAction.fadeOut(withDuration: TimeInterval(1))){
            self.gameOverSlogan?.spriteComponent?.node.removeAllActions()
        }
        self.highScoreLabel?.run(SKAction.fadeOut(withDuration: TimeInterval(1))){
            self.highScoreLabel?.removeAllActions()
        }
        self.tapToLaunchAgainLabel?.run(SKAction.fadeOut(withDuration: TimeInterval(1))) {
            self.tapToLaunchAgainLabel?.removeAllActions()
            
            self.resetupScore()
        }
    }
    
    private func resetupScore() {
        
        let scoreIconPosition =  CGPoint(x: self.size!.width * 0.08 , y: self.size!.height * 0.97)
        let scoreLabelPosition = self.originalPositionScoreLabel!
        self.scoreIcon?.spriteComponent?.node.setScale(1)
        self.scoreIcon?.spriteComponent?.node.run(SKAction.sequence([SKAction.move(to: scoreIconPosition, duration: TimeInterval(1)), SKAction.fadeIn(withDuration: TimeInterval(1))])) {
            self.scoreIcon?.spriteComponent?.node.removeAllActions()
        }
        
        self.scoreLabel?.fontSize = 44
        self.scoreLabel?.run(SKAction.sequence([SKAction.fadeOut(withDuration: TimeInterval(1)), SKAction.move(to: scoreLabelPosition, duration: TimeInterval(0.5)), SKAction.fadeIn(withDuration: TimeInterval(0.5))])) {
            self.scoreLabel?.removeAllActions()
        }
        
        
   
    }
    
    //configure some properties of a gkEntity
    func setupEntity<T: GKEntity>(entity: T, position: CGPoint, zPosition: CGFloat?) {
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            if let zPosition = zPosition {
                spriteComponent.node.zPosition = zPosition
            }
        }
    }
    
    func incrementScore() {
        
        self.scoreIcon?.spriteComponent?.node.run(SKAction.sequence([SKAction.scale(to: 1.3, duration: TimeInterval(0.25)), SKAction.scale(to: 1, duration: TimeInterval(0.25))])){
            self.scoreIcon?.spriteComponent?.node.removeAllActions()
        }
        self.scoreLabel?.run(SKAction.sequence([SKAction.scale(to: 1.3, duration: TimeInterval(0.25)), SKAction.scale(to: 1, duration: TimeInterval(0.25))])) {
            self.scoreLabel?.removeAllActions()
        }
        self.score += 1
        if let score = self.scoreLabel {
            score.text = String(self.score)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


