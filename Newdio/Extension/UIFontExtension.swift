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
    
    ///커스텀 텍스트 크기 설정
    static func customFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        if let text = UserDefaults.standard.string(forKey: "text") {
            var fontSize = size
            
            if text == TextType.small.rawValue {
                if fontSize < 11 {
                    fontSize = 10
                } else {
                    fontSize = fontSize - 2
                }
            } else if text == TextType.large.rawValue {
                fontSize = fontSize + 3
            }
            
            return UIFont.systemFont(ofSize: fontSize, weight: weight)
        } else {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
}
