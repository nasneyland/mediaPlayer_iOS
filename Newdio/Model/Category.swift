//
//  Category.swift
//  Newdio
//
//  Created by najin on 2021/11/08.
//

import Foundation

struct Category: Codable {
    let id: String?
    let title: String! // 제목
    let name: String? // 타입(로그 전송용)
    let newsList: [NewsThumb]! // 해당 뉴스 리스트
    
    enum CodingKeys: String, CodingKey {
        case id = "index"
        case title = "category"
        case name = "category_name"
        case newsList = "newsList"
    }
}
