//
//  PhysicsCategory.swift
//  KolonyGame
//
//  Created by Augusto on 13/03/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let GreenPlanet: UInt32 = 0
    static let BluePlanet: UInt32 = 0b1
    static let YellowPlanet: UInt32 = 0b10
    static let RedPlanet: UInt32 = 0b100
    static let GreenRocket: UInt32 = 0b1000
    static let BlueRocket: UInt32 = 0b10000
    static let YellowRocket: UInt32 = 0b100000
    static let RedRocket: UInt32 = 0b1000000
    static let Obstacle: UInt32 = 0b10000000
    static let BlackHole: UInt32 = 0b100000000
}
