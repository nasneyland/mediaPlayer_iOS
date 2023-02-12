//
//  CompanyListCollectionViewCell.swift
//  Newdio
//
//  Created by najin on 2021/12/13.
//

import UIKit

class CompanyListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private var index = 0
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 44
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.backgroundColor = nil
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = ""
        return label
    }()
    
    let heartButton: UIButton = {
        let image = UIImage(systemName: "suit.heart.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let btn = UIButton()
        btn.backgroundColor = .black.withAlphaComponent(0.7)
        btn.setImage(image, for: .normal)
        btn.tintColor = .green
        btn.isHidden = true
        btn.isUserInteractionEnabled = false
        return btn
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
        
        contentView.backgroundColor = nil
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 88, height: 88))
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView)
            make.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(15)
        }
        
        imageView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
