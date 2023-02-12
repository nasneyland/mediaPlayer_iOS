//
//  LiveAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/05.
//

import Foundation
import Alamofire

class LiveAPI {
    
    static let LIVE_URL = "\(APIManager.BASE_URL)/live/"
    
    /// LIVE 리스트 API
    static func liveAPI(id: Int,
                        error: @escaping (ErrorType) -> Void, completion: @escaping ([Live]) -> Void) {
        let url = id == 0 ? LIVE_URL.localizedURL() : "\(LIVE_URL.localizedURL())&last-id=\(id)"
        
        completion(LiveData.getLiveList())
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Live].self) { (response) in
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
    
    /// LIVE 뉴스 클릭 API
    static func liveNewsAPI(id: Int,
                            error: @escaping (ErrorType) -> Void, completion: @escaping (News) -> Void) {
        let url = "\(LIVE_URL)\(id)".localizedURL()
        
        completion(PlayerData.getNews(id: id))
        return
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: News.self) { (response) in
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
