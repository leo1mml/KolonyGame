//
//  GameViewController.swift
//  KolonyGame tvOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present the scene
        let skView = self.view as! SKView
        scene = GameScene(size: skView.frame.size, stateClass: PlayingState.self)
        
        skView.ignoresSiblingOrder = true
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = true
        
        scene?.scaleMode = .aspectFit
        
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        scene?.physicsBody?.friction = 0.0
        scene?.physicsBody?.linearDamping = 0.0
        
        skView.presentScene(scene)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        for press in presses {
            if press.type == .select {
                scene?.pressesBegan(presses, with: event)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
