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
    var highScoreLabel: SKLabelNode?
    
    let HIGH_SCORE_KEY = "highScore"
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.entityManager = EntityManagerHudLayer(hudLayer: self)
    }
    
    func setupLayer() {
        
        if let sizeLayer = self.size {
            
            //creating score icon
            let size = CGSize(width: sizeLayer.height * 0.07, height: sizeLayer.height * 0.03402)
            self.scoreIcon = SimpleEntity(imageName: "scoreicon", size: size)
            
            let width = sizeLayer.height * 0.4
            let sizeSlogan = CGSize(width: width, height: width * 0.2)
            
            self.gameOverSlogan = SimpleEntity(imageName: "gameOverText", size: sizeSlogan)
            self.gameOverSlogan?.spriteComponent?.node.alpha = 0
            
            //creating score label
            self.highScoreLabel = SKLabelNode(fontNamed: "Onramp")
            configure(label: self.highScoreLabel, fontSize: 44, text: "BEST: \(String(highScore()))", position: CGPoint(x: sizeLayer.width / 2, y: sizeLayer.height * 0.7))
            self.highScoreLabel?.alpha = 0
            self.entityManager?.add(self.highScoreLabel!)
            
            
            self.scoreLabel = SKLabelNode(fontNamed: "Onramp")
            if let score = self.scoreLabel {
                score.fontSize = 44
                score.text = String(self.score)
                score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            }
            
            
            setupEntity(entity: scoreIcon!, position: CGPoint(x: sizeLayer.width * 0.08 , y: sizeLayer.height * 0.97), zPosition: nil)
            setupEntity(entity: gameOverSlogan!, position: centerPoint(), zPosition: nil)
            
            if let spriteScoreIcon = scoreIcon?.spriteComponent {
                if let score = self.scoreLabel {
                    score.position = CGPoint(x: spriteScoreIcon.node.position.x + 30 , y: spriteScoreIcon.node.position.y - (spriteScoreIcon.node.size.height / 2  + 1) )
                    self.entityManager?.add(score)
                }
            }
            
            
            self.entityManager?.add(scoreIcon!)
            self.entityManager?.add(gameOverSlogan!)
            
        }
    }
    
    
    
    
    func startGameOverEffect () {

        self.updateHighScore()
        
        let sprite = (self.scoreIcon!.spriteComponent?.node)!
        var nextPos = CGPoint(x: (size?.width)! * 0.44, y: (size?.height)! * 0.8)
        
        self.moveToBlackHoleposition(node: sprite, duration: TimeInterval(1), durantionDecreaseAlpha: TimeInterval(1), nextPosition: nextPos, nextScale: 2)
        nextPos = CGPoint(x: (size?.width)! * 0.60, y: (size?.height)! * 0.77)
        
        self.scoreLabel?.fontSize = 44 * 1.5
        moveScoreLabelToBlackHol(node: self.scoreLabel!, duration: TimeInterval(1), durantionDecreaseAlpha: TimeInterval(1), nextPosition: nextPos, nextScale: 1)
        
        
        
        
    }
    
    func configure(label: SKLabelNode?, fontSize: CGFloat, text: String, position: CGPoint) {
        label?.fontSize = fontSize
        label?.text = text
        label?.position = position
    }
    
    func centerPoint () -> CGPoint {
        return CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2)
    }
    
    
    
    func moveScoreLabelToBlackHol (node: SKLabelNode, duration: TimeInterval, durantionDecreaseAlpha: TimeInterval, nextPosition: CGPoint, nextScale: Float) {
        let sequence = SKAction.sequence([SKAction.move(to: centerPoint(), duration: duration), SKAction.fadeAlpha(to: 0, duration: durantionDecreaseAlpha)])
        self.scoreLabel?.run(sequence) {
            self.scoreLabel?.removeAllActions()
            
            self.highScoreLabel?.run(SKAction.fadeIn(withDuration: 1))
            self.gameOverSlogan?.spriteComponent?.node.run(SKAction.fadeIn(withDuration: 1))
            
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
        let sequence = SKAction.sequence([SKAction.move(to: CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2), duration: duration), SKAction.fadeAlpha(to: 0, duration: durantionDecreaseAlpha)])
        
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
        self.score += 1
        if let score = self.scoreLabel {
            score.text = String(self.score)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


