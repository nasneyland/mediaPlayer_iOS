//
//  AppInfoDetailTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/25.
//

import UIKit

class AppInfoDetailTableViewCell: UITableViewCell {

    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioWhite
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = ""
        return label
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_general_arrowright"), for: .normal)
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
        backgroundColor = .newdioGray4
        selectionStyle = .none
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            
            
        }
    }

}
