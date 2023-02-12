//
//  SettingDetailTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/29.
//

import UIKit

class SettingDetailTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "settingDetailTableViewCell"

    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioWhite
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "settings_notice".localized()
        return label
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_general_arrowright"), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
}
