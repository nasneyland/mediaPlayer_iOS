//
//  HomeData.swift
//  Newdio
//
//  Created by najin on 2022/09/21.
//

import Foundation

class HomeData {
    
    static func getHomeNews() -> [Category] {
        
        //MARK: - 탑 뉴스
        
        let topNews = Category(id: nil, title: "TOP", name: "hot", newsList: CommonData.getNewsList(count: 10))
        
        //MARK: - 랜덤 뉴스
        
        let random1News = Category(id: nil, title: "A 카테고리 뉴스", name: "randomIn", newsList: CommonData.getNewsList(count: 10))
        let random2News = Category(id: nil, title: "B 카테고리 뉴스", name: "randomIn", newsList: CommonData.getNewsList(count: 10))
        let random3News = Category(id: nil, title: "C 카테고리 뉴스", name: "randomIn", newsList: CommonData.getNewsList(count: 10))
        let random4News = Category(id: nil, title: "D 카테고리 뉴스", name: "randomIn", newsList: CommonData.getNewsList(count: 10))
        let random5News = Category(id: nil, title: "E 카테고리 뉴스", name: "randomIn", newsList: CommonData.getNewsList(count: 10))
        
        //MARK: - 뉴스 리스트
        
        var newsList: [Category] = []
        newsList.append(topNews)
        newsList.append(random1News)
        newsList.append(random2News)
        newsList.append(random3News)
        newsList.append(random4News)
        newsList.append(random5News)
        return newsList
    }
}
