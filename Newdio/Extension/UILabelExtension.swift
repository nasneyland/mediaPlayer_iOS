//
//  UILabelExtension.swift
//  Newdio
//
//  Created by najin on 2022/01/03.
//

import Foundation
import UIKit

extension UILabel {
    func targetColored(targetString: String) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.newdioMain, range: range)
        
        self.attributedText = attributedString
    }
}
