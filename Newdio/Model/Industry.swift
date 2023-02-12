//
//  Industry.swift
//  Newdio
//
//  Created by najin on 2021/12/02.
//

import Foundation

struct Industry: Codable {
    var name: String = "Industry"
    var id: String = ""
    var logoURL: String = "" // 이미지 url
    var companyList: [Company] = [] // 기업 리스트
    var likeState: Bool = false // 좋아요 여부
    
    enum CodingKeys: String, CodingKey {
        case name = "industry"
        case id = "index"
        case logoURL = "logo_url"
        case companyList = "company_list"
        case likeState = "user_likes"
    }
}
