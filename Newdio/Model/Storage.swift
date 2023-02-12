//
//  Storage.swift
//  Newdio
//
//  Created by najin on 2021/12/17.
//

import Foundation

struct Storage: Codable {
    var companyList: [Company]? // 선호 기업 리스트
    var industryList: [Industry]? // 선호 산업 리스트
    var newsList: [News]? // 선호 뉴스 리스트
    
    enum CodingKeys: String, CodingKey {
        case companyList = "interested_companies"
        case industryList = "interested_industries"
        case newsList = "liked_news"
    }
}
