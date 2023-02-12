//
//  SocialButton.swift
//  Newdio
//
//  Created by najin on 2021/12/08.
//

import UIKit

// 소셜로그인 버튼
class SocialButton: UIButton {

    /// 로고와 텍스트 간격 조절
    override func draw(_ rect: CGRect) {
        self.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: screenWidth - 100)
        self.imageView?.contentMode = .scaleAspectFit
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 0)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    
    init(frame: CGRect, type: SocialType, backgroundColor: UIColor, titleColor: UIColor) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "img_general_\(type.rawValue)"), for: .normal)
        self.setTitle("social_login_\(type.rawValue)".localized(), for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
