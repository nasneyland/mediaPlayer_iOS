//
//  DiscoverAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/15.
//

import Foundation
import Alamofire

class DiscoverAPI {
    
    // URL 목록
    static let RECOMMAND_COMPANY_API = "\(BASE_URL)/app/groups/recommand-company/"
    static let RANK_LIST_API = "\(BASE_URL)/app/ranking/list/"
    static let INDUSTRY_TOTAL_LIST = "\(BASE_URL)/app/groups/total/industries/"
    
    /// 추천 기업 리스트
    static func recommandCompanyAPI(error: @escaping (ErrorType) -> Void,
                                    completion: @escaping ([Company]) -> Void) {
        
        let recommandCompanyURL = RECOMMAND_COMPANY_API.localizedURL()
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(recommandCompanyURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Company].self) { (response) in
                switch response.result {
                case .success(let companyList):
                    completion(companyList)
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
    
    /// 기업, 산업 순위 + 전체 산업 리스트
    static func rankListAPI(error: @escaping (ErrorType) -> Void,
                            completion: @escaping (Rank) -> Void) {
        
        let rankListAPI = RANK_LIST_API.localizedURL()
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(rankListAPI, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Rank.self) { (response) in
                switch response.result {
                case .success(let rankList):
                    completion(rankList)
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
    
    ///  전체 산업 리스트
    static func indusTotalListAPI(error: @escaping (ErrorType) -> Void,
                            completion: @escaping ([Industry]) -> Void) {
        
        let industryTotalListAPI = INDUSTRY_TOTAL_LIST.localizedURL()
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(industryTotalListAPI, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Industry].self) { (response) in
                switch response.result {
                case .success(let totalList):
                    completion(totalList)
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
}
