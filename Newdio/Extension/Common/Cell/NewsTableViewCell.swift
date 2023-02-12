//
//  NewsTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/11.
//

import UIKit
import SnapKit

class NewsTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "PlayListTableViewCell"

    lazy var newsImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = ""
        label.textColor = .newdioWhite
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.text = ""
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
        backgroundColor = .newdioBlack
        selectionStyle = .none
        
        contentView.addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(60)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView)
            make.left.equalTo(newsImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(43)
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(newsImageView.snp.right).offset(16)
            make.height.equalTo(17)
        }
    }
}
