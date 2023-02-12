//
//  DetailAPI.swift
//  Newdio
//
//  Created by najin on 2021/12/02.
//

import Foundation
import Alamofire

class DetailAPI {
    
    // URL 목록
    static let COMPANY_URL = "\(BASE_URL)/app/groups/companies/"
    static let COMPANY_NEWS_URL = "\(BASE_URL)/app/groups/companies/"
    static let INDUSTRY_URL = "\(BASE_URL)/app/groups/industries/"
    static let INDUSTRY_NEWS_URL = "\(BASE_URL)/app/groups/industries/"

    /// 기업 상세정보
    static func companyDetailAPI(id: String,
                                  error: @escaping (ErrorType) -> Void,
                                  completion: @escaping (Company) -> Void) {

        let companyURL = "\(COMPANY_URL)\(id)/".localizedURL()
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(companyURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Company.self) {
                response in
                switch response.result {
                case .success(let value):
                    completion(value)
                case .failure(_):
                    error(.server)
                }
            }
        }
    }
    
    /// 기업 관련뉴스
    static func companyNewsListAPI(id: String,
                            lastId: Int,
                                  error: @escaping (ErrorType) -> Void,
                                  completion: @escaping ([News]) -> Void) {

        var newsURL = "\(COMPANY_NEWS_URL)\(id)/related-news/".localizedURL()
        newsURL = lastId == 0 ? newsURL : "\(newsURL)&last-id=\(lastId)"
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(newsURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [News].self) {
                response in
                switch response.result {
                case .success(let value):
                    completion(value)
                case .failure(_):
                    error(.server)
                }
            }
        }
    }
    
    /// 산업 상세정보
    static func industryDetailAPI(id: String,
                                  error: @escaping (ErrorType) -> Void,
                                  completion: @escaping (Industry) -> Void) {

        let industryURL = "\(INDUSTRY_URL)\(id)/".localizedURL()
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(industryURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Industry.self) {
                response in
                switch response.result {
                case .success(let value):
                    completion(value)
                case .failure(_):
                    error(.server)
                }
            }
        }
    }
    
    /// 산업 관련뉴스
    static func industryNewsListAPI(id: String,
                            lastId: Int,
                                  error: @escaping (ErrorType) -> Void,
                                  completion: @escaping ([News]) -> Void) {

        var newsURL = "\(INDUSTRY_NEWS_URL)\(id)/related-news/".localizedURL()
        newsURL = lastId == 0 ? newsURL : "\(newsURL)&last-id=\(lastId)"
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(newsURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [News].self) {
                response in
                switch response.result {
                case .success(let value):
                    completion(value)
                case .failure(_):
                    error(.server)
                }
            }
        }
    }
}
