//
//  InputViewController.swift
//  Newdio
//
//  Created by najin on 2022/01/31.
//

import UIKit

class InputViewController: UIViewController {

    //MARK: - Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioWhite
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var inputButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioGray6
        btn.tintColor = .newdioWhite
        btn.setTitle("", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        btn.setTitleColor(.newdioWhite, for: .normal)
        btn.layer.cornerRadius = 16
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        return btn
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 16
        button.backgroundColor = .newdioMain
        button.isEnabled = true
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
        
//        view.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(15)
//            make.right.equalToSuperview().offset(-15)
//            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
//        }
        
        view.addSubview(inputButton)
        inputButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(48)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(inputButton.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
    }
    
    //MARK: - Helpers
    
    func enabledButton() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = .newdioMain
    }
    
    func disabledButton() {
        nextButton.isEnabled = false
        nextButton.backgroundColor = .newdioGray6
    }
}
