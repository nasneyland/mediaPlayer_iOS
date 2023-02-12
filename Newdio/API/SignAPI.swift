//
//  SignAPI.swift
//  Newdio
//
//  Created by 박지영 on 2021/11/03.
//

import Foundation
import Alamofire

class SignAPI {
    
    static let SIGN_URL = "\(APIManager.BASE_URL)/accounts"
    
    /// 소셜로그인 API
    static func signInAPI(social: SocialType, token: String,
                          error: @escaping(ErrorType) -> Void, completion: @escaping()-> Void) {
        let url = "\(SIGN_URL)/social/\(social.rawValue)/signin/"
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .post,
                                   parameters: ["access_token": token],
                                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Token.self) { (response) in
                switch response.result {
                case .success(let value):
                    //회원정보 조회 API
                    userAPI(token: value, error: {(errorType) in
                        error(errorType)
                    }) { () in
                        completion()
                    }

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

    /// 가입 API
    static func signUpAPI(user: User,
                          error: @escaping(ErrorType) -> Void, completion: @escaping()-> Void) {
        let url = "\(SIGN_URL)/social/\(user.social!.rawValue)/signup/"
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .post,
                                   parameters: user,
                                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Token.self) { (response) in
                switch response.result {
                case .success(let value):
                    
                    //회원정보 조회 API
                    userAPI(token: value, error: {(errorType) in
                        error(errorType)
                    }) { () in
                        completion()
                    }

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
    
    // 회원 정보 조회 API
    static func userAPI(token: Token,
                        error: @escaping(ErrorType) -> Void, completion: @escaping()-> Void) {
        let url = "\(SIGN_URL)/users/me/"

        // 토큰 정보 셋팅
        APIManager.setToken(key: APIManager.accessToken, value: token.accessToken)
        APIManager.setToken(key: APIManager.refreshToken, value: token.refreshToken)
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: User.self) { (response) in
                switch response.result {
                case .success(let value):
                    
                    // 유저 정보 셋팅
                    APIManager.setUser(user: value)
                    
                    completion()
                    
                case .failure(_):
                    APIManager.deleteAllToken()
                    
                    if let statusCode = response.response?.statusCode {
                        error(ErrorManager.statusCodeToError(statusCode: statusCode))
                    } else {
                        error(.network)
                    }
                }
            }
        }
   }
    
    /// 탈퇴 API
    static func signOutAPI(error: @escaping(ErrorType) -> Void, completion: @escaping()-> Void) {
        let url = "\(SIGN_URL)/users/me/"

        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .delete,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.response() { (response) in
                switch response.result {
                case .success(_):
                    
                    // 유저 정보 삭제
                    APIManager.deleteUser()
                    
                    // 토큰 정보 삭제
                    APIManager.deleteAllToken()

                    completion()
                    
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
    
    /// 보관함 리스트 API
    static func storageAPI(error: @escaping (ErrorType) -> Void, completion: @escaping (Storage) -> Void) {
        let url = "\(SIGN_URL)/users/me/storage/".localizedURL()

        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: APIManager.getHeader()).validate(statusCode: 200..<300)
            alamo.responseDecodable(of: Storage.self) { (response) in
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
    
    /// 네이버 로그인
    static func naverLoginAPI(authorization: String, error: @escaping (ErrorType) -> Void, completion: @escaping () -> Void) {
        let url = "https://openapi.naver.com/v1/nid/me"
        
        if !NetworkReachabilityManager()!.isReachable {
            error(.network)
        } else {
            let alamo = AF.request(url, method: .get,
                                   headers: ["Authorization": authorization]).validate(statusCode: 200..<300)
            alamo.responseJSON() { (response) in
                switch response.result {
                case .success(_):
                    guard let result = response.value as? [String: Any] else { return }
                    guard let object = result["response"] as? [String: Any] else { return }
                    guard let _ = object["email"] as? String else {
                        error(.userInvalid)
                        return
                    }
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
