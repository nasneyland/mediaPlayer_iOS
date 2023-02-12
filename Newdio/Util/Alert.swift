//
//  Alert.swift
//  Newdio
//
//  Created by sg on 2021/11/19.
//

import Foundation
import UIKit

func AlertMessage(content: String) {
    let alert = UIAlertController(title: "알림", message: content, preferredStyle: UIAlertController.Style.alert)
                
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
    
}
