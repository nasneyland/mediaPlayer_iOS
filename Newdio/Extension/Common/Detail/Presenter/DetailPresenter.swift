//
//  DetailPresenter.swift
//  Newdio
//
//  Created by najin on 2022/01/10.
//

import Foundation
import UIKit

class DetailPresenter {
    
    /// 상세보기 클릭한 경우 present
    static func startDetail(id: String, type: DetailType) {
        let DetailVC = DetailViewController(detailType: type)
        DetailVC.id = id
        
        DetailVC.modalPresentationStyle = .overFullScreen
        MainTabBarController.shared.present(DetailVC, animated: true)
    }
    
    /// 상세보기 클릭한 경우 present
    static func addDetail(vc: UIViewController, id: String, type: DetailType) {
        let DetailVC = DetailViewController(detailType: type)
        DetailVC.id = id
        
        DetailVC.modalPresentationStyle = .overFullScreen
        vc.present(DetailVC, animated: true)
    }
}
