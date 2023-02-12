//
//  DetailAPI.swift
//  Newdio
//
//  Created by najin on 2021/12/02.
//

import Foundation
import Alamofire

class DetailAPI {
    
    static let DETAIL_URL = "\(APIManager.BASE_URL)/groups"
    static let COMPANY_URL = "\(APIManager.BASE_URL)/groups/companies"
    static let INDUSTRY_URL = "\(APIManager.BASE_URL)/groups/industries"

    /// 기업 상세정보 API
    static func companyDetailAPI(id: String,
                                 error: @escaping (ErrorType) -> Void, completion: @escaping (Company) -> Void) {
        let url = "\(COMPANY_URL)/\(id)/".localizedURL()
        
        completion(PlayerData.getCompany(id: id))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Company.self) { response in
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
    
    /// 기업 관련뉴스 API
    static func companyNewsListAPI(id: String, lastId: Int,
                                   error: @escaping (ErrorType) -> Void, completion: @escaping ([NewsThumb]) -> Void) {
        var url = "\(COMPANY_URL)/\(id)/related-news/".localizedURL()
        url = lastId == 0 ? url : "\(url)&last-id=\(lastId)"
        
        completion(CommonData.getNewsList(count: 10))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [NewsThumb].self) { response in
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
    
    /// 산업 상세정보 API
    static func industryDetailAPI(id: String,
                                  error: @escaping (ErrorType) -> Void, completion: @escaping (Industry) -> Void) {
        let url = "\(INDUSTRY_URL)/\(id)/".localizedURL()
        
        completion(PlayerData.getIndustry(id: id))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Industry.self) { response in
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
    
    /// 산업 관련뉴스
    static func industryNewsListAPI(id: String, lastId: Int,
                                    error: @escaping (ErrorType) -> Void, completion: @escaping ([NewsThumb]) -> Void) {
        var url = "\(INDUSTRY_URL)/\(id)/related-news/".localizedURL()
        url = lastId == 0 ? url : "\(url)&last-id=\(lastId)"
        
        completion(CommonData.getNewsList(count: 10))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [NewsThumb].self) { response in
                switch response.result {
                case .success(let value):
                    
                    APIManager.responseHeader(response: response.response!)
                    completion(value)
                    
                case .failure(_):
                    error(.server)
                }
            }
        }
    }
    
    /// 산업, 기업 좋아요
    static func detailLikeAPI(id: String,
                              error: @escaping (ErrorType) -> Void, completion: @escaping (Int) -> Void) {
        let url = "\(DETAIL_URL)/\(id)/like/"
        
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .post,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Result.self) { response in
                switch response.result {
                case .success(let value):
                    
                    APIManager.responseHeader(response: response.response!)
                    completion(value.code)
                    
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        error(ErrorManager.statusCodeToError(statusCode: statusCode))
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
}
