//
//  TextFieldExtension.swift
//  Newdio
//
//  Created by najin on 2021/12/08.
//

import Foundation
import UIKit

extension UITextField {
    
    /// 텍스트 필드 왼쪽 여백
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
