//
//  DateExtension.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import Foundation

enum DateType: String {
    case date = "yyyy.MM.dd"
    case time = "HH:mm"
    case dateTime = "yyyy.MM.dd a hh:mm"
}

extension String {
    
    /// DB 형식의 문자열을 Date로 변환
    func toDate() -> Date? {
        var dateString = self
        
        if !dateString.contains(".") {
            dateString.append(".0")
        }
        
        if dateString.last != "Z" {
            dateString.append("Z")
        }
        
        let isoFormattoer = ISO8601DateFormatter()
        isoFormattoer.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
        return isoFormattoer.date(from: dateString) ?? nil
    }
}

extension Double {
    
    /// 초를 "시간:분" 형태로 변환
    func secondsToString() -> String {
        guard self.isNaN == false else { return "00:00" }
        
        let totalSeconds = Int(self)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
}

extension Date {
    
    /// 해당 날짜가 지금으로부터 얼마 전인지 계산
    func setTimeAgo() -> String {

        let interval = Int(Date().timeIntervalSince(self))
        
        let days = (interval / 3600) / 24
        let hours = (interval / 3600) % 24
        let minutes = (interval % 3600) / 60
        let seconds = (interval % 3600) % 60
        
        if days != 0 {
            return String(format: "time_ago_day".localized(), String(days))
        } else if hours != 0 {
            return String(format: "time_ago_hour".localized(), String(hours))
        } else if minutes != 0 {
            return String(format: "time_ago_min".localized(), String(minutes))
        } else {
            return String(format: "time_ago_sec".localized(), String(seconds))
        }
    }
    
    /// 해당 날짜가 지금으로부터 얼마 전인지 계산
    func getDateAgo() -> String {

        let interval = Int(Date().timeIntervalSince(self))
        
        let days = (interval / 3600) / 24
        let hours = (interval / 3600) % 24
        
        if days == 0, hours == 0 {
            return TimeAudio.justNow.rawValue.localizedName()
        } else if days == 0, hours >= 1, hours < 2 {
            return TimeAudio.oneHour.rawValue.localizedName()
        } else if days == 0, hours >= 2, hours < 24 {
            return TimeAudio.fewHour.rawValue.localizedName()
        } else if days == 1 {
            return TimeAudio.oneDay.rawValue.localizedName()
        } else if days > 1 {
            return TimeAudio.fewDay.rawValue.localizedName()
        } else if days > 30 {
            return TimeAudio.oneMonth.rawValue.localizedName()
        } else if days > 365 {
            return TimeAudio.fewMonth.rawValue.localizedName()
        } else {
            return TimeAudio.longTime.rawValue.localizedName()
        }
    }
    
    /// UTC를 Locale로 변환
    func utcToLocale(type: DateType) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        if let lang = CacheManager.getLanguage() {
            formatter.locale = Locale(identifier: lang)
        } else {
            formatter.locale = Locale(identifier: Locale.current.languageCode!)
        }
        
        formatter.dateFormat = type.rawValue
        let localDate = formatter.string(from: self)
        
        return localDate
    }
}
