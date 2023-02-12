//
//  ConvertString.swift
//  Newdio
//
//  Created by sg on 2021/11/09.
//

import Foundation

func secondsToString(sec: Double) -> String {
    guard sec.isNaN == false else { return "00:00" }
    let totalSeconds = Int(sec)
    let min = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d:%02d", min, seconds)
}
