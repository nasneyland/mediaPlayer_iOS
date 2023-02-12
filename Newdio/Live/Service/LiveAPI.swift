//
//  LiveAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/05.
//

import Foundation
import Alamofire

class LiveAPI {
    
    // URL 목록
    static let LIVE_URL = "\(BASE_URL)/app/live/"
    
    /// LIVE 받아오기
    static func liveAPI(id: Int,
                        error: @escaping (ErrorType) -> Void,
                        completion: @escaping ([Live]) -> Void) {
        
        let liveURL = id == 0 ? LIVE_URL.localizedURL() : "\(LIVE_URL.localizedURL())&last-id=\(id)"
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(liveURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Live].self) { (response) in
                switch response.result {
                case .success(let liveVO):
                    completion(liveVO)
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
