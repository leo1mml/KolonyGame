//
//  GameColors.swift
//  KolonyGame
//
//  Created by Isaias Fernandes on 04/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//

//
//  ColorsEnum.swift
//  Main
//
//  Created by Jonas de Castro Leitao on 14/11/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit

/*Cores Hexadecimal
 Estrelas: Red: E92663 , Yellow: FFD740 , Green: 42BD41 , Blue: 0191EA
 Planetas: Random: F52757 , 1CE9B6 , FF6F00 , D53BF9*/

enum GameColors {
    case yellow
    case red
    case blue
    case green
    
    private static let allValues = [yellow, red, blue, green]

    
    var color: UIColor {
        switch self {
        case .yellow:
            return UIColor(colorWithHexValue: 0xFFD740)
        case .blue:
            return UIColor(colorWithHexValue: 0x0191EA)
        case .green:
            return UIColor(colorWithHexValue: 0x42BD41)
        case .red:
            return UIColor(colorWithHexValue: 0xE92663)
        }
    }
    
    static func ramdomColor () -> UIColor {
        let ramdomIndex = arc4random_uniform(4)
        return GameColors.allValues[Int(ramdomIndex)].color
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

