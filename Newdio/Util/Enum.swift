//
//  Enum.swift
//  Newdio
//
//  Created by najin on 2021/10/10.
//

import Foundation

enum APIKey {
    enum KakaoAPI {
        static let appKey = "####"
    }
    
    enum NaverAPI {
        static let serviceUrlScheme = "####"
        static let consumerKey = "####"
        static let consumerSecret = "####"
        static let appName = "####"
    }
}

enum Link: String {
    case termsofservice = "termsofservice" // 서비스 이용약관
    case privacypolicy = "privacypolicy" // 개인정보처리방침
    case payment = "payment" // 유료 이용 약관
    case notice = "notice" // 공지 사항
    case faq = "faq" // 자주 묻는 질문
    case evaluation = "evaluation" // 앱스토어 리뷰
    case none = ""
    
    /// url 언어 처리
    func localizedLink() -> String {
        if let lang = CacheManager.getLanguage() {
            return lang == Language.ko.rawValue ? "\(self.rawValue)-kor" : "\(self.rawValue)-eng"
        } else {
            return Locale.current.languageCode == Language.ko.rawValue ? "\(self.rawValue)-kor" : "\(self.rawValue)-eng"
        }
    }
}

enum Region: String {
    case ko = "KR"
}

enum TimeAudio: String {
    case justNow =  "just_now"
    case oneHour = "an_hour_ago"
    case fewHour = "a_couple_of_hours_ago"
    case oneDay = "a_day_ago"
    case fewDay = "a_couple_of_days_ago"
    case oneMonth = "a_month_ago"
    case fewMonth = "a_couple_of_months_ago"
    case longTime = "a_long_time_ago"
}
