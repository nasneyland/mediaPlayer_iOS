//
//  BaseAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import Foundation
import Alamofire

//let BASE_URL = "http://10.0.1.19"
let BASE_URL = "https://traydnewdio.com"

//유저인지 확인
func isUser() -> Bool {
    if UserDefaults.standard.string(forKey: TokenType.accessToken) != nil {
        return true
    } else {
        return false
    }
}

//모든 API response Header 처리
func checkResponseHeader(response: HTTPURLResponse) {
    if let authorization = response.headers["Authorization"] {
        UserDefaults.standard.set(authorization, forKey: TokenType.accessToken)
    }
    if let expired = response.headers["Token-Error"] {
        removeToken()
    }
}

//토큰 헤더
func getHeader() -> HTTPHeaders {
    if let accessToken = UserDefaults.standard.string(forKey: TokenType.accessToken) {
        let refreshToken = UserDefaults.standard.string(forKey: TokenType.refreshToken)
        
        let header: HTTPHeaders = [TokenType.accessToken: accessToken, TokenType.refreshToken: refreshToken ?? ""]
        return header
        
    } else {
        let header: HTTPHeaders = [:]
        return header
    }
}

//토큰 셋팅
func setToken(token: Token) {
    UserDefaults.standard.set(token.accessToken, forKey: TokenType.accessToken)
    UserDefaults.standard.set(token.refreshToken, forKey: TokenType.refreshToken)
}

//토큰 삭제
func removeToken() {
    UserDefaults.standard.removeObject(forKey: TokenType.accessToken)
    UserDefaults.standard.removeObject(forKey: TokenType.refreshToken)
    
    removeUser()
}

//유저 정보 셋팅
func setUser(user: User) {
    UserDefaults.standard.set(user.email, forKey: "email")
    UserDefaults.standard.set(user.social, forKey: "social")
}

//유저 정보 삭제
func removeUser() {
    UserDefaults.standard.removeObject(forKey: "email")
    UserDefaults.standard.removeObject(forKey: "social")
}

///서버 에러 alert
func serverErrorPopup() -> UIAlertController {
    let alert = UIAlertController(title: "error_server_title".localized(), message: "error_server_subtitle".localized(), style: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "popup_confirm".localized(), style: .default)
    alert.addAction(okAction)
    return alert
}

///네트워크 에러 alert
func networkErrorPopup() -> UIAlertController {
    let alert = UIAlertController(title: "error_network_title".localized(), message: "error_network_subtitle".localized(), style: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "popup_confirm".localized(), style: .default)
    alert.addAction(okAction)
    return alert
}

///토큰 에러 alert
func tokenErrorPopup() -> UIAlertController {
    let alert = UIAlertController(title: "error_401_title".localized(), message: "error_401_content".localized(), style: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "popup_confirm".localized(), style: .default)
    alert.addAction(okAction)
    return alert
}

///유저 에러 alert
func userErrorPopup() -> UIAlertController {
    let alert = UIAlertController(title: "error_user_title".localized(), message: "error_user_content".localized(), style: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "popup_confirm".localized(), style: .default)
    alert.addAction(okAction)
    return alert
}

