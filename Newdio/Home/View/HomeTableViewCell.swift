//
//  HomeTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import UIKit
import Kingfisher

protocol CollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: HomeCollectionViewCell?, index: Int, didTappedInTableViewCell: HomeTableViewCell)
}

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "homeTableViewCell"
    
    var cellDelegate: CollectionViewCellDelegate?
    var category: Category?
    
    lazy var homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 120, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    private lazy var playAllBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("player_listen_all".localized(), for: .normal)
        btn.tintColor = .newdioGray1
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(playAll), for: .touchUpInside)
        return btn
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .newdioWhite
        return label
    }()
    
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCollection()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureCollection() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        homeCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        homeCollectionView.backgroundColor = .newdioBlack
        homeCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureUI() {
        self.selectionStyle = .none
        self.backgroundColor = .newdioBlack
        
        contentView.addSubview(playAllBtn)
        playAllBtn.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-16)
            make.width.equalTo(60)
        }
        
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(16)
            make.right.equalTo(playAllBtn.snp.left).offset(-10)
        }
        
        contentView.addSubview(homeCollectionView)
        homeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.bottom.equalToSuperview()
        }
    }
    
    // 전체듣기 버튼 클릭 이벤트
    @objc func playAll() {
        
        // 토픽 뉴스 전체듣기 클릭 로그 전송
        LogManager.sendLogData(screen: .newdio, action: .click, params: ["type": "play_all", "category": category?.name ?? "", "keyword": category?.id ?? ""])
        
        PlayerPresenter.playListPlayer(newsList: category?.newsList ?? [])
    }
}

//MARK: - Table View delegate

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    //뉴스 데이터 셋팅
    func updateCellWith(row: Category) {
        self.category = row
        self.homeCollectionView.reloadData()
        
        self.homeCollectionView.setContentOffset(.zero, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.category?.newsList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        let news = category?.newsList[indexPath.item]
        
        //뉴스 제목 셋팅
        cell.titleLabel.text = news?.title ?? ""
        
        //뉴스 이미지 셋팅
        let url = URL(string: news?.imageURL ?? "")
        cell.imageView.kf.setImage(with: url)
        
        //캐싱된 뉴스 읽음처리
        if CacheManager.isCachedNews(id: news?.id ?? 0) {
            cell.titleLabel.textColor = UIColor.newdioGray2
        } else {
            cell.titleLabel.textColor = UIColor.newdioWhite
        }

        return cell
    }

    //뉴스 클릭 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell
        
        //뉴스 읽음 처리
        cell?.titleLabel.textColor = .newdioGray2
        
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}
