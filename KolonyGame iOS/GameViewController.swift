//
//  GameViewController.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 09/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Present the scene
        let skView = self.view as! SKView
        let scene = GameScene(size: skView.frame.size, stateClass: PlayingState.self)
        
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = true
//        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFit
        
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        scene.physicsBody?.friction = 0.0
        scene.physicsBody?.linearDamping = 0.0
        
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
