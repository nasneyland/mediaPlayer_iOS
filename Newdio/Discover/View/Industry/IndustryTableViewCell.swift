//
//  IndustryTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/12.
//

import UIKit

class IndustryTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "industryTableViewCell"
    
    var industryList: [Industry] = []
    
    lazy var industryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(IndustryCollectionViewCell.self, forCellWithReuseIdentifier: IndustryCollectionViewCell.identifier)
        return collection
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        layout.itemSize = CGSize(width: 150, height: 70)
        return layout
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "discover_industry_list".localized()
        label.textColor = .newdioWhite
        return label
    }()
    
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.backgroundColor = .newdioBlack
        self.selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        contentView.addSubview(industryCollectionView)
        industryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    private func configureCollection() {
        industryCollectionView.delegate = self
        industryCollectionView.dataSource = self
        
        industryCollectionView.backgroundColor = .newdioBlack
        industryCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension IndustryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //산업 리스트 셋팅
    func updateCellWith(row: [Industry]) {
        self.industryList = row
        self.industryCollectionView.reloadData()
        
        self.industryCollectionView.setContentOffset(.zero, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return industryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = industryCollectionView.dequeueReusableCell(withReuseIdentifier: IndustryCollectionViewCell.identifier, for: indexPath) as! IndustryCollectionViewCell
        
        //산업 이름 셋팅
        cell.nameLabel.text = industryList[indexPath.row].name
        
        //산업 로고 이미지 셋팅
        let url = URL(string: industryList[indexPath.row].logoURL ?? "")
        cell.imageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let industryId = industryList[indexPath.row].id ?? ""
        
        NotificationCenter.default.post(name: NotificationManager.Discover.industry, object: nil, userInfo: ["id": industryId])
        
        // 산업 리스트 클릭 로그 전송
        LogManager.sendLogData(screen: .discover, action: .click, params: ["type": "list_in", "in_id": industryId, "position": indexPath.row])
    }
}
