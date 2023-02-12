//
//  DiscoverAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/15.
//

import Foundation
import Alamofire

class DiscoverAPI {
    
    static let DISCOVER_URL = "\(APIManager.BASE_URL)/groups"
    static let RANK_URL = "\(APIManager.BASE_URL)/ranking"
    
    /// 기업, 산업 순위 + 전체 산업 리스트 API
    static func rankListAPI(error: @escaping (ErrorType) -> Void, completion: @escaping (Rank) -> Void) {
        let url = "\(RANK_URL)/list/".localizedURL()

        completion(DiscoverData.getRankNews())
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Rank.self) { (response) in
                switch response.result {
                case .success(let value):
                    
                    APIManager.responseHeader(response: response.response!)
                    completion(value)
                    
                case .failure(_):
                    if let _ = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }

    /// 일간 기업 순위 API
    static func dailyRankListAPI(error: @escaping (ErrorType) -> Void, completion: @escaping (Rank) -> Void) {
        let url = "\(RANK_URL)/company/".localizedURL()
        completion(DiscoverData.getRankNews())
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Rank.self) { (response) in
                switch response.result {
                case .success(let value):

                    APIManager.responseHeader(response: response.response!)
                    completion(value)
                    
                case .failure(_):
                    if let _ = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
    
    /// 추천 기업 리스트 API
    static func recommandCompanyAPI(error: @escaping (ErrorType) -> Void, completion: @escaping ([Company]) -> Void) {
        let url = "\(DISCOVER_URL)/recommand-company/".localizedURL()
        
        completion(CommonData.getCompanyList(count: 10))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Company].self) { (response) in
                switch response.result {
                case .success(let value):

                    APIManager.responseHeader(response: response.response!)
                    completion(value)
                    
                case .failure(_):
                    if let _ = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }

    ///  전체 산업 리스트 API
    static func indusTotalListAPI(error: @escaping (ErrorType) -> Void, completion: @escaping ([Industry]) -> Void) {
        let url = "\(DISCOVER_URL)/total/industries/".localizedURL()

        completion(CommonData.getIndustryList(count: 10))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Industry].self) { (response) in
                switch response.result {
                case .success(let value):

                    APIManager.responseHeader(response: response.response!)
                    completion(value)
                    
                case .failure(_):
                    if let _ = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
    
    /// 전체 기업 리스트 API
    static func companyListAPI(error: @escaping (ErrorType) -> Void, completion: @escaping ([Industry]) -> Void) {
        let url = "\(DISCOVER_URL)/total/companies/".localizedURL()

        completion(CommonData.getIndustryList(count: 50))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Industry].self) { (response) in
                switch response.result {
                case .success(let value):

                    APIManager.responseHeader(response: response.response!)
                    completion(value)
                    
                case .failure(_):
                    if let _ = response.response?.statusCode {
                        error(.server)
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
}
