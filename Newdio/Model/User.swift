//
//  User.swift
//  Newdio
//
//  Created by najin on 2021/12/09.
//

import Foundation

enum SocialType: String, Codable, CodingKey {
    case google = "google"
    case kakao = "kakao"
    case naver = "naver"
    case apple = "apple"
}

enum Gender: String, Codable, CodingKey {
    case man = "M" // 남성
    case woman = "F" // 여성
    case none = "N" // 선택안함
}

struct User: Codable {
    var id: Int?
    var accessToken: String? // 소셜 토큰
    var birthday: String? // 생년월일
    var gender: Gender? // 성별
    var companyList: [String]? // 선호 기업 id 리스트
    var industryList: [String]? // 선호 산업 id 리스트

    var social: SocialType? // 소셜 종류
    var email: String? // 이메일

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case accessToken = "access_token"
        case birthday = "birthday"
        case gender = "gender"
        case companyList = "interested_companies"
        case industryList = "interested_industries"

        case social = "provider"
        case email = "email"
    }
}
