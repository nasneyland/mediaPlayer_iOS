//
//  TopCollectionViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/10.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "topCollectionViewCell"

    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioBlack.withAlphaComponent(0.7)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 5
        label.text = ""
        label.textColor = .newdioWhite
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        label.textAlignment = .left
        label.text = "HOT 10"
        label.textColor = .newdioWhite
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 2
        label.layer.masksToBounds = false
        label.layer.shouldRasterize = true
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_play_white"), for: .normal)
        return button
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        imageView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(120)
        }

        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }

        titleView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-25)
            make.left.equalToSuperview().offset(15)
        }

        titleView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-25)
            make.left.equalTo(categoryLabel.snp.right).offset(20)
            make.width.height.equalTo(60)
        }
        
        // 뉴스 이미지 위에 그라데이션 입히기
        let gradientView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.newdioGray5.withAlphaComponent(1).cgColor, UIColor.newdioGray5.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 100)
        gradientView.layer.addSublayer(gradientLayer)
        
        imageView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}
