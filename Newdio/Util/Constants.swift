//
//  Constants.swift
//  Newdio
//
//  Created by najin on 2021/11/03.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let widthAdjust = UIScreen.main.bounds.width / 375
let heightAdjust = UIScreen.main.bounds.height / 812

let SITE_URL = "site_url"
let MAIN_EMAIL = "main_email"

/// 토스트 메시지
func showToast(message : String, duration: Double = 1.5) {
    let toastLabel = UILabel()
   
    toastLabel.text = message
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center
    toastLabel.font = UIFont.systemFont(ofSize: 15)
    toastLabel.numberOfLines = 0
   
    let toastBackgroundView = UIView()
    toastBackgroundView.backgroundColor = .newdioBlack
    toastBackgroundView.clipsToBounds = true
    toastBackgroundView.layer.cornerRadius = 10 * widthAdjust
    
    
    UIApplication.shared.windows.first?.rootViewController?.view.addSubview(toastBackgroundView)
    toastBackgroundView.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.bottom.equalToSuperview().offset(-100)
        make.width.greaterThanOrEqualTo(128 * widthAdjust)
        make.height.greaterThanOrEqualTo(39 * widthAdjust)
    }
    
    toastBackgroundView.addSubview(toastLabel)
    toastLabel.snp.makeConstraints { make in
        make.top.bottom.equalToSuperview().inset(8 * widthAdjust)
        make.leading.trailing.equalToSuperview().inset(16 * widthAdjust)
        make.center.equalToSuperview()
    }
    
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn) {
        toastBackgroundView.alpha = 0.0
        toastLabel.alpha = 0.0
    } completion: { _ in
        toastBackgroundView.removeFromSuperview()
    }
}
