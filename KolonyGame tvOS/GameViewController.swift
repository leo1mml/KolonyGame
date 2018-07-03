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
    
    var skView: SKView!
    var scene: GameScene!
    var logoNode: SKSpriteNode!
    var loadScene: SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        
        loadKolony()
    }
    
    func loadKolony() {
        createLoadingScene()
        self.skView.presentScene(loadScene)
        
        self.scene = GameScene(size: skView.frame.size, stateClass: PlayingState.self)
        self.scene.launchDelegate = self
        self.scene.play()
        self.scene.scaleMode = .aspectFit
        self.scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.scene.physicsBody?.friction = 0.0
        self.scene.physicsBody?.linearDamping = 0.0
    }
    
    func createLoadingScene() {
        self.loadScene = SKScene(size: skView.frame.size)
        self.loadScene.backgroundColor = UIColor(red: 0.11, green: 0.10, blue: 0.21, alpha: 1.0)
        self.loadScene.scaleMode = .aspectFit
        self.logoNode = SKSpriteNode(imageNamed: "kolonyloading")
        let logoWidth = skView.frame.size.width * 0.461333
        let logoHeight = logoWidth / 6
        self.logoNode.size = CGSize(width: logoWidth, height: logoHeight)
        self.logoNode.position = CGPoint(x: skView.frame.size.width/2, y: skView.frame.size.height/2)
        self.loadScene.addChild(logoNode)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        for press in presses {
            if press.type == .select {
                scene?.pressesBegan(presses, with: event)
            }
            
            if press.type == .menu {
                if (scene.tapToLaunch) {
                    super.pressesBegan(presses, with: event)
                } else {
                    loadKolony()
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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
