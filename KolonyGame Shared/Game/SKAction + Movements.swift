//
//  SKAction + Movements.swift
//  KolonyGame iOS
//
//  Created by Leonel Menezes on 18/04/2018.
//  Copyright © 2018 Leonel Menezes. All rights reserved.
//
import SpriteKit

extension SKAction {
    static func spiral(startRadius: CGFloat, endRadius: CGFloat, angle
        totalAngle: CGFloat, centerPoint: CGPoint, duration: TimeInterval) -> SKAction {
        
        // The distance the node will travel away from/towards the
        // center point, per revolution.
        let radiusPerRevolution = (endRadius - startRadius) / totalAngle
        
        let action = SKAction.customAction(withDuration: duration) { node, time in
            // The current angle the node is at.
            let θ = totalAngle * time / CGFloat(duration)
            
            // The equation, r = a + bθ
            let radius = startRadius + radiusPerRevolution * θ
            
            node.position = pointOnCircle(angle: θ, radius: radius, center: centerPoint)
        }
        
        return action
    }
    
    static func pointOnCircle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle),
                       y: center.y + radius * sin(angle))
    }
}
