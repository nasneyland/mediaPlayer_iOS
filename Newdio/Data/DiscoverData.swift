//
//  DiscoverData.swift
//  Newdio
//
//  Created by najin on 2022/09/22.
//

import Foundation

class DiscoverData {
    
    static func getRankNews() -> Rank {
        return Rank(update: CommonData().time,
                    dailyCompanyRankList: CommonData.getRankCompanyList(count: 10),
                    companyRankList: CommonData.getRankCompanyList(count: 10),
                    industryRankList: CommonData.getRankIndustryList(count: 10))
    }
}
