//
//  UseEnvDetailTableViewCell.swift
//  Newdio
//
//  Created by najin on 2022/01/22.
//

import UIKit

class UseEnvDetailTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "useEnvDetailTableViewCell"

    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioWhite
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "settings_notice".localized()
        return label
    }()
    
    let infoDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioGray2
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = ""
        return label
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_general_arrowright"), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        contentView.addSubview(infoDetailLabel)
        infoDetailLabel.snp.makeConstraints { make in
            make.right.equalTo(infoButton.snp.left).offset(-2)
            make.centerY.equalToSuperview()
        }
        
        
    }
}
