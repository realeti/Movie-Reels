//
//  GradientButton.swift
//  Movie-Reels
//
//  Created by Apple M1 on 22.02.2024.
//

import UIKit

enum GradientColorStyle {
    case darkOrange
    
    var color: [UIColor] {
        switch self {
        case .darkOrange:
            let color1 = UIColor(red: 179.0, green: 48.0, blue: 6.0)
            let color2 = UIColor(red: 220.0, green: 87.0, blue: 20.0)
            let color3 = UIColor(red: 236.0, green: 104.0, blue: 27.0)
            
            return [color1, color2, color3]
        }
    }
}

class GradientButton: UIButton {
    private var gradientLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer?.frame = bounds
    }
    
    func addGradient(colorStyle: GradientColorStyle) {
        gradientLayer?.removeFromSuperlayer()
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.type = .axial
        gradientLayer?.frame = bounds
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        switch colorStyle {
        case .darkOrange:
            gradientLayer?.colors = colorStyle.color.map { $0.cgColor }
            gradientLayer?.locations = [0.0, 0.65, 1.0]
        }
        
        guard let gradientLayer else { return }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
