//
//  JoinViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/27.
//

import UIKit

class JoinViewController: UIViewController {

    //MARK: - Properties
    
    private let joinLabel: UILabel = {
        let label = UILabel()
        label.text = "social_login_join_complete".localized()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .newdioGray1
        label.numberOfLines = 2
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioMain
        button.tintColor = .newdioWhite
        button.setTitle("social_login_continue".localized(), for: .normal)
        button.layer.cornerRadius = 24
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        view.addSubview(joinLabel)
        joinLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(143)
            make.height.equalTo(48)
            make.top.equalTo(joinLabel.snp.bottom).offset(48)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapNext() {
        NotificationCenter.default.post(name: NotificationManager.Main.home, object: nil)
    }
}
