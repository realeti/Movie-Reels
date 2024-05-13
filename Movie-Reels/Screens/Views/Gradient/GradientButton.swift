//
//  GradientButton.swift
//  Movie-Reels
//
//  Created by Apple M1 on 22.02.2024.
//

import UIKit

class GradientButton: UIButton {
    private var gradientLayer: CAGradientLayer?
    private var originalTextColor: UIColor?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = self.bounds
    }
    
    func addGradient(colorStyle: GradientColorStyle, direction: GradientDirection) {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.type = .axial
        gradientLayer?.colors = colorStyle.colors.map { $0 }
        gradientLayer?.locations = colorStyle.locations
        gradientLayer?.startPoint = direction.directionType.startPoint
        gradientLayer?.endPoint = direction.directionType.endPoint
        
        guard let gradientLayer else { return }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        setNeedsLayout()
    }
}
