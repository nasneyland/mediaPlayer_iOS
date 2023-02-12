//
//  SignModel.swift
//  Newdio
//
//  Created by 박지영 on 2021/11/03.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "Authorization"
        case refreshToken = "Refresh-Token"
    }
}
