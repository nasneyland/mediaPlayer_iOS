//
//  PlayerBarView.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit

protocol PlayerBarViewDelegate: AnyObject {
    func didTapPlay()
    func didTapList()
    func didTapCancel()
}

class PlayerBarView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PlayerBarViewDelegate?
    
    lazy var newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = .newdioWhite
        return label
    }()
    
    lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.textColor = .newdioWhite
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.setImage(#imageLiteral(resourceName: "ic_general_play"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_list"), for: .normal)
        button.addTarget(self, action: #selector(didTapList), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.setImage(#imageLiteral(resourceName: "ic_general_delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
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
    
    // MARK: - Configure
    
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
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(40)
        }
        
        addSubview(listButton)
        listButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(cancelButton.snp.left).offset(-5)
            make.width.equalTo(50)
        }
        
        addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(listButton.snp.left).offset(-5)
            make.width.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalTo(newsImageView.snp.right).offset(16)
            make.right.equalTo(playButton.snp.left).offset(-10)
        }

        addSubview(siteLabel)
        siteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.equalTo(newsImageView.snp.right).offset(16)
            make.right.equalTo(playButton.snp.left).offset(-10)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapPlay() {
        delegate?.didTapPlay()
    }
    
    @objc func didTapList() {
        delegate?.didTapList()
    }
    
    @objc func didTapCancel() {
        delegate?.didTapCancel()
    }
}
