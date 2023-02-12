//
//  Rank.swift
//  Newdio
//
//  Created by najin on 2021/10/15.
//

import Foundation

struct Rank: Codable {
    var dailyUpdate: String = CommonData().time // 일간 순위 업데이트 시간
    var update: String = CommonData().time // 실시간 순위 업데이트 시간
    var dailyCompanyRankList: [RankCompany]? // 일간 기업 순위
    var companyRankList: [RankCompany]? // 실시간 기업 순위
    var industryRankList: [RankIndustry]? // 실시간 산업 순위
    
    enum CodingKeys: String, CodingKey {
        case dailyUpdate = "created"
        case update = "modified"
        case dailyCompanyRankList = "company_ranking"
        case companyRankList = "company_list"
        case industryRankList = "industry_list"
    }
}

struct RankCompany: Codable {
    var name: String = ""
    var id: String = ""
    var logoURL: String = ""
    var industry: String = ""
    var change: String = String(Int.random(in: 0...5)) // 등락률

    enum CodingKeys: String, CodingKey {
        case name = "company"
        case id = "index"
        case logoURL = "logo_url"
        case industry = "related_industry"
        case change = "rank_change"
    }
}

struct RankIndustry: Codable {
    var name: String = ""
    var id: String = ""
    var logoURL: String = ""
    var change: String = "" // 등락률

    enum CodingKeys: String, CodingKey {
        case name = "industry"
        case id = "index"
        case logoURL = "logo_url"
        case change = "rank_change"
    }
}
