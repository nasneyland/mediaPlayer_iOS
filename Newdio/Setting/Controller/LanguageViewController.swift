//
//  LanguageViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/09.
//

import UIKit

class LanguageViewController: UIViewController {

    //MARK: - Properties
    
    var titleName: String!
    var language: String?
    
    let LanguageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .newdioWhite
        label.textAlignment = .center
        label.sizeToFit()
        label.text = "settings_language_title".localized()
        return label
    }()
    
    let LanguageSelectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioGray6
        btn.tintColor = .newdioGray1
        btn.setTitle("", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapSelectLanguage), for: .touchUpInside)
        return btn
    }()
    
    let LanguageCheckButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioMain
        btn.tintColor = .newdioWhite
        btn.setTitle("\("settings_language_button".localized())", for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapCheckLanguage), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureNav() {
        title = self.titleName
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_arrowleft"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(back))
    }
    
    private func configureUI() {
        view.addSubview(LanguageLabel)
        LanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(LanguageSelectButton)
        LanguageSelectButton.snp.makeConstraints { make in
            make.top.equalTo(LanguageLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        view.addSubview(LanguageCheckButton)
        LanguageCheckButton.snp.makeConstraints { make in
            make.top.equalTo(LanguageSelectButton.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        if let lang = UserDefaults.standard.string(forKey: "language") {
            self.LanguageSelectButton.setTitle("settings_language_\(lang)".localized(), for: .normal)
        } else {
            if Locale.current.languageCode == "ko" {
                self.LanguageSelectButton.setTitle("settings_language_ko".localized(), for: .normal)
            } else {
                self.LanguageSelectButton.setTitle("settings_language_en".localized(), for: .normal)
            }
        }
    }
    
    //MARK: - Helpers
    
    @objc func back() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSelectLanguage() {

        let alert =  UIAlertController(title: "", message: "settings_language_type".localized(), preferredStyle: .actionSheet)
        let kr =  UIAlertAction(title: "settings_language_ko".localized(), style: .default) { (action) in
                self.LanguageSelectButton.setTitle("settings_language_ko".localized(), for: .normal)
                self.language = Language.ko.rawValue
            }
            let eng =  UIAlertAction(title: "settings_language_en".localized(), style: .default) { (action) in
                self.LanguageSelectButton.setTitle("settings_language_en".localized(), for: .normal)
                self.language = Language.en.rawValue
            }
        
            let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
        
        kr.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        eng.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        cancel.setValue(UIColor.newdioGray1, forKey: "titleTextColor")

        alert.addAction(kr)
        alert.addAction(eng)
        alert.addAction(cancel)
                
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
    
    @objc private func didTapCheckLanguage() {
        UserDefaults.standard.set(self.language, forKey: "language")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Home"), object: nil)
    }
}
