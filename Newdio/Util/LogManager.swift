//
//  LogManager.swift
//  Newdio
//
//  Created by najin on 2022/01/02.
//

import Foundation
//import FirebaseAnalytics
import UIKit

enum ScreenLog: String {
    case null = "null"
    case launch = "launch"
    case newdio = "newdio"
    case player = "player"
    case detail = "detail"
    case live = "live"
    case discover = "discover"
    case search = "search"
    case setting = "setting"
    case sign = "sign"
}

enum ActionLog: String {
    case null = "null"
    case end = "end"
    case click = "click"
    case view = "view"
    case autoClick = "auto_click"
    case kill = "kill"
    case drag = "drag"
    case foreground = "foreground"
    case background = "background"
    case token = "token"
}

class LogManager {
    
    /// 로그 전송
    static func sendLogData(screen: ScreenLog, action: ActionLog, params: [String : Any]?) {
        let userId = APIManager.isUser() ? APIManager.getId() : UIDevice.current.identifierForVendor?.uuidString ?? ""
        let time = Int(Date().timeIntervalSince1970)

        var parameters: [String : Any] = ["userId": userId, "time": time, "screen": screen.rawValue, "action": action.rawValue]

        if params != nil {
            for param in params! {
                parameters[param.key] = param.value
            }
        }

        print("[NEWDIO_LOG] \(parameters)")
//
//        Analytics.logEvent("ios", parameters: parameters)
    }
}
