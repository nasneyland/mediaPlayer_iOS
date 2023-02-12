//
//  Company.swift
//  Newdio
//
//  Created by najin on 2021/12/02.
//

import Foundation

struct Company: Codable {
    var name: String = "Company"
    var id: String = ""
    var logoURL: String = "" // 로고 url
    var abbreviation: String = "" // 축약어
    var description: String = CommonData().summary // 설명
    var industry: String = "Industry" // 관련 산업
    var likeState: Bool = false // 좋아요 여부
    var industryIndex: Int = 0 // 관련 산업 id
    
    enum CodingKeys: String, CodingKey {
        case name = "company"
        case id = "index"
        case logoURL = "logo_url"
        case abbreviation = "abbreviation_company_name"
        case description = "description"
        case industry = "related_industry"
        case likeState = "user_likes"
        case industryIndex
    }
}
