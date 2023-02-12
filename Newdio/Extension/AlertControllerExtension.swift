//
//  AlertControllerExtension.swift
//  Newdio
//
//  Created by najin on 2022/01/03.
//

import Foundation
import UIKit

extension UIAlertController {
    
    /// AlertController Custom 초기화
    convenience init(title: String, message: String, style: UIAlertController.Style) {
        self.init(title: title, message: message, preferredStyle: style)
        
        self.setMessage(color: .newdioGray1)
    }
    
    /// AlertController 내용 - 색상, 여백 추가
    func setMessage(color: UIColor) {
        guard let message = self.message else { return }
        
        let attributeString = NSMutableAttributedString(string: "\n\(message)\n\n", attributes: [.foregroundColor: color, .font: UIFont.systemFont(ofSize: 13)])
        
        self.setValue(attributeString, forKey: "attributedMessage")
    }
}
