//
//  LanguageViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/09.
//

import UIKit

class LanguageViewController: InputViewController {

    var titleName: String!
    var language: String!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultNav(title: titleName)
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        titleLabel.text = "settings_language_title".localized()
        
        inputButton.addTarget(self, action: #selector(didTapLanguage), for: .touchUpInside)
        
        nextButton.setTitle("settings_language_button".localized(), for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        // 언어 설정 셋팅
        if let lang = CacheManager.getLanguage() {
            self.inputButton.setTitle("settings_language_\(lang)".localized(), for: .normal)
            self.language = lang
        } else {
            if Locale.current.languageCode == "ko" {
                self.inputButton.setTitle("settings_language_ko".localized(), for: .normal)
                self.language = Language.ko.rawValue
            } else {
                self.inputButton.setTitle("settings_language_en".localized(), for: .normal)
                self.language = Language.en.rawValue
            }
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapLanguage() {
        let alert =  UIAlertController(title: "", message: "settings_language_type".localized(), preferredStyle: .actionSheet)
        alert.view.tintColor = .newdioWhite
        
        alert.addAction(UIAlertAction(title: "settings_language_ko".localized(), style: .default) { (action) in
            self.inputButton.setTitle("settings_language_ko".localized(), for: .normal)
            self.language = Language.ko.rawValue
        })
        alert.addAction(UIAlertAction(title: "settings_language_en".localized(), style: .default) { (action) in
            self.inputButton.setTitle("settings_language_en".localized(), for: .normal)
            self.language = Language.en.rawValue
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
    
    @objc func didTapNext() {
        
        //언어 설정 로그 전송
        LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "setting", "language": self.language!])
        
        CacheManager.setLanguage(language: self.language)
        NotificationCenter.default.post(name: NotificationManager.Main.home, object: nil)
    }
}
