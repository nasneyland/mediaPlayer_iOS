//
//  StringExtension.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import Foundation
import UIKit

extension String {
    
    /// 해당 문자열을 다국어 처리
    func localized(comment: String = "") -> String {
        if let lang = CacheManager.getLanguage() {
            // 앱에서 설정한 언어로 다국어 처리
            let path = Bundle.main.path(forResource: lang, ofType: "lproj")
            let bundle = Bundle(path: path!)
            
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: comment)
        } else {
            // 기본 제공 다국어 처리
            return NSLocalizedString(self, comment: comment)
        }
    }
    
    /// URL 언어 다국어 처리
    func localizedURL() -> String {
        if let lang = CacheManager.getLanguage() {
            // 앱에서 설정한 언어로 다국어 처리
            return "\(self)?language=\(lang)"
        } else {
            // 사용자의 기기 설정 언어로 다국어 처리
            if Locale.current.languageCode == Language.ko.rawValue {
                return "\(self)?language=\(Language.ko.rawValue)"
            } else {
                // 한글 외에는 모두 영어로
                return "\(self)?language=\(Language.en.rawValue)"
            }
        }
    }
    
    /// 파일명 다국어처리
    func localizedName() -> String {
        if let lang = CacheManager.getLanguage() {
            // 앱에서 설정한 언어로 다국어 처리
            return "\(self)_\(lang)"
        } else {
            // 사용자의 기기 설정 언어로 다국어 처리
            if Locale.current.languageCode == Language.ko.rawValue {
                return "\(self)_\(Language.ko.rawValue)"
            } else {
                // 한글 외에는 모두 영어로
                return "\(self)_\(Language.en.rawValue)"
            }
        }
    }
    
    func openURL() {
        if let webUrl = URL(string: self) {
            UIApplication.shared.open(webUrl, options: [:])
        }
    }
}
