//
//  Live.swift
//  Newdio
//
//  Created by najin on 2021/10/05.
//

import Foundation

struct Live: Codable {
    let date: String! // 게시일자
    let id: Int! // id
    let title: String? //제목
    let content: String! // 내용
    let category: String! // 카테고리
    let sentiment: Float! // 긍정도
    let companyList: [Company] // 관련 기업 리스트
    
    init(date: String, id: Int, title: String, content: String, category: String, sentiment: Float, companyList: [Company]) {
        self.date = date
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.sentiment = sentiment
        self.companyList = companyList
    }
    
    init(id: Int, title: String, sentiment: Float) {
        self.date = CommonData().time
        self.id = id
        self.title = title
        self.content = "content"
        self.category = "category"
        self.sentiment = sentiment
        self.companyList = CommonData.getCompanyList(count: 3)
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "post_date"
        case id = "crawlingdata"
        case title = "title"
        case content = "summarized_content"
        case category = "related_category"
        case sentiment = "text_sentiment"
        case companyList = "related_company_list"
    }
}
