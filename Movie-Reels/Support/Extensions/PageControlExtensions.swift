//
//  PageControlExtensions.swift
//  Movie-Reels
//
//  Created by Apple M1 on 13.05.2024.
//

import UIKit

extension UIPageControl {
    var isInteracting: Bool {
        let longPress = gestureRecognizers?.first {$0 is UILongPressGestureRecognizer}
        let state = longPress?.state
        return state == .changed
    }
}
