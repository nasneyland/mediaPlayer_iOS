//
//  SocialAPI.swift
//  Newdio
//
//  Created by 박지영 on 2021/10/28.
//

import Foundation
import Alamofire

class SocialAPI {
    // URL 목록
    static let kakaoURL = "\(BASE_URL)/accounts/app/social/kakao/signin/"
    static let appleURL = "\(BASE_URL)/accounts/app/social/apple/signin/"
    static let naverURL = "\(BASE_URL)/accounts/app/social/naver/signin/"
    static let googleURL = "\(BASE_URL)/accounts/app/social/google/signin/"
    
    //Request
    static let param: Parameters = [
       "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImJiZDJhYzdjNGM1ZWI4YWRjOGVlZmZiYzhmNWEyZGQ2Y2Y3NTQ1ZTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3MzIzMTAyNzE4MTktOWJuNWtwcWM4ZjVwdTlqdjU1NzZnbWtuZWZpYWQ3bmwuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3MzIzMTAyNzE4MTktOWJuNWtwcWM4ZjVwdTlqdjU1NzZnbWtuZWZpYWQ3bmwuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDQwNzc0MjE4NzQ3NjkwODkzMjUiLCJoZCI6InRyYXlkY29ycC5jb20iLCJlbWFpbCI6Imp5cEB0cmF5ZGNvcnAuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiItRURWZjdtZWV2Zkh3b1ljYU1iaVl3Iiwibm9uY2UiOiJaeWN0eVp3OWwxb1ZkaENETXZQdk5QbnBfb3NNcnFnQTN4dkh2RXdPMy1JIiwibmFtZSI6IuuwleyngOyYgSIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQVRYQUp5VHp5d3RtTVE2NXZQY1dCRWY1ZkVZazcxLUM0QWF1XzdwRHp3dj1zOTYtYyIsImdpdmVuX25hbWUiOiLsp4DsmIEiLCJmYW1pbHlfbmFtZSI6IuuwlSIsImxvY2FsZSI6ImtvIiwiaWF0IjoxNjM1MzgzNjk5LCJleHAiOjE2MzUzODcyOTl9.bd-BHIdwcExJCgQcAg7PK9DfePOW0Zq43ahv51i1DE0vD0eM68xQqx9IYbtPrtEs1KSO5jGBAC87e_VPQionKshEvhunMa8i-M5IV-R1eA5IeNz4gwgFhGjqiISVzU39qEmxjHyozBtO44HYaI6tmYpybOBfmIf2Onj8hOwnF_0_XkHdC5gzYzY976gzxlyF0kgAuZPwLfLA9UcvlDPiIbFK9H0EcRdHpQeJks66wdlsbxMy3jZ9FoAd2A5JvzvacCYqExMz4ZdZ-FhgAZhYtDn3l1r8eUGr1TreGTNCjNtV21sO3mgRm7lC6Jup_giPht2Tfm6d0XCBS4q0sEjVog"
    ]
    
    // SOCIAL 받아오기
    static func socialAPI(url: String,
                        parameters: Parameters,
                        error: @escaping () -> Void,
                        completion: @escaping (Token) -> Void) {
        
        //원래 코드
//        let alamo = AF.request(url, method: .post, parameters:param
//        ).validate(statusCode: 200..<300)
//        alamo.responseDecodable(of: SocialVO.self) { (response) in
//            switch response.result {
//            case .success(let socialVO):
//                completion(socialVO)
//            case .failure(_):
//                error()
//            }
//        }
        
        //디버그용(주석 처리 후 위 코드로 실행하면 됨)
        let alamo = AF.request(url, method: .post, parameters: param).validate(statusCode: 200..<500)
        alamo.responseJSON { responseJSON in
            debugPrint(responseJSON)
        }
        

    }

}
