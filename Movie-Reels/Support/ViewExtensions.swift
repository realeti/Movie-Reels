//
//  ViewExtensions.swift
//  Movie-Reels
//
//  Created by Apple M1 on 21.02.2024.
//

import UIKit

enum GradientTypes {
    case darkOrange
}

extension UIView {
    func addGradient(colorStyle: GradientTypes) {
        let gradient = CAGradientLayer()
        
        gradient.type = .axial
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        switch colorStyle {
        case .darkOrange:
            gradient.colors = darkOrangeColors()
            gradient.locations = [0.0, 0.65, 1.0]
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func darkOrangeColors() -> [CGColor] {        
        let color1 = UIColor(red: 179.0, green: 48.0, blue: 6.0).cgColor
        let color2 = UIColor(red: 220.0, green: 87.0, blue: 20.0).cgColor
        let color3 = UIColor(red: 236.0, green: 104.0, blue: 27.0).cgColor
        
        return [color1, color2, color3]
    }
}
