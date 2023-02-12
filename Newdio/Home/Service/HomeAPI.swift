//
//  HomeAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import Foundation
import Alamofire

class HomeAPI {
    
    // URL 목록
    
    static let HOME_URL = "\(BASE_URL)/app/crawling/home/"
    
    /// Home 뉴스 셋팅
    static func homeNewsAPI(error: @escaping (ErrorType) -> Void,completion: @escaping ([Category]) -> Void) {
        
        let homeURL = HOME_URL.localizedURL()
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(homeURL, method: .get).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: [Category].self) {
                response in
                switch response.result {
                case .success(let categoryList):
                    
                    //이미지 미리 다운로드
                    for category in categoryList {
                        for news in category.newsList {
                            UIImageView().setImageUrl(url: news.imageURL ?? "")
                        }
                    }
                    
                    completion(categoryList)
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
