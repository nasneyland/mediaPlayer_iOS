//
//  CompanySearchTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/12/16.
//

import UIKit

class CompanySearchTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "CompanySearchTableViewCell"
    
    lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .gray
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "TITLE"
        label.textColor = .white
        return label
    }()
    
    let industryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.text = "site"
        label.textColor = .newdioGray1
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalTo(logoImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(industryLabel)
        industryLabel.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom)
            make.left.equalTo(logoImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
