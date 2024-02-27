//
//  GradientImageView.swift
//  Movie-Reels
//
//  Created by Apple M1 on 27.02.2024.
//

import UIKit

class GradientImageView: UIImageView {
    private var gradientLayer: CAGradientLayer?
    var gradientHeight: CGFloat = 4.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = CGRect(x: 0, y: self.bounds.maxY - gradientHeight, width: self.bounds.maxX, height: gradientHeight)
    }
    
    func addGradient(colorStyle: GradientColorStyle, direction: GradientDirection) {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.type = .axial
        gradientLayer?.colors = colorStyle.color.map { $0.cgColor }
        gradientLayer?.locations = colorStyle.locations
        gradientLayer?.startPoint = direction.directionType.startPoint
        gradientLayer?.endPoint = direction.directionType.endPoint
        
        guard let gradientLayer else { return }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        setNeedsLayout()
    }
}
