//
//  ImageExtensions.swift
//  Movie-Reels
//
//  Created by Apple M1 on 24.04.2024.
//

import UIKit

extension UIImage {
    static func generateGradientIcon(for iconImage: UIImage, colorStyle: GradientColorStyle, direction: GradientDirection) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: iconImage.size.width, height: iconImage.size.height)
        gradientLayer.colors = colorStyle.colors.map { $0 }
        gradientLayer.locations = colorStyle.locations
        gradientLayer.startPoint = direction.directionType.startPoint
        gradientLayer.endPoint = direction.directionType.startPoint

        let maskLayer = CALayer()
        maskLayer.contents = iconImage.cgImage
        maskLayer.frame = gradientLayer.bounds

        gradientLayer.mask = maskLayer

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        gradientLayer.render(in: context)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return gradientImage?.withRenderingMode(.alwaysOriginal)
    }
}
