//
//  CompanyTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/12.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "companyTableViewCell"
    
    var companyList: [Company] = []
    
    lazy var companyCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CompanyCollectionViewCell.self, forCellWithReuseIdentifier: CompanyCollectionViewCell.identifier)
        return collection
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 60, height: 100)
        return layout
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "discover_recommended_company".localized()
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
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(25)
        }
        
        contentView.addSubview(companyCollectionView)
        companyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
       
    }
    
    private func configureCollection() {
        companyCollectionView.delegate = self
        companyCollectionView.dataSource = self
        
        companyCollectionView.backgroundColor = .newdioBlack
        companyCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension CompanyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //추천 기업 리스트 셋팅
    func updateCellWith(row: [Company]) {
        self.companyList = row
        self.companyCollectionView.reloadData()
        self.companyCollectionView.setContentOffset(.zero, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = companyCollectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.identifier, for: indexPath) as! CompanyCollectionViewCell
        
        //기업 이름 셋팅
        cell.nameLabel.text = companyList[indexPath.row].name
        
        //기업 로고 이미지 셋팅
        let url = URL(string: companyList[indexPath.row].logoURL ?? "")
        cell.imageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let companyId = companyList[indexPath.row].id ?? ""
        
        NotificationCenter.default.post(name: NotificationManager.Discover.company, object: nil, userInfo: ["id": companyId])
        
        // 추천 기업 클릭 로그 전송
        LogManager.sendLogData(screen: .discover, action: .click, params: ["type": "recommend_co", "co_id": companyId, "position": indexPath.row, "max_position": companyList.count - 1])
    }
}
