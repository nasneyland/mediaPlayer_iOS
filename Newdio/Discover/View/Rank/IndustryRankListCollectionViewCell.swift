//
//  IndustryRankListCollectionViewCell.swift
//  Newdio
//
//  Created by najin on 2021/11/24.
//

import UIKit

class IndustryRankListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "industryRankListCollectionViewCell"
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioMain
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = ""
        label.textAlignment = .right
        return label
    }()
    
    let changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioGray2
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    let nameLabel: UILabel = {
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
    
    let navigateImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        contentView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(20)
        }
        
//        contentView.addSubview(changeLabel)
//        changeLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(rankLabel.snp.right)
//            make.width.equalTo(30)
//        }
        
        
//        contentView.addSubview(infoButton)
//        infoButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-5)
//            make.width.height.equalTo(20)
//        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(rankLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-5)
        }
    }
}
