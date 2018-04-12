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
    
}
