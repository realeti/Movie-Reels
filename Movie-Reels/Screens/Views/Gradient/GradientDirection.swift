//
//  GradientDirection.swift
//  Movie-Reels
//
//  Created by Apple M1 on 28.02.2024.
//

import UIKit

enum GradientDirection {
    case top
    case left
    case right
    case bottom
    
    var directionType: (startPoint: CGPoint, endPoint: CGPoint) {
        switch self {
        case .top:
            return (startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        case .left:
            return (startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        case .right:
            return (startPoint: CGPoint(x: 1.0, y: 0.5), endPoint: CGPoint(x: 0.0, y: 0.5))
        case .bottom:
            return (startPoint: CGPoint(x: 0.5, y: 1.0), endPoint: CGPoint(x: 0.5, y: 0.0))
        }
    }
}
