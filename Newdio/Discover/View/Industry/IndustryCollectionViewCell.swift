//
//  IndustryCollectionViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/16.
//

import UIKit

class IndustryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "industryCollectionViewCell"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioBlack.withAlphaComponent(0.7)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .newdioWhite
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_play"), for: .normal)
        return button
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
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        imageView.addSubview(imageBackgroundView)
        imageBackgroundView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        imageView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        imageView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(30)
        }
    }
}
