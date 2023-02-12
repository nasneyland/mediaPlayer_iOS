//
//  News.swift
//  Newdio
//
//  Created by najin on 2021/12/02.
//

import Foundation

struct News: Codable {
    let id: Int!
    let title: String! // 제목
    let originalTitle: String? // 영어 제목
    let originalContent: String? // 영어 원문
    let imageURL: String? // 이미지 링크
    let site: String! // 사이트
    let link: String? // 본문 링크
    let time: String! // 게시일
    let language: String? //언어
    let longSummary: String? // 긴요약
    let shortSummary: String? // 긴요약
    let audioURL: String! //음성 파일 링크
    let likeCount: Int? // 좋아요 개수
    let likeState: Bool? // 좋아요 여부
    var newsList: [NewsThumb]! // 관련 뉴스 리스트
    
    enum CodingKeys: String, CodingKey {
        case id = "crawlingdata"
        case title = "title"
        case originalTitle = "eng_title"
        case originalContent = "eng_content"
        case imageURL = "image_url"
        case site = "news_site"
        case link = "news_url"
        case time = "post_date"
        case language = "language_type"
        case longSummary = "long_summarized_content"
        case shortSummary = "summarized_content"
        case audioURL = "audio_file"
        case likeCount = "likes"
        case likeState = "user_likes"
        case newsList = "related_news_list"
    }
}

struct NewsThumb: Codable {
    var id: Int = 0
    var title: String = "" // 제목
    var imageURL: String = "https://www.reuters.com/pf/resources/images/reuters/reuters-default.png?d=108" // 이미지 링크
    var site: String = "Newspaper" // 사이트
    var time: String = "2022-08-22T07:33:08.164314Z" // 게시일
    
    enum CodingKeys: String, CodingKey {
        case id = "crawlingdata"
        case title = "title"
        case imageURL = "image_url"
        case site = "news_site"
        case time = "post_date"
    }
}
