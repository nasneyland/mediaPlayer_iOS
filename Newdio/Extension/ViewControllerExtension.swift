//
//  ViewControllerExtension.swift
//  Newdio
//
//  Created by najin on 2022/01/30.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 기본 네비게이션
    func setDefaultNav(title: String) {
        self.title = title
        
        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = .newdioGray2
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.newdioGray2]
//        navigationController?.navigationBar.backgroundColor = .newdioBlack
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_arrowleft"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapNavBack))
    }
    
    // 뒤로가기 액션
    @objc func didTapNavBack() {
        navigationController?.popViewController(animated: true)
    }
    
    /// 라지 네비게이션
    func setLargeNav(title: String) {
        self.title = title
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        navigationController?.navigationBar.tintColor = .newdioWhite
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.newdioWhite]
    }
}
