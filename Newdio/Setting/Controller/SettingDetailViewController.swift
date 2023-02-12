//
//  SettingDetailViewController.swift
//  Newdio
//
//  Created by sg on 2021/11/29.
//

import UIKit
import WebKit

class SettingDetailViewController: UIViewController {

    var recieveUrl = ""
    var recieveName = ""
    var recieveWebCheck = ""
    
    var language: String?
    
    /*
     View 분리 예정
     */
    
    // 버전정보
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "ic_general_newdio.png")
        return iv
    }()
    
    let versionTitleLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "settings_current_version".localized()
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .newdioMain
        label.textAlignment = .center
        label.text = "0.0.0"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [versionTitleLabel, versionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        return stackView
    }()
    
    // 회원탈퇴
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 2
        label.text = "settings_secession_title".localized()
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .newdioGray2
        label.textAlignment = .center
        label.sizeToFit()
        label.text = "settings_secession_subtitle".localized()
        label.numberOfLines = 3
        return label
    }()

    var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .newdioGray2
   //     label.textAlignment = .center
        label.sizeToFit()
        label.text = "\("settings_secession_content1".localized()) \n\n\("settings_secession_content2".localized()) \n\n\("settings_secession_content3".localized())"
        label.numberOfLines = 10
        return label
    }()
    
    let agreeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName:"circle"), for: .normal)
        btn.tintColor = .newdioGray2
        btn.setTitle("settings_secession_check".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.setTitleColor(.newdioGray2, for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(didTapAgreeBtn), for: .touchUpInside)
        return btn
    }()
    
    private var checkButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioGray6
        btn.tintColor = .newdioWhite
        btn.setTitle("settings_secession".localized(), for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        return btn
    }()
    
    
    // 언어 설정
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        configureNav()
        print("\(self.recieveName)")
        
        if self.recieveName == "settings_version_info".localized() {
            configureVersionUI()
        } else if self.recieveName == "settings_secession".localized() {
            configureSecessionUI()
        } else if self.recieveName == "settings_language".localized() {
            configureLanguageUI()
        }
        
        print("[Log_Language]: 현재언어 \(Locale.current.languageCode)")
    }
    
    private func configureNav() {
        title = self.recieveName
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_arrowleft"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(back))
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func back() {
        
        navigationController?.popViewController(animated: true)
    }
    
    private func configureVersionUI() {
        
        //버전 정보 셋팅
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else { return }
        
        versionLabel.text = "\(version).\(build)"
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    
    }
    
    private func configureSecessionUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
//            make.height.equalTo(24)
        }
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(56)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(agreeBtn.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    private func configureLanguageUI() {
        view.addSubview(LanguageLabel)
        LanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(LanguageSelectButton)
        LanguageSelectButton.snp.makeConstraints { make in
            make.top.equalTo(LanguageLabel.snp.bottom).offset(24)
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
    
    @objc private func didTapAgreeBtn() {
        agreeBtn.isSelected = !agreeBtn.isSelected
 
        if agreeBtn.isSelected == true {
            agreeBtn.setImage(UIImage(systemName:"checkmark.circle.fill"), for: .normal)
            agreeBtn.tintColor = .newdioMain
            agreeBtn.setTitleColor(.newdioMain, for: .normal)
            checkButton.backgroundColor = .newdioMain
        }
        else {
            agreeBtn.setImage(UIImage(systemName:"circle"), for: .normal)
            agreeBtn.tintColor = .newdioGray2
            agreeBtn.setTitleColor(.newdioGray2, for: .normal)
            checkButton.backgroundColor = .newdioGray6
        }
        
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
        
            kr.setValue(UIColor(hex: "#BBBBBB"), forKey: "titleTextColor")
            eng.setValue(UIColor(hex: "#BBBBBB"), forKey: "titleTextColor")
            cancel.setValue(UIColor(hex: "#BBBBBB"), forKey: "titleTextColor")

            alert.addAction(kr)
            alert.addAction(eng)
            alert.addAction(cancel)
                    
            present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapCheckLanguage() {
        UserDefaults.standard.set(self.language, forKey: "language")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Home"), object: nil)
    }
    
    @objc private func didTapSignOut() {
        
        if agreeBtn.isSelected == true {
        
        let alert =  UIAlertController(title: "common_notice".localized(), message: "\n \("popup_secession".localized())", preferredStyle:  UIAlertController.Style.alert)
        let yes =  UIAlertAction(title: "popup_confirm".localized(), style: .default) { (action) in
                       }
        let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
                       yes.setValue(UIColor(hex: "#69DB7C"), forKey: "titleTextColor")
                       alert.addAction(cancel)
                       alert.addAction(yes)
                       alert.view.tintColor =  UIColor(ciColor: .white)
                       present(alert, animated: true, completion: nil)
        }
    }
}

