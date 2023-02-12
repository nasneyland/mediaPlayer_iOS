//
//  SecessionViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/09.
//

import UIKit

class SecessionViewController: UIViewController {

    //MARK: - Properties
    
    var titleName: String!
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .newdioWhite
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
        btn.titleLabel?.lineBreakMode = .byWordWrapping
        btn.titleLabel?.textAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(didTapAgree), for: .touchUpInside)
        btn.contentHorizontalAlignment = .left
        btn.contentVerticalAlignment = .top
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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultNav(title: titleName)
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
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
            make.top.equalTo(agreeBtn.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapAgree() {
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
    
    @objc func didTapSignOut() {
        
        if agreeBtn.isSelected == true {
            let alert =  UIAlertController(title: "popup_notification".localized(), message: "popup_secession".localized(), style: UIAlertController.Style.alert)
            let yes =  UIAlertAction(title: "popup_confirm".localized(), style: .default) { (action) in
                LoadingManager.show()
                
                //탈퇴 로그 전송
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "delete"])
                
                SignAPI.signOutAPI(error: {(error) in
                    LoadingManager.hide()
                    self.present(ErrorManager.errorToAlert(error: error), animated: false)
                }) { () in
                    LoadingManager.hide()
                    NotificationCenter.default.post(name: NotificationManager.Main.home, object: nil)
                }
            }
            let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
                yes.setValue(UIColor.newdioMain, forKey: "titleTextColor")
                           alert.addAction(cancel)
                           alert.addAction(yes)
                           alert.view.tintColor =  .newdioWhite
                           present(alert, animated: true, completion: nil)
        }
    }
}
