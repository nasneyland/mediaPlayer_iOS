//
//  ButtonExtension.swift
//  Newdio
//
//  Created by najin on 2021/12/16.
//

import Foundation
import UIKit

extension UIButton {
    
    /// button 이미지와 타이틀 사이의 간격 조절
    func marginImageWithText(margin: CGFloat) {
        let halfSize = margin / 2
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -halfSize, bottom: 0, right: halfSize)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: halfSize, bottom: 0, right: -halfSize)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: halfSize, bottom: 0, right: halfSize)
    }
}
