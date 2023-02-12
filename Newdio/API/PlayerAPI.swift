//
//  PlayerAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import Foundation
import Alamofire

class PlayerAPI {
    
    static let NEWS_URL = "\(APIManager.BASE_URL)/crawling/processed-datas"
    
    /// 뉴스 상세정보 + 관련 뉴스 리스트 API
    static func newsListAPI(id: Int,
                              error: @escaping (ErrorType) -> Void, completion: @escaping (News) -> Void) {
        let url = "\(NEWS_URL)/\(id)/relation/".localizedURL()
        
        completion(PlayerData.getNews(id: id))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: News.self) { response in
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
    
    /// 뉴스 상세정보 API
    static func newsAPI(id: Int,
                        error: @escaping (ErrorType) -> Void, completion: @escaping (News) -> Void) {
        let url = "\(NEWS_URL)/\(id)/".localizedURL()
        
        completion(PlayerData.getNews(id: id))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: News.self) { response in
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
    
    /// 플레이리스트 추가 로딩 API
    static func moreNewsAPI(excludeList: String, relatedList: String,
                            error: @escaping (ErrorType) -> Void, completion: @escaping ([NewsThumb]) -> Void) {
        let url = "\("\(NEWS_URL)/next-relation/".localizedURL())&exclude-list=\(excludeList)&related-list=\(relatedList)"

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
    
    /// 뉴스 좋아요 API
    static func newsHeartAPI(id: Int,
                             error: @escaping (ErrorType) -> Void, completion: @escaping (Int) -> Void) {
        let url = "\(NEWS_URL)/\(id)/like/"
        
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
    
    /// 뉴스 신고하기 API
    static func newsReportAPI(id: Int, report: Report,
                              error: @escaping (ErrorType) -> Void, completion: @escaping () -> Void) {
        let url = "\(NEWS_URL)/\(id)/report/"
        
        completion()
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .post,
                                   parameters: report,
                                   encoder: JSONParameterEncoder.default,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.response() { response in
                switch response.result {
                case .success(_):
                    
                    APIManager.responseHeader(response: response.response!)
                    completion()
                    
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
