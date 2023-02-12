//
//  ReportButton.swift
//  Newdio
//
//  Created by najin on 2022/01/05.
//

import UIKit

class ReportButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.setTitleColor(.newdioGray1, for: .normal)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.contentVerticalAlignment = .top
    }
}
