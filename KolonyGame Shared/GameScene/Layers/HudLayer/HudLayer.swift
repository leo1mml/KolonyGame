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
    
    
    init(size: CGSize) {
        super.init()
        self.size = size
        self.entityManager = EntityManagerHudLayer(hudLayer: self)
    }
    
    func setupLayer() {
        
        if let sizeLayer = self.size {
            
            //creating score icon
            let size = CGSize(width: sizeLayer.height * 0.07, height: sizeLayer.height * 0.03402)
            let scoreIcon = ScoreIconEntity(imageName: "scoreicon", size: size)
            
            //creating score label
            self.scoreLabel = SKLabelNode(fontNamed: "Onramp")
            if let score = self.scoreLabel {
                score.fontSize = 44
                score.text = String(self.score)
                score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            }
            
            
            setupEntity(entity: scoreIcon, position: CGPoint(x: sizeLayer.width * 0.08 , y: sizeLayer.height * 0.97), zPosition: nil)
            if let spriteScoreIcon = scoreIcon.spriteComponent {
                if let score = self.scoreLabel {
                    score.position = CGPoint(x: spriteScoreIcon.node.position.x + 30 , y: spriteScoreIcon.node.position.y - (spriteScoreIcon.node.size.height / 2  + 1)  )
                    self.entityManager?.add(score)
                }
            }
            
            
            self.entityManager?.add(scoreIcon)
            
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
        self.score += 1
        if let score = self.scoreLabel {
            score.text = String(self.score)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


