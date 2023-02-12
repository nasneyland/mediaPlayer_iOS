//
//  UIColorExtension.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit

extension UIColor {
    
    /// hex color #69DB7C
    static var newdioMain = UIColor(hex: "#69DB7C")
    /// hex color #FF0000
    static var newdioRed = UIColor(hex: "#FF0000")
    /// hex color #00FF00
    static var newdioGreen = UIColor(hex: "#00FF00")
    /// hex color #FFFFFF
    static var newdioWhite = UIColor(hex: "#FFFFFF")
    /// hex color #BBBBBB
    static var newdioGray1 = UIColor(hex: "#BBBBBB")
    /// hex color #919191
    static var newdioGray2 = UIColor(hex: "#919191")
    /// hex color #303030
    static var newdioGray3 = UIColor(hex: "#303030")
    /// hex color #202020
    static var newdioGray4 = UIColor(hex: "#202020")
    /// hex color #171717
    static var newdioGray5 = UIColor(hex: "#171717")
    /// hex color #2A2A2A
    static var newdioGray6 = UIColor(hex: "#2A2A2A")
    /// hex color #52B5F9
    static var newdioSkyblue = UIColor(hex: "#52B5F9")
    
    /// hex 색상코드 UIColor 변환
    convenience init(hex: String) {
        let scanner = Scanner(string: hex) // 문자 파서역할을 하는 클래스
        _ = scanner.scanString("#")  // scanString은 iOS13 부터 지원 #문자 제거
        
        var rgb: UInt64 = 0
        //문자열을 Int64 타입으로 변환해 rgb 변수에 저장. 변환 할 수 없다면 0 반환
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0 //좌측 문자열 2개 추출
        let g = Double((rgb >> 8) & 0xFF) / 255.0 // 중간 문자열 2개 추출
        let b = Double((rgb >> 0) & 0xFF) / 255.0 //우측 문자열 2개 추출
        self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
    }
}
