//
//  Report.swift
//  Newdio
//
//  Created by najin on 2022/01/23.
//

import Foundation

enum ReportType: String, Codable, CodingKey {
    case translate = "Translate" // 번역 오류
    case summary = "Summarize" // 요약 오류
    case sound = "Voice" // 음성 오류
    case etc = "Etc" // 기타 오류
}

struct Report: Codable {
    let type: ReportType // 신고 종류
    let content: String // 신고 내용
    
    enum CodingKeys: String, CodingKey {
        case type = "report_type"
        case content = "description"
    }
}
