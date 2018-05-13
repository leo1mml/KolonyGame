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
    
    var skView: SKView!
    var scene: GameScene!
    var logoNode: SKSpriteNode!
    var loadScene: SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        
        self.loadScene = SKScene(size: skView.frame.size)
        self.loadScene.backgroundColor = UIColor(red: 0.11, green: 0.10, blue: 0.21, alpha: 1.0)
        self.loadScene.scaleMode = .aspectFit
        self.logoNode = SKSpriteNode(imageNamed: "kolonyloading")
        self.logoNode.size = CGSize(width: skView.frame.size.width * 0.461333, height: skView.frame.size.height * 0.044977)
        self.logoNode.position = CGPoint(x: skView.frame.size.width/2, y: skView.frame.size.height/2)
        self.loadScene.addChild(logoNode)
        self.skView.presentScene(loadScene)
        
        self.scene = GameScene(size: skView.frame.size, stateClass: PlayingState.self)
        self.scene.launchDelegate = self
        self.scene.play()
        self.scene.scaleMode = .aspectFit
        self.scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.scene.physicsBody?.friction = 0.0
        self.scene.physicsBody?.linearDamping = 0.0
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

extension GameViewController: kolonyLaunch {
    func didlaunch() {
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let code = SKAction.run {
            self.logoNode.texture = SKTexture(imageNamed: "kolonyLoaded")
        }
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let wait = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([fadeOut, code, fadeIn, wait])
        
        loadScene.run(sequence){
            self.skView.presentScene(self.scene)
        }
        
    }
}
