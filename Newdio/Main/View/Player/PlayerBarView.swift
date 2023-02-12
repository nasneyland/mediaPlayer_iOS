//
//  PlayerBarView.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit

class PlayerBarView: UIView {
    
    // MARK: - Properties
    
    lazy var newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "재생중인 뉴스가 없습니다."
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_play"), for: .normal)
        return button
    }()
    
    private lazy var listButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_list"), for: .normal)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_delete"), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Configure UI
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .newdioGray6
        
        addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
            make.height.equalTo(newsImageView.snp.width)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalTo(newsImageView.snp.right).offset(16)
        }

        addSubview(siteLabel)
        siteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-25)
            make.left.equalTo(newsImageView.snp.right).offset(16)
        }

        addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalTo(siteLabel.snp.right)
            make.width.equalTo(playButton.snp.height)
        }
        
        addSubview(listButton)
        listButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalTo(playButton.snp.right).offset(16)
            make.width.equalTo(listButton.snp.height)
        }

        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.right.equalToSuperview().offset(-16)
            make.left.equalTo(listButton.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(cancelButton.snp.height)
        }
    }
}
