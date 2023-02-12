//
//  StorageTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/12/17.
//

import UIKit

protocol StorageTableViewCellDelegate: AnyObject {
    func didTapHeartButton(id: String)
}

class StorageTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    weak var delegate: StorageTableViewCellDelegate?
    
    static let identifier = "StorageTableViewCell"
    
    var id: String!
    
    lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "TITLE"
        label.textColor = .newdioWhite
        return label
    }()
    
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_heart_on"), for: .normal)
        button.tintColor = .newdioMain
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .newdioBlack
        selectionStyle = .none
        
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
        }
        
        heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
        contentView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(logoImageView.snp.right).offset(16)
            make.right.equalTo(heartButton.snp.left).offset(-16)
        }
    }
    
    //MARK: - Helpers
    
    @objc private func didTapHeartButton() {
        delegate?.didTapHeartButton(id: id)
    }
}
