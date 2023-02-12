//
//  Result.swift
//  Newdio
//
//  Created by najin on 2021/12/17.
//

import Foundation

struct Result: Codable {
    let code: Int // 에러 코드
    let message: String // 에러 메시지
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
}
