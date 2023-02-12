//
//  LoginView.swift
//  Newdio
//
//  Created by sg on 2021/11/22.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func didTapCheckButton()
    func didTapBackButton()
    func didTapBackgroundView()
}

class LoginView: UIView {

    weak var delegate: LoginViewDelegate?
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4.withAlphaComponent(0.9)
        view.layer.cornerRadius = 15
        view.isOpaque = false
        return view
    }()
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "popup_request_login".localized()
        label.textColor = .newdioWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private var checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioMain
        button.tintColor = .newdioWhite
        button.setTitle("popup_login".localized(), for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 11)
        button.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        return button
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        let tapLabelGestureRecognizer = UITapGestureRecognizer()
        tapLabelGestureRecognizer.addTarget(self, action: #selector(didTapBackgroundView))
        addGestureRecognizer(tapLabelGestureRecognizer)
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(122)
        }
        
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(54)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.right.equalTo(-16)
            make.width.height.equalTo(24)
        }
    }
    
    @objc private func didTapCheckButton() {
        delegate?.didTapCheckButton()
    }
    
    @objc private func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc private func didTapBackgroundView() {
        delegate?.didTapBackgroundView()
    }
}
