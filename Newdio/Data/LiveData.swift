//
//  LiveData.swift
//  Newdio
//
//  Created by najin on 2022/09/22.
//

import Foundation

class LiveData {
    
    static func getLiveList() -> [Live] {
        var liveNewsList: [Live] = []
        liveNewsList.append(Live(id: 1, title: "1번 뉴스입니다.", sentiment: 0.5))
        liveNewsList.append(Live(id: 2, title: "2번 뉴스입니다.", sentiment: 0.1))
        liveNewsList.append(Live(id: 3, title: "3번 뉴스입니다.", sentiment: 0.6))
        liveNewsList.append(Live(id: 4, title: "4번 뉴스입니다.", sentiment: 0.9))
        liveNewsList.append(Live(id: 5, title: "5번 뉴스입니다.", sentiment: 0.2))
        liveNewsList.append(Live(id: 6, title: "6번 뉴스입니다.", sentiment: 0.4))
        liveNewsList.append(Live(id: 7, title: "7번 뉴스입니다.", sentiment: 0.5))
        liveNewsList.append(Live(id: 8, title: "8번 뉴스입니다.", sentiment: 0.9))
        liveNewsList.append(Live(id: 9, title: "9번 뉴스입니다.", sentiment: 0.8))
        liveNewsList.append(Live(id: 10, title: "10번 뉴스입니다.", sentiment: 0.2))
        return liveNewsList
    }
}
