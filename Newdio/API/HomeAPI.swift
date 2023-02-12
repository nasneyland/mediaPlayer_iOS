//
//  HomeAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import Foundation
import Alamofire

class HomeAPI {
    
    static let HOME_URL = "\(APIManager.BASE_URL)/crawling/home/"
    
    /// Home 뉴스 API
    static func homeNewsAPI(error: @escaping (ErrorType) -> Void, completion: @escaping ([Category]) -> Void) {
        let url = HOME_URL.localizedURL()
        
        completion(HomeData.getHomeNews())
        return

        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {

            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Category].self) { response in
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
