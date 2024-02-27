//
//  GradientColorStyle.swift
//  Movie-Reels
//
//  Created by Apple M1 on 27.02.2024.
//

import UIKit

enum GradientColorStyle {
    case darkOrange
    case nightTransition
    
    var color: [UIColor] {
        switch self {
        case .darkOrange:
            let color1 = UIColor(red: 179.0, green: 48.0, blue: 6.0)
            let color2 = UIColor(red: 220.0, green: 87.0, blue: 20.0)
            let color3 = UIColor(red: 236.0, green: 104.0, blue: 27.0)
            
            return [color1, color2, color3]
        case .nightTransition:
            let color1 = UIColor(resource: .night)
            let color2 = UIColor.clear
            
            return [color1, color2]
        }
    }
    
    var locations: [NSNumber] {
        switch self {
        case .darkOrange:
            let locations: [NSNumber] = [0.0, 0.65, 1.0]
            return locations
        case .nightTransition:
            let locations: [NSNumber] = [0.0, 1.0]
            return locations
        }
    }
}
