//
//  PlayerAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import Foundation
import Alamofire

class PlayerAPI {
    
    // URL 목록
    static let NEWS_URL = "\(BASE_URL)/app/crawling/processed-datas/"
    
    /// 뉴스 상세정보 + 관련 뉴스 리스트
    static func newsDetailAPI(id: Int,
                              error: @escaping (ErrorType) -> Void,
                              completion: @escaping (News) -> Void) {

        
        let newsURL = "\(NEWS_URL)\(id)/relation/".localizedURL()
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(newsURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: News.self) {
                response in
//                print("리스폰 Data: \(response)")
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
