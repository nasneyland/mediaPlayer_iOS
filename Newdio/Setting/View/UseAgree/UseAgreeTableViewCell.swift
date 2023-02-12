//
//  UseAgreeTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/29.
//

import UIKit

class UseAgreeTableViewCell: UITableViewCell {
    
    private let userAgreeDetailTableViewCell = "userAgreeDetailTableViewCell"
    
    let appInfoListModel = SettingListModel()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "settings_terms_conditions".localized()
        label.textColor = .newdioGray1
        return label
    }()
    
    private lazy var UserAgreeTableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(UserAgreeDetailTableViewCell.self, forCellReuseIdentifier: userAgreeDetailTableViewCell)
        table.backgroundColor = .clear
        table.contentInsetAdjustmentBehavior = .always
        return table
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        self.selectionStyle = .none
        self.backgroundColor = .black
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(25)
            make.height.equalTo(30)
        }
        
        UserAgreeTableView.delegate = self
        UserAgreeTableView.dataSource = self
        
        containerView.addSubview(UserAgreeTableView)
        UserAgreeTableView.snp.makeConstraints { make in
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
        make.left.equalToSuperview().offset(25)
        make.right.equalToSuperview().offset(-25)
        make.bottom.equalToSuperview().offset(-20)
         
        }
        
    }
}

extension UseAgreeTableViewCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appInfoListModel.useAgreeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserAgreeTableView.dequeueReusableCell(withIdentifier: userAgreeDetailTableViewCell, for: indexPath) as! UserAgreeDetailTableViewCell
        cell.infoLabel.text = appInfoListModel.useAgreeList[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listName = appInfoListModel.useAgreeList[indexPath.row].name
        let listURL = appInfoListModel.useAgreeList[indexPath.row].url
        
        NotificationCenter.default.post(name: NSNotification.Name("SettingDetail"), object: nil, userInfo: ["name":listName,"url":listURL])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}
