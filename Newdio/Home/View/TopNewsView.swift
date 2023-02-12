//
//  TopNewsView.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import UIKit

class TopNewsView: UIView {
    
    //MARK: - Properties
    
//    var topNews: NewsModel!
    
    /// TOP news 배경 이미지
    private var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        return iv
    }()
    
    /// TOP news 제목
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.sizeToFit()
        return label
    }()
    
    /// TOP news 플레이 버튼
    private var playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_play_big"), for: .normal)
        button.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        return button
    }()
    
    /// TOP news 페이지 라벨
    private var pageLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.backgroundColor = .newdioGray.withAlphaComponent(0.8)
        label.layer.cornerRadius = 15
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "0/0"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    //MARK:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    convenience init(total: Int, index: Int, news: NewsModel) {
//        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        self.topNews = news
//
//        configureUI()
//        setTopNewsData()
//    }
    
    //MARK:- Configure
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }
        self.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.height.width.equalTo(60)
        }
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.right.equalTo(self).offset(-25)
            make.left.equalTo(self).offset(25)
        }
        self.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.width.equalTo(55)
            make.height.equalTo(30)
        }
    }
    
    //MARK:- Helpers
    
//    func setTopNewsData() {
//        backgroundImageView.setImageUrl(url: self.topNews.imageURL!)
//        titleLabel.text = self.topNews.title
//    }
    
    @objc fileprivate func clickPlayButton() {
//        print(self.topNews.id)
    }
}
