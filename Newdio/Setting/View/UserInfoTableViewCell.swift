//
//  UserInfoTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/25.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    private let userInfoTableViewCell = "userInfoTableViewCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "로그인을 해주세요."
        label.textColor = .white
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioMain
        button.tintColor = .newdioWhite
        button.setTitle("로그인", for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configureUI() {
        self.selectionStyle = .none
        self.backgroundColor = .black
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
            make.height.equalTo(30)
        }
        
        containerView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.width.equalTo(108)
            make.height.equalTo(48)
        }
    }
}
