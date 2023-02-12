//
//  AutoPlayViewController.swift
//  Newdio
//
//  Created by najin on 2022/01/22.
//

import UIKit

class AutoPlayViewController: InputViewController {

    var titleName: String!
    var autoPlay: String!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultNav(title: titleName)
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        titleLabel.text = "settings_auto_play_please".localized()
        
        inputButton.addTarget(self, action: #selector(didTapAutoPlay), for: .touchUpInside)
        
        nextButton.setTitle("settings_language_button".localized(), for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        // 자동 재생 모드 셋팅
        self.autoPlay = CacheManager.getAutoPlay()
        self.inputButton.setTitle("settings_auto_play_\(autoPlay!)".localized(), for: .normal)
    }
    
    //MARK: - Helpers
    
    @objc private func didTapAutoPlay() {
        let alert =  UIAlertController(title: "", message: "settings_auto_play_please".localized(), preferredStyle: .actionSheet)
        alert.view.tintColor = .newdioWhite
        
        alert.addAction(UIAlertAction(title: "settings_auto_play_on".localized(), style: .default) { (action) in
            self.inputButton.setTitle("settings_auto_play_on".localized(), for: .normal)
            self.autoPlay = AutoPlay.on.rawValue
        })
        alert.addAction(UIAlertAction(title: "settings_auto_play_off".localized(), style: .default) { (action) in
            self.inputButton.setTitle("settings_auto_play_off".localized(), for: .normal)
            self.autoPlay = AutoPlay.off.rawValue
        })
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
    
    @objc private func didTapNext() {
        
        //자동 재생 모드 로그 전송
        if self.autoPlay == AutoPlay.on.rawValue {
            LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "setting", "auto_play": 1])
        } else {
            LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "setting", "auto_play": 0])
        }
        
        CacheManager.setAutoPlay(autoPlay: self.autoPlay)
        navigationController?.popViewController(animated: true)
    }
}
