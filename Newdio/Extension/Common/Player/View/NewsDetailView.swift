//
//  NewsDetailView.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import UIKit

class NewsDetailView: UIView {
    
 
    // MARK: - Properties
    
    var detailScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var siteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .newdioGray1
        label.textAlignment = .left
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .newdioGray1
        label.textAlignment = .right
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 5
        label.sizeToFit()
        return label
    }()
    
    var newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var gradientView: UIView = {
        let gradientView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(1).cgColor, UIColor.black.withAlphaComponent(0.2).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 370)
        gradientView.layer.addSublayer(gradientLayer)
        return gradientView
    }()
    
    var contentTextView: UITextView = {
        let tv = UITextView()
        let attr = NSMutableAttributedString(string: " ")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        tv.attributedText = attr
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        tv.backgroundColor = .none
        tv.sizeToFit()
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.isSelectable = true
        tv.showsVerticalScrollIndicator = false
        return tv
    }()

    // MARK: - Lifecycle
   
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
        backgroundColor = .black
        
//        addSubview(detailScrollView)
//        detailScrollView.snp.makeConstraints { make in
//            make.top.bottom.left.right.equalToSuperview()
//        }

//        addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.top.bottom.left.right.equalToSuperview()
//            make.width.equalTo(detailScrollView.frameLayoutGuide)
//        }

        addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(430)
            make.top.equalToSuperview().offset(370)
            make.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
        }
        
        addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(370)
        }
        
        newsImageView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(370)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
//            make.bottom.equalTo(contentTextView.snp.top).offset(-160)
            make.bottom.equalTo(contentTextView.snp.top).offset(-50)
        }
        
        addSubview(siteLabel)
        siteLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-17)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(30)
        }

        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-17)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }

//        contentView.sendSubviewToBack(newsImageView)
    }
}
