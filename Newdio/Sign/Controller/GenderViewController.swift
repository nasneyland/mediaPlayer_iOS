//
//  GenderViewController.swift
//  Newdio
//
//  Created by 박지영 on 2021/11/01.
//

import UIKit
import SnapKit

class GenderViewController: InputViewController {
    
    var user: User!
    var gender: Gender?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultNav(title: "")
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        titleLabel.text = "social_login_gender_info".localized()
        
        inputButton.setTitle("", for: .normal)
        inputButton.addTarget(self, action: #selector(didTapGender), for: .touchDown)
        
        nextButton.setTitle("common_next".localized(), for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        disabledButton()
    }
    
    //MARK: - Helpers
    
    @objc func didTapNext() {
        user.gender = gender
        
        let vc = FavoriteViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func didTapGender() {
        let alert = UIAlertController(title: "social_login_gender_info".localized(), message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .newdioWhite
      
        // 색상 변경
        alert.addAction(UIAlertAction(title: "social_login_male".localized(), style: .default, handler: { (action) in
            self.setGender(gender: .man, text: "social_login_male".localized())
        }))
        alert.addAction(UIAlertAction(title: "social_login_female".localized(), style: .default, handler: { (action) in
            self.setGender(gender: .woman, text: "social_login_female".localized())
        }))
        alert.addAction(UIAlertAction(title: "social_login_genderless".localized(), style: .default, handler: { (action) in
            self.setGender(gender: .none, text: "social_login_genderless".localized())
        }))
        alert.addAction(UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil))
                      
        //디바이스 타입이 iPad일때
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                // ActionSheet가 표현되는 위치를 저장해줍니다.
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 선택한 성별 셋팅
    private func setGender(gender: Gender, text: String) {
        self.gender = gender
        
        self.inputButton.setTitle(text, for: .normal)
        self.inputButton.tintColor = .newdioWhite

        enabledButton()
    }
}
