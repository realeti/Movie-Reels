//
//  ColorExtensions.swift
//  Movie-Reels
//
//  Created by Apple M1 on 21.02.2024.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    convenience init(rgbHex: UInt) {
        self.init(red: CGFloat((rgbHex & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbHex & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbHex & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
