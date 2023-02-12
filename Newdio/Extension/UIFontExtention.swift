//
//  UIFontExtention.swift
//  Newdio
//
//  Created by najin on 2021/11/03.
//

import Foundation
import UIKit

extension UIFont {
    
    ///반응형 Font
    static func dynamicFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let fontSize = size * widthAdjust
        return  UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}
