//
//  NewsStorageTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/12/23.
//

import UIKit

protocol NewsStorageTableViewCellDelegate: AnyObject {
    func didTapHeartButton(id: Int)
}

class NewsStorageTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    weak var delegate: NewsStorageTableViewCellDelegate?
    
    static let identifier = "NewsStorageTableViewCell"
    
    var id: Int!
    
    let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .newdioBlack
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage()
        iv.layer.cornerRadius = 4
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .newdioWhite
        label.numberOfLines = 2
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
    
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_heart_on"), for: .normal)
        button.tintColor = .newdioMain
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
        self.backgroundColor = .newdioBlack
        
        contentView.addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(60)
        }
        
        heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
        contentView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView)
            make.left.equalTo(newsImageView.snp.right).offset(16)
            make.height.equalTo(43)
            make.right.equalTo(heartButton.snp.left).offset(-16)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(newsImageView.snp.right).offset(16)
            make.height.equalTo(17)
            make.right.equalTo(heartButton.snp.left).offset(-16)
         }
    }
    
    //MARK: - Helpers
    
    @objc private func didTapHeartButton() {
        delegate?.didTapHeartButton(id: id)
    }
}
