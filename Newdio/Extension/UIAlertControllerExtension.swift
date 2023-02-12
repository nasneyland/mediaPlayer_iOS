//
//  UIAlertControllerExtension.swift
//  Newdio
//
//  Created by najin on 2022/01/03.
//

import Foundation
import UIKit

extension UIAlertController {
    
    convenience init(title: String, message: String, style: UIAlertController.Style) {
        self.init(title: title, message: message, preferredStyle: style)
        
        self.setMessage(color: .newdioGray1)
    }
    
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    func setTitle(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    func setMessage(color: UIColor) {
        guard let message = self.message else { return }
        
        let attributeString = NSMutableAttributedString(string: "\n\(message)\n\n", attributes: [.foregroundColor: color, .font: UIFont.systemFont(ofSize: 13)])
        
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
