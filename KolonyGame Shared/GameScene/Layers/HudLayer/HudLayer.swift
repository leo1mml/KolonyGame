//
//  HudLayer.swift
//  KolonyGame iOS
//
//  Created by Isaias Fernandes on 09/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit
import GameplayKit

class HudLayer: SKNode {
    
    var size: CGSize?
    var entityManager : EntityManagerHudLayer?
    private var score = 0
    var scoreLabel: SKLabelNode?
    var scoreIcon: ScoreIconEntity?
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.entityManager = EntityManagerHudLayer(hudLayer: self)
    }
    
    func setupLayer() {
        
        if let sizeLayer = self.size {
            
            //creating score icon
            let size = CGSize(width: sizeLayer.height * 0.07, height: sizeLayer.height * 0.03402)
            self.scoreIcon = ScoreIconEntity(imageName: "scoreicon", size: size)
            
            //creating score label
            self.scoreLabel = SKLabelNode(fontNamed: "Onramp")
            if let score = self.scoreLabel {
                score.fontSize = 44
                score.text = String(self.score)
                score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            }
            
            
            setupEntity(entity: scoreIcon!, position: CGPoint(x: sizeLayer.width * 0.08 , y: sizeLayer.height * 0.97), zPosition: nil)
            if let spriteScoreIcon = scoreIcon?.spriteComponent {
                if let score = self.scoreLabel {
                    score.position = CGPoint(x: spriteScoreIcon.node.position.x + 30 , y: spriteScoreIcon.node.position.y - (spriteScoreIcon.node.size.height / 2  + 1)  )
                    self.entityManager?.add(score)
                }
            }
            
            
            self.entityManager?.add(scoreIcon!)
            
        }
    }
    
    func startGameOverEffect () {
        self.moveToBlackHoleposition(node: (self.scoreIcon!.spriteComponent?.node)!, duration: TimeInterval(1), durantionDecreaseScale: TimeInterval(1))
        let sequence = SKAction.sequence([SKAction.move(to: CGPoint.zero, duration: TimeInterval(1)), SKAction.scale(to: 0, duration: TimeInterval(1)), SKAction.removeFromParent()])
        self.scoreLabel?.run(sequence) {
            self.scoreLabel?.removeAllActions()
        }
    }
    
    
    
    private func moveToBlackHoleposition (node: SKSpriteNode, duration: TimeInterval, durantionDecreaseScale: TimeInterval) {
        
        node.zPosition = 50
        
        //move to black hole position, set scale 0 and remove of screen
        let sequence = SKAction.sequence([SKAction.move(to: CGPoint(x: (self.size?.width)! / 2 , y: (self.size?.height)! / 2), duration: duration), SKAction.scale(to: 0, duration: durantionDecreaseScale), SKAction.removeFromParent()])
        
        //run sequence and remove all actions of node after actions
        node.run(sequence) {
            node.removeAllActions()
        }
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


