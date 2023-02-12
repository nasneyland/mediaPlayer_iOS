//
//  LabelExtension.swift
//  Newdio
//
//  Created by najin on 2022/01/03.
//

import Foundation
import UIKit

extension UILabel {
    
    // 특정 부분만 색상 넣기
    func targetColored(targetString: String) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.newdioMain, range: range)
        
        self.attributedText = attributedString
    }
}
