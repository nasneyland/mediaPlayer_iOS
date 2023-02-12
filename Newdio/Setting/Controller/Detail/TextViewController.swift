//
//  TextViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/15.
//

import UIKit

class TextViewController: InputViewController {

    var titleName: String!
    var textSize: String!

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultNav(title: titleName)
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        titleLabel.text = "settings_text_prefer".localized()
        
        inputButton.addTarget(self, action: #selector(didTapTextSize), for: .touchUpInside)
        
        nextButton.setTitle("settings_language_button".localized(), for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        // 텍스트 크기 셋팅
        let size = CacheManager.getTextSize()
        self.inputButton.setTitle("settings_text_\(size)".localized(), for: .normal)
        self.textSize = size
    }
    
    //MARK: - Helpers
    
    @objc private func didTapTextSize() {

        let alert =  UIAlertController(title: "", message: "settings_text_select".localized(), preferredStyle: .actionSheet)
        alert.view.tintColor = .newdioWhite
        
        alert.addAction(UIAlertAction(title: "settings_text_small".localized(), style: .default) { (action) in
            self.inputButton.setTitle("settings_text_small".localized(), for: .normal)
            self.textSize = TextSize.small.rawValue
        })
        alert.addAction(UIAlertAction(title: "settings_text_original".localized(), style: .default) { (action) in
            self.inputButton.setTitle("settings_text_original".localized(), for: .normal)
            self.textSize = TextSize.original.rawValue
        })
        alert.addAction(UIAlertAction(title: "settings_text_large".localized(), style: .default) { (action) in
            self.inputButton.setTitle("settings_text_large".localized(), for: .normal)
            self.textSize = TextSize.large.rawValue
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
        
        //텍스트 크기 로그 전송
        switch self.textSize {
        case TextSize.original.rawValue:
            LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "setting", "text_size": 0])
        case TextSize.small.rawValue:
            LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "setting", "text_size": -1])
        case TextSize.large.rawValue:
            LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "setting", "text_size": 1])
        default:
            LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "setting", "text_size": 0])
        }
        
        CacheManager.setTextSize(textSize: self.textSize)
        
        navigationController?.popViewController(animated: true)
    }
}
