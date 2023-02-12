//
//  FontExtention.swift
//  Newdio
//
//  Created by najin on 2021/11/03.
//

import Foundation
import UIKit

extension UIFont {
    
    /// 기기 너비에 따른 반응형 Font
    static func dynamicFont(size: CGFloat, weight: UIFont.Weight) {
        let fontSize = size * widthAdjust
        self.systemFont(ofSize: fontSize, weight: weight)
    }
    
    /// 커스텀 텍스트 크기 설정
    static func customFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let textSize =  CacheManager.getTextSize()
        var customSize = size
        
        if textSize ==  TextSize.small.rawValue{
            if customSize < 11 {
                customSize = 10
            } else {
                customSize = customSize - 2
            }
        } else if textSize == TextSize.large.rawValue {
            customSize = customSize + 3
        }
        
        return systemFont(ofSize: customSize, weight: weight)
    }
}
