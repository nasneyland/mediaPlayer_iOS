//
//  DetailHeaderTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/12/01.
//

import UIKit

class DetailHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    private let detailHeaderTableViewCell = "detailHeaderTableViewCell"
    
    let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage()
        iv.layer.cornerRadius = 48
        iv.backgroundColor = .gray
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .white
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .newdioGray1
        return label
    }()
    
    let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioMain
        button.tintColor = .newdioWhite
        button.setTitle("player_listen_all".localized(), for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        return button
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
        self.selectionStyle = .none
        self.backgroundColor = .black
        
        contentView.isUserInteractionEnabled = true
        
        addSubview(headerImageView)
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(96)
        }
        
        addSubview(playAllButton)
        playAllButton.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(48)
        }
        
       addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalTo(headerImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.left.equalTo(titleLabel)
            make.height.equalTo(30)
         }
    }
}
