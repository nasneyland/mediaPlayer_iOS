//
//  PlayerData.swift
//  Newdio
//
//  Created by najin on 2022/09/22.
//

import Foundation

class PlayerData {
    
    static func getNews(id: Int) -> News {
        let news = News(id: 0,
                        title: "\(id)번 뉴스입니다.",
                        originalTitle: "News Title",
                        originalContent: CommonData().text,
                        imageURL: CommonData().imageUrl,
                        site: "Newspaper",
                        link: "",
                        time: CommonData().time,
                        language: "ko",
                        longSummary: CommonData().text,
                        shortSummary: CommonData().text,
                        audioURL: "",
                        likeCount: 20,
                        likeState: false,
                        newsList: CommonData.getNewsList(count: 10))
        return news
    }
    
    static func getCompany(id: String) -> Company {
        let company = Company()
        return company
    }
    
    static func getIndustry(id: String) -> Industry {
        let industry = Industry()
        return industry
    }
}
