//
//  APIManager.swift
//  Newdio
//
//  Created by najin on 2022/01/23.
//

import Foundation
import Alamofire

struct APIManager {
    
    static let BASE_URL = "#####"
    
    static let accessToken = Token.CodingKeys.accessToken.rawValue
    static let refreshToken = Token.CodingKeys.refreshToken.rawValue
    
    static let email = "email"
    static let social = "social"
    static let id = "id"
    
    /// 키 체인에 토큰 저장
    static func setToken(key: String, value: String) {
        
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword, // 어떠한 타입의 데이터를 저장할지
            kSecAttrService: BASE_URL, // 서비스 아이디 (식별자)
            kSecAttrAccount: key, // 저장할 아이템의 키
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)! // 저장할 아이템의 값
        ]
        
        // 현재 저장되어 있는 값 삭제 (기존의 값을 덮어쓰지 못함)
        SecItemDelete(keyChainQuery)
        
        // 새로운 키 체인 아이템 등록
        SecItemAdd(keyChainQuery, nil)
    }
    
    /// 키 체인에 저장된 토큰을 읽어옴
    static func getToken(key: String) -> String? {
        
        let keyChainQueryy: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: BASE_URL,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        //  키 체인에 저장된 값을 읽어옴
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQueryy, &dataTypeRef)

        // 처리 결과가 성공이면 Data 타입으로 변환 - 다시 String 타입으로 변환
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: .utf8)
            return value
        } else {
            return nil
        }
    }
    
    /// 키 체인에 저장된 토큰을 삭제
    static func deleteToken(key: String) {
        
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: BASE_URL,
            kSecAttrAccount: key
        ]

        // 저장되어 있는 값 삭제
        SecItemDelete(keyChainQuery)
    }

    /// 키체인에 등록된 토큰을 전체 삭제
    static func deleteAllToken() {
        self.deleteToken(key: self.accessToken)
        self.deleteToken(key: self.refreshToken)
        self.deleteToken(key: self.email)
        self.deleteToken(key: self.social)
    }
    
    /// 키 체인에 저장된 토큰을 이용해 헤더를 만듬
    static func getHeader() -> HTTPHeaders? {
        guard let authToken = self.getToken(key: self.accessToken),
              let refreshToken = self.getToken(key: self.refreshToken) else { return nil }

        return [self.accessToken: authToken,
                self.refreshToken: refreshToken]
    }
    
    /// Response 헤더의 토큰값 체크
    static func responseHeader(response: HTTPURLResponse) {
        
        // 새로 받은 access Token으로 교체
        if let authorization = response.headers[Token.CodingKeys.accessToken.rawValue] {
            self.setToken(key: self.accessToken, value: authorization)
        }
        
        // 토큰 에러인 경우 토큰 전체 삭제
        if let error = response.headers["Token-Error"] {
            self.deleteAllToken()
            showToast(message: "common_logout".localized())
            
            // 액세스 토큰 만료 로그 전송
            LogManager.sendLogData(screen: .null, action: .token, params: ["type": "expired_token", "token_access": self.getToken(key: self.accessToken) ?? "", "token_refresh": self.getToken(key: self.refreshToken) ?? ""])
        }
    }
    
    /// 키체인에 저장된 토큰의 존재 여부로 유저인지 확인
    static func isUser() -> Bool {
        if self.getToken(key: self.accessToken) != nil {
            return true
        } else {
            return false
        }
    }
    
    //유저 정보 셋팅
    static func setUser(user: User) {
        UserDefaults.standard.set(user.email, forKey: self.email)
        UserDefaults.standard.set(user.social?.rawValue, forKey: self.social)
        UserDefaults.standard.set(user.id, forKey: self.id)
    }
    
    //유저 정보 - 이메일 조회
    static func getId() -> String {
        return UserDefaults.standard.string(forKey: self.id) ?? ""
    }
    
    //유저 정보 - 이메일 조회
    static func getEmail() -> String {
        return UserDefaults.standard.string(forKey: self.email) ?? ""
    }
    
    //유저 정보 - 소셜 종류 조회
    static func getSocial() -> String {
        return UserDefaults.standard.string(forKey: self.social) ?? "apple"
    }

    //유저 정보 삭제
    static func deleteUser() {
        UserDefaults.standard.removeObject(forKey: self.email)
        UserDefaults.standard.removeObject(forKey: self.social)
    }
}
