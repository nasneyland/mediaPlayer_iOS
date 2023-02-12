//
//  NotificationManager.swift
//  Newdio
//
//  Created by najin on 2022/01/23.
//

import Foundation

struct NotificationManager {
    enum Main {
        /// 초기화 후 메인 홈 화면으로 시작
        static let home = NSNotification.Name(rawValue: "Home")
        /// 메인 탭바 화면으로 전환
        static let main = NSNotification.Name(rawValue: "Main")
        /// 로그인 화면으로 전환
        static let login = NSNotification.Name(rawValue: "Login")
        
        /// 탭바 - 뉴디오 클릭
        static let newdio = NSNotification.Name(rawValue: "Newdio")
        /// 탭바 - 라이브  클릭
        static let live = NSNotification.Name(rawValue: "Live")
        /// 탭바 - 둘러보기  클릭
        static let discover = NSNotification.Name(rawValue: "Discover")
    }
    
    enum Sign {
        /// 선호 기업 선택
        static let selectCompany = NSNotification.Name(rawValue: "SignSelectCompany")
    }
    
    enum Player {
        /// 플레이어 재생,일시정지 업데이트
        static let refresh = NSNotification.Name(rawValue: "PlayerRefresh")
        /// 플레이리스트 뉴스 클릭
        static let selectNews = NSNotification.Name(rawValue: "PlayerSelectNews")
    }
    
    enum Setting {
        /// 셋팅 cell 클릭
        static let detail = NSNotification.Name(rawValue: "SettingDetail")
        /// 셋팅 로그인 클릭
        static let login = NSNotification.Name(rawValue: "SettingLogin")
        /// 셋팅 보관함 클릭
        static let storage = NSNotification.Name(rawValue: "SettingStorage")
    }
    
    enum Discover {
        /// 둘러보기 팝업 닫기
        static let closeInfo = NSNotification.Name(rawValue: "DiscoverCloseInfo")
        /// 둘러보기 기업 클릭
        static let company = NSNotification.Name(rawValue: "DiscoverCompany")
        /// 둘러보기 산업 클릭
        static let industry = NSNotification.Name(rawValue: "DiscoverIndustry")
        
    }
    
    enum Live {
        /// 라이브 팝업 닫기
        static let closeInfo = NSNotification.Name(rawValue: "LiveCloseInfo")
    }

    enum Detail {
        /// 상세보기 팝업 닫기
        static let closeInfo = NSNotification.Name(rawValue: "DetailCloseInfo")
    }
}
