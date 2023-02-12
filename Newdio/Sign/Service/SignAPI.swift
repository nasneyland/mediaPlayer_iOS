//
//  SignAPI.swift
//  Newdio
//
//  Created by 박지영 on 2021/11/03.
//

import Foundation
import Alamofire

class SignAPI {
    
    // URL 목록
    static let kakaoSignURL = "\(BASE_URL)/accounts/app/social/kakao/signup/"
    static let appleSignURL = "\(BASE_URL)/accounts/app/social/apple/signup/"
    static let naverSignURL = "\(BASE_URL)/accounts/app/social/naver/signup/"
    static let googleSignURL = "\(BASE_URL)/accounts/app/social/google/signup/"
    
    // Request
    static let signparam: Parameters = [
        "access_token": "FTaBdIuD3qsRE5s8rZC83GWjsv0sPODAtwSwxAo9dNkAAAF8ufDdbw",
        "interested_companies": ["회사1", "회사2"],
        "interested_industries": ["샨업1", "산업2"],
        "birthday": "1996-12-22",
        "gender": "N"
    ]
    
    
    static func signAPI(url: String, parameters: Parameters, error: @escaping() -> Void, completion: @escaping(Token)-> Void) {
        
        //원래 코드
//        let alamo = AF.request(url, method: .post, parameters: signparam
//        ).validate(statusCode: 200..<300)
//        alamo.responseDecodable(of: SignVO.self) { (response) in
//            switch response.result {
//            case .success(let SignVO):
//                completion(SignVO)
//            case .failure(_):
//                error()
//            }
//        }
        
        // 디버그용 (확인용)
        let alamo = AF.request(url, method: .post, parameters: signparam).validate(statusCode: 200..<500)
        alamo.responseJSON { responseJSON in
            debugPrint(responseJSON)
       }
    
   }
        
    
}
