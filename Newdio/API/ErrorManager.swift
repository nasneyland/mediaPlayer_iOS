//
//  ErrorManager.swift
//  Newdio
//
//  Created by najin on 2022/01/23.
//

import Foundation
import UIKit

enum ErrorType {
    case network // 네트워크 오류
    case server // 서버 오류
    case tokenInvalid // 토큰 오류
    case userInvalid // 유효하지 않은 회원
    case userExist // 존재하지 않은 회원
}

class ErrorManager {
    
    /// 상태코드 에러 타입으로 변환
    static func statusCodeToError(statusCode: Int) -> ErrorType {
        switch statusCode {
        case 400: return .userExist
        case 401: return .tokenInvalid
        case 412: return .userInvalid
        case 0: return .network
        default: return .server
        }
    }
    
    /// 에러 타입에 맞는 Alert 반환
    static func errorToAlert(error: ErrorType) -> UIAlertController {
        switch error {
        case .userExist: return self.errorAlert(title: "error_user_title".localized(), message: "error_user_content".localized())
        case .tokenInvalid: return self.errorAlert(title: "error_401_title".localized(), message: "error_401_content".localized())
        case .userInvalid: return self.errorAlert(title: "error_user_title".localized(), message: "error_user_content".localized())
        case .network: return self.errorAlert(title: "error_network_title".localized(), message: "error_network_subtitle".localized())
        case .server: return self.errorAlert(title: "error_server_title".localized(), message: "error_server_subtitle".localized())
        }
    }
    
    /// 에러시 AlertController
    static func errorAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, style: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "popup_confirm".localized(), style: .default)
        alert.addAction(action)
        return alert
    }
}
