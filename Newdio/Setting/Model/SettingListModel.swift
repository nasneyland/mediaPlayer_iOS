//
//  SettingListModel.swift
//  Newdio
//
//  Created by sg on 2021/11/29.
//

import Foundation

struct SettingModel {
    let name: String
    let url: Link
}

enum SettingType {
    case useEnv
    case appInfo
    case agreement
    case userManagement
}

class SettingListModel {
    
    // 사용 환경 설정
    let useEnvList: [SettingModel] = [
        SettingModel(name: "settings_language".localized(), url: Link.none), // 언어 설정
        SettingModel(name: "settings_auto_play".localized(), url: Link.none), // 음성 자동 재생
        SettingModel(name: "settings_text".localized(), url: Link.none) // 텍스트 크기
        ]
    
    // 앱 정보
    let appInfoList: [SettingModel] = [
        SettingModel(name: "settings_version_info".localized(), url: Link.none), // 버전정보
        SettingModel(name: "settings_notice".localized(), url: Link.notice), // 공지사항
        SettingModel(name: "settings_faq".localized(), url: Link.faq), // 자주 묻는 질문
        SettingModel(name: "settings_bug".localized(), url: Link.none), // 버그 또는 문의
        SettingModel(name: "settings_evaluation".localized(), url: Link.evaluation), // 앱 평가하기
        SettingModel(name: "settings_share".localized(), url: Link.none) // 앱 공유하기
        ]
    
    // 이용 약관
    let agreementList: [SettingModel] = [
        SettingModel(name: "settings_tc_service".localized(), url: Link.termsofservice), // 서비스 이용약관
        SettingModel(name: "settings_tc_privacy".localized(), url: Link.privacypolicy), // 개인정보 보호약관
        SettingModel(name: "settings_tc_payment".localized(), url: Link.payment) // 유료서비스 이용약관
        ]
    
    // 계정 관리
    let userManagementList: [SettingModel] = [
        SettingModel(name: "settings_logout".localized(), url: Link.none), // 로그아웃
        SettingModel(name: "settings_secession".localized(), url: Link.none) // 회원탈퇴
        ]
}
