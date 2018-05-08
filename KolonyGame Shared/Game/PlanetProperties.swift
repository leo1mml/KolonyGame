//
//  PlanetProperties.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 06/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import SpriteKit

enum PlanetProperties {
    case red
    case blue
    case yellow
    case green
    
    private static var allValues = [red, blue, green, yellow]
    
    var texture: SKTexture {
        
        switch self {
        case .red:
            return SKTexture(imageNamed: "planetred")
        case .blue:
            return SKTexture(imageNamed: "planetblue")
        case .green:
            return SKTexture(imageNamed: "planetgreen")
        case .yellow:
            return SKTexture(imageNamed: "planetyellow")
        }
        
    }
    
    var type: String {
        switch self {
        case .red:
            return "red"
        case .blue:
            return "blue"
        case .green:
            return "green"
        case .yellow:
            return "yellow"
        }
    }
    
    var flagAction: SKAction {
        var textures = [SKTexture]()
        
        for i in 0...14 {
            
            let texture = SKTexture(imageNamed: self.type+"Flag_\(i)")
            textures.append(texture)
            
        }
        
        let disappear = SKAction.animate(with: textures, timePerFrame: 0.05)
        let animation = SKAction.animate(with: textures, timePerFrame: 0.1)
        let appear = SKAction.reversed(animation)
        
        let wait = SKAction.wait(forDuration: 1)
        
        return SKAction.sequence([appear(), wait, disappear])
    }
    
}
