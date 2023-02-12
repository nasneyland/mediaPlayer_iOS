//
//  LoginView.swift
//  Newdio
//
//  Created by sg on 2021/11/22.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func didTapConfirm()
    func didTapBack()
    func didTapBackground()
}

class LoginView: UIView {

    //MARK: - Properties
    
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
        button.layer.cornerRadius = 16
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return button
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureGesture() {
        // 배경 터치 이벤트
        let tapLabelGestureRecognizer = UITapGestureRecognizer()
        tapLabelGestureRecognizer.addTarget(self, action: #selector(didTapBackground))
        addGestureRecognizer(tapLabelGestureRecognizer)
    }
    
    private func configureUI() {
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
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
        
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.right.equalTo(-16)
            make.width.height.equalTo(24)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapConfirm() {
//        delegate?.didTapConfirm()
        delegate?.didTapBack()
    }
    
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    
    @objc func didTapBackground() {
        delegate?.didTapBackground()
    }
}
