//
//  UserInfoTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/25.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "userSettingTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "settings_please_login".localized()
        label.textColor = .newdioWhite
        return label
    }()
    
    private let socialButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        return button
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .newdioWhite
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioMain
        button.tintColor = .newdioWhite
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 21
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        refreshUserInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Configure
    
    private func configureUI() {
        self.selectionStyle = .none
        self.backgroundColor = .newdioBlack
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.width.equalTo(96)
            make.height.equalTo(42)
        }
    }
    
    private func configureView(active: Bool) {
        socialButton.isHidden = !active
        emailLabel.isHidden = !active
        titleLabel.isHidden = active
    }
    
    // 회원정보 새로고침
    func refreshUserInfo() {
        if APIManager.isUser() {
            //회원 전용
            configureView(active: true)
            
            loginButton.addTarget(self, action: #selector(didTapStorage), for: .touchUpInside)
            loginButton.setTitle("settings_my_favorite".localized(), for: .normal)
            
            //소셜 셋팅
            let social = APIManager.getSocial()
            socialButton.setImage(UIImage(named: "img_general_\(social)_square"), for: .normal)
            socialButton.setTitle("social_account_\(social)".localized(), for: .normal)
            
            //메일 셋팅
            emailLabel.text = APIManager.getEmail()
            
            containerView.addSubview(socialButton)
            socialButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(30)
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(loginButton.snp.left).offset(-10)
                make.height.equalTo(32)
            }
            
            containerView.addSubview(emailLabel)
            emailLabel.snp.makeConstraints { make in
                make.top.equalTo(socialButton.snp.bottom)
                make.left.equalToSuperview().offset(20)
                make.right.equalTo(loginButton.snp.left).offset(-10)
                make.bottom.equalToSuperview().offset(-30)
            }
        } else {
            //비회원 전용
            configureView(active: false)
            
            loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
            loginButton.setTitle("popup_login".localized(), for: .normal)
            
            containerView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(16)
                make.height.equalTo(30)
            }
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapLogin() {
        NotificationCenter.default.post(name: NotificationManager.Setting.login, object: nil, userInfo:nil)
    }
    
    @objc func didTapStorage() {
        NotificationCenter.default.post(name: NotificationManager.Setting.storage, object: nil, userInfo:nil)
    }
}
