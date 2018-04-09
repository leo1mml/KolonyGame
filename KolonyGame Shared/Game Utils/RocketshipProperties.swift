//
//  RocketshipProperties.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 06/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//
import SpriteKit

enum RocketType {
    case yellow
    case red
    case blue
    case green
    
    private static let allValues = [yellow, red, blue, green]
    
    var texture: SKTexture {
        switch self {
        case .yellow:
            return SKTexture(imageNamed: "rocketyellow")
        case .red:
            return SKTexture(imageNamed: "rocketred")
        case .green:
            return SKTexture(imageNamed: "rocketgreen")
        case .blue:
            return SKTexture(imageNamed: "rocketblue")
        }
    }
    
    var type: String {
        switch self {
        case .yellow:
            return "yellow"
        case .red:
            return "red"
        case .green:
            return "green"
        case .blue:
            return "blue"
        }
    }
    
    static func generateRandomShipProperties() -> RocketType {
        return RocketType.allValues[Int(arc4random_uniform(4))]
    }
}
