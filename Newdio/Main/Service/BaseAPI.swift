//
//  BaseAPI.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import Foundation
import Alamofire

let TEST_URL = "http://10.0.1.19"
let BASE_URL = "https://traydnewdio.com"

///서버 에러 alert
func serverErrorPopup() -> UIAlertController {
    let alert = UIAlertController(title: "서버 에러", message: "서버가 불안정하여 뉴디오에 접속할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(okAction)
    return alert
}

///네트워크 에러 alert
func networkErrorPopup() -> UIAlertController {
    let alert = UIAlertController(title: "네트워크 에러", message: "네트워크가 불안정하여 뉴디오에 접속할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(okAction)
    return alert
}
