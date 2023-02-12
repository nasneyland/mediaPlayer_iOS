//
//  CompanyRankListTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/12.
//

import UIKit

class CompanyRankListTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "companyRankListTableViewCell"
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioGray2
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioMain
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioWhite
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = ""
        return label
    }()
    
    let industryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioGray1
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = ""
        return label
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_general_arrowright"), for: .normal)
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
        backgroundColor = .newdioGray4
        selectionStyle = .none
        
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-7)
            make.centerY.equalToSuperview()
            make.width.equalTo(logoImageView.snp.height)
        }
        
        contentView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(30)
        }
        
        contentView.addSubview(changeLabel)
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.top.equalTo(rankLabel.snp.bottom)
            make.width.equalTo(30)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(rankLabel.snp.right).offset(5)
        }

        contentView.addSubview(industryLabel)
        industryLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.left.equalTo(rankLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
        }

//        contentView.addSubview(infoButton)
//        infoButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-15)
//            make.left.equalTo(nameLabel.snp.right)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(20)
//        }
    }
}
