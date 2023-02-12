//
//  IndustryRankTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/11/24.
//

import UIKit

class IndustryRankTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "industryRankTableViewCell"
    
    var industryList: [RankIndustry] = []
    
    lazy var industryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(IndustryRankListCollectionViewCell.self, forCellWithReuseIdentifier: IndustryRankListCollectionViewCell.identifier)
        collection.isScrollEnabled = false
        return collection
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: (screenWidth - 80) / 2, height: 40)
        return layout
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .newdioGray1
        label.text = String(format: "search_criteria".localized(), "00:00")
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_general_info_on_small"), for: .normal)
        btn.tintColor = .newdioGray1
        return btn
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "discover_hot_rank_industry".localized()
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
        self.selectionStyle = .none
        self.backgroundColor = .newdioBlack
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.right.equalTo(-20)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        containerView.addSubview(updateTimeLabel)
        updateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.right.equalTo(infoButton.snp.left)
            make.height.equalTo(30)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(25)
            make.right.equalTo(updateTimeLabel.snp.left).offset(-10)
            make.height.equalTo(30)
        }
        
        containerView.addSubview(industryCollectionView)
        industryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func configureCollection() {
        industryCollectionView.delegate = self
        industryCollectionView.dataSource = self
        
        industryCollectionView.backgroundColor = .none
        industryCollectionView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: - Helpers
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension IndustryRankTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    //기업 리스트 셋팅
    func updateIndustryCellWith(industry: [RankIndustry]) {
        self.industryList = industry
        industryCollectionView.reloadData()
    }
    
    //cell count 셋팅
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return industryList.count
    }
    
    //cell data 셋팅
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = industryCollectionView.dequeueReusableCell(withReuseIdentifier: IndustryRankListCollectionViewCell.identifier, for: indexPath) as! IndustryRankListCollectionViewCell
        cell.rankLabel.text = "\(indexPath.row + 1)"
        
        let change = industryList[indexPath.row].change
        
        if change == "new" {
            cell.changeLabel.text = "NEW"
        } else {
            if let change = Int(change) {
                if change == 0 {
                    cell.changeLabel.text = "⏤"
                } else if change > 0 {
                    cell.changeLabel.text = "▲ \(abs(change))"
                } else {
                    cell.changeLabel.text = "▼ \(abs(change))"
                }
            }
        }
        cell.nameLabel.text = industryList[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let industryId = industryList[indexPath.row].id ?? ""
        
        NotificationCenter.default.post(name: NotificationManager.Discover.industry, object: nil, userInfo: ["id": industryId])
        
        // 일간 기업 클릭 로그 전송
        LogManager.sendLogData(screen: .discover, action: .click, params: ["type": "rank_in", "in_id": industryId, "position": indexPath.row])
    }
}
