//
//  ErrorView.swift
//  Newdio
//
//  Created by najin on 2021/11/07.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func didTapRetry()
}

class ErrorView: UIView {

    // MARK: - Properties
    
    weak var delegate: ErrorViewDelegate?
    
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "error_network_title".localized()
        label.textColor = .newdioGray1
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "error_network_subtitle".localized()
        label.textColor = .newdioGray1
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private var retryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioMain
        button.tintColor = .newdioWhite
        button.setTitle("common_retry".localized(), for: .normal)
        button.layer.cornerRadius = 24
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()
    
    private var errorImage: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "ic_general_wifi_off")
        return imv
    }()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, type: ErrorType) {
        super.init(frame: frame)
        configureUI(type: type)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI(type: .network)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI(type: .network)
    }
    
    // MARK: - Configure UI
    
    private func configureUI(type: ErrorType) {
        backgroundColor = .newdioBlack
        
        switch type {
        case .server:
            errorLabel.text = "error_server_title".localized()
            descriptionLabel.text = "error_server_subtitle".localized()
        case .network:
            errorLabel.text = "error_network_title".localized()
            descriptionLabel.text = "error_network_subtitle".localized()
        case .tokenInvalid:
            errorLabel.text = "error_401_title".localized()
            descriptionLabel.text = "error_401_content".localized()
        case .userInvalid:
            errorLabel.text = "error_user_title".localized()
            descriptionLabel.text = "error_user_content".localized()
        case .userExist:
            errorLabel.text = "error_user_title".localized()
            descriptionLabel.text = "error_user_content".localized()
        }
        
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        addSubview(retryButton)
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(48)
        }
        
        addSubview(errorImage)
        errorImage.snp.makeConstraints { make in
            make.bottom.equalTo(errorLabel.snp.top).offset(-8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
        }
    }
    
    // MARK: - Helpers
    
    @objc func didTapRetry() {
        self.delegate?.didTapRetry()
    }
}
