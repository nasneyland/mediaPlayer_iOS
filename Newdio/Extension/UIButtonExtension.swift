//
//  UIButtonExtension.swift
//  Newdio
//
//  Created by najin on 2021/12/16.
//

import Foundation
import UIKit

extension UIButton {
    
    func marginImageWithText(margin: CGFloat) {
        let halfSize = margin / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -halfSize, bottom: 0, right: halfSize)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: halfSize, bottom: 0, right: -halfSize)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: halfSize, bottom: 0, right: halfSize)
    }
}
