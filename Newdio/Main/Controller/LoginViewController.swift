//
//  LoginViewController.swift
//  Newdio
//
//  Created by sg on 2021/11/22.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 하시고 경제소식을 감상해보세요."
        label.textColor = .newdioWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private var checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioMain
        button.tintColor = .newdioWhite
        button.setTitle("로그인", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 11)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .newdioGray5

        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(messageLabel)
        view.addSubview(checkButton)
        view.addSubview(backButton)
        viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.centerX.equalTo(view)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(12)
            make.centerX.equalTo(view)
            make.width.equalTo(54)
            make.height.equalTo(24)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.right.equalTo(-16)
            make.width.height.equalTo(24)
            
        }
    
    }
    
    func alertMessage() {
        let alert = UIAlertController(title: "popup_notification".localized(), message: "\n \("popup_update".localized())", preferredStyle: UIAlertController.Style.alert)
                    
        let ok = UIAlertAction(title: "popup_confirm".localized(), style: .default, handler: nil)
                    alert.addAction(ok)
                    present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapLoginButton() {
        alertMessage()
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
}
