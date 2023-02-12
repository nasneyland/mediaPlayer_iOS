//
//  LiveTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import UIKit

protocol LiveTableViewCellDelegate: AnyObject {
    func didTapNews(newsId: Int)
    func didTapHashTag(companyId: String, newsId: Int)
}

class LiveTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "liveTableViewCell"
    var delegate: LiveTableViewCellDelegate?
    
    var newsId: Int!
    var companyId = ["","",""]
    
    var sentimentView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = nil
        view.layer.cornerRadius = 4
        return view
    }()
    
    var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .newdioWhite
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var companyNameButton1: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.newdioSkyblue, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(didTapHashTag1), for: .touchUpInside)
        return button
    }()
    
    lazy var companyNameButton2: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.newdioSkyblue, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(didTapHashTag2), for: .touchUpInside)
        return button
    }()
    
    lazy var companyNameButton3: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.newdioSkyblue, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(didTapHashTag3), for: .touchUpInside)
        return button
    }()
    
    lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNews))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    lazy var contentTextView: UITextView = {
        let tv = UITextView()
        let attr = NSMutableAttributedString(string: " ")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        tv.attributedText = attr
        tv.font = UIFont.customFont(size: 15, weight: .regular)
        tv.textColor = .newdioWhite
        tv.backgroundColor = .none
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = true
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNews))
        tv.addGestureRecognizer(tapGesture)
        return tv
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .right
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
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
        self.backgroundColor = .newdioBlack
        self.selectionStyle = .none
        
        contentView.addSubview(categoryNameLabel)
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(24)
        }

        contentView.addSubview(companyNameButton1)
        companyNameButton1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(categoryNameLabel.snp.right).offset(8)
            make.height.equalTo(24)
        }

        contentView.addSubview(companyNameButton2)
        companyNameButton2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(companyNameButton1.snp.right).offset(8)
            make.height.equalTo(24)
        }

        contentView.addSubview(companyNameButton3)
        companyNameButton3.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(companyNameButton2.snp.right).offset(8)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(messageView)
        messageView.snp.makeConstraints { make in
            make.top.equalTo(categoryNameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.left.equalTo(messageView).offset(15)
            make.right.equalTo(messageView).offset(-15)
        }

        contentView.addSubview(sentimentView)
        sentimentView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom)
            make.right.equalTo(messageView.snp.right).offset(-16)
            make.bottom.equalTo(messageView.snp.bottom).offset(-8)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(messageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapNews() {
        self.delegate?.didTapNews(newsId: newsId)
    }
    
    @objc func didTapHashTag1() {
        self.delegate?.didTapHashTag(companyId: companyId[0], newsId: newsId)
    }
    
    @objc func didTapHashTag2() {
        self.delegate?.didTapHashTag(companyId: companyId[1], newsId: newsId)
    }
    
    @objc func didTapHashTag3() {
        self.delegate?.didTapHashTag(companyId: companyId[2], newsId: newsId)
    }
}
