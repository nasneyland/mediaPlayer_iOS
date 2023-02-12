//
//  CacheManager.swift
//  Newdio
//
//  Created by najin on 2021/12/28.
//

import Foundation

enum Language: String {
    case ko = "ko" // 한국어
    case en = "en" // 영어
}

enum AutoPlay: String {
    case on = "on"
    case off = "off"
}

enum TextSize: String {
    case small = "small" // 작게 (-2)
    case original = "original" // 기본
    case large = "large" // 크게 (+3)
}

class CacheManager {
    
    static let LANGUAGE = "language"
    static let AUTO_PLAY = "autoPlay"
    static let TEXT_SIZE = "textSize"
    
    static let NEWS_CACHE = "cachedNews"
    static let SEARCH_CACHE = "searchedNews"
    
    static func getVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "0.0.0" }
        return version
    }
    //MARK: - Language
    
    /// 언어 설정
    static func setLanguage(language: String) {
        UserDefaults.standard.set(language, forKey: LANGUAGE)
    }
    
    /// 언어 조회
    static func getLanguage() -> String? {
        return UserDefaults.standard.string(forKey: LANGUAGE)
    }
    
    //MARK: - AutoPlay
    
    /// 자동재생 설정
    static func setAutoPlay(autoPlay: String) {
        UserDefaults.standard.set(autoPlay, forKey: AUTO_PLAY)
    }
    
    /// 자동재생 조회
    static func getAutoPlay() -> String {
        return UserDefaults.standard.string(forKey: AUTO_PLAY) ?? AutoPlay.on.rawValue
    }
    
    //MARK: - TextSize
    
    /// 텍스트 크기 설정
    static func setTextSize(textSize: String) {
        UserDefaults.standard.set(textSize, forKey: TEXT_SIZE)
    }
    
    /// 텍스트 크기 조회
    static func getTextSize() -> String {
        return UserDefaults.standard.string(forKey: TEXT_SIZE) ?? TextSize.original.rawValue
    }
    
    //MARK: - NewsCache
    
    /// 뉴스 읽음 처리
    static func setNewsCache(id: Int) {
        var newsList = UserDefaults.standard.array(forKey: NEWS_CACHE) as? [Int] ?? []
        
        if !newsList.contains(id) {
            newsList.append(id)
            UserDefaults.standard.set(newsList, forKey: NEWS_CACHE)
        }
    }

    /// 읽은 뉴스인지 체크
    static func isCachedNews(id: Int) -> Bool {
        let newsList = UserDefaults.standard.array(forKey: NEWS_CACHE) as? [Int] ?? []
        
        if newsList.contains(id) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - SearchCache
    
    /// 검색 리스트 조회
    static func getSearchCache() -> [String] {
        return UserDefaults.standard.array(forKey: SEARCH_CACHE) as? [String] ?? []
    }
    
    /// 검색어 저장
    static func setSearchCache(searchList: [String]) {
        UserDefaults.standard.set(searchList, forKey: SEARCH_CACHE)
    }
    
    /// 검색어 전체 삭제
    static func deleteSearchCache() {
        UserDefaults.standard.set([], forKey: SEARCH_CACHE)
    }
}

