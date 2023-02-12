//
//  ComListCollectionViewCell.swift
//  Newdio
//
//  Created by SG on 2021/11/16.
//

import UIKit
import SnapKit

class ComListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ComListCollectionViewCell"
    private var index = 0
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.backgroundColor = nil
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = "회사명"
        return label
    }()
    
    let heartButton: UIButton = {
        let image = UIImage(systemName: "suit.heart.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
          
          let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.tintColor = .green
        btn.isHidden = true
        btn.isUserInteractionEnabled = false
          return btn
    }()
  
    
    
    //MARK:- Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(heartButton)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Configure
    
    private func configureUI() {
        
        contentView.backgroundColor = nil
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 88, height: 88))
            make.centerX.equalToSuperview()
        }
        
        imageView.layer.cornerRadius = 44
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(named: "systemGreen")?.cgColor
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView)
            make.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(5)
          //  make.size.equalTo(CGSize(width: 88, height: 35))
        }
        
        heartButton.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.centerY.equalTo(imageView)
        }
    }
}
