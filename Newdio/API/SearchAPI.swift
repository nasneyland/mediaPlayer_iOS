//
//  SearchAPI.swift
//  Newdio
//
//  Created by najin on 2022/01/02.
//

import Foundation
import Alamofire

class SearchAPI {
    
    static let SEARCH_URL = "\(APIManager.BASE_URL)/searches/"

    /// 키워드 검색 API
    static func searchAPI(keyword: String, lastId: Int,
                          error: @escaping (ErrorType) -> Void, completion: @escaping ([NewsThumb]) -> Void) {
        var urlString = lastId == 0 ? "\(SEARCH_URL.localizedURL())" : "\(SEARCH_URL.localizedURL())&last-id=\(lastId)"
        urlString += "&search-word=\(keyword)"
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
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
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 204 {
                            // 검색된 결과가 없는 경우
                            completion([])
                        } else {
                            error(.server)
                        }
                    } else {
                        error(.network)
                    }
                }
            }
        }
    }
}
