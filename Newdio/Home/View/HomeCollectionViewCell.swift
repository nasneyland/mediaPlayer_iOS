//
//  HomeCollectionViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
    
    static let identifier = "homeCollectionViewCell"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = ""
        label.textColor = .newdioWhite
        return label
    }()

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_play_shadow"), for: .normal)
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
            make.top.left.right.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        
        imageView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(25)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
    }
}
