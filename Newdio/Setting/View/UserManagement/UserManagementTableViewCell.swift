//
//  UserManagementTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/29.
//

import UIKit

class UserManagementTableViewCell: UITableViewCell {

    private let userManagementDetailTableViewCell = "userManagementDetailTableViewCell"
    
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
        label.text = "settings_manage_account".localized()
        label.textColor = .newdioGray1
        return label
    }()
    
    private lazy var UserManagermentTableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(UserManagementDetailTableViewCell.self, forCellReuseIdentifier: userManagementDetailTableViewCell)
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
        
        UserManagermentTableView.delegate = self
        UserManagermentTableView.dataSource = self
        
        containerView.addSubview(UserManagermentTableView)
        UserManagermentTableView.snp.makeConstraints { make in
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
        make.left.equalToSuperview().offset(25)
        make.right.equalToSuperview().offset(-25)
        make.bottom.equalToSuperview().offset(-20)
         
        }
        
    }
}

extension UserManagementTableViewCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appInfoListModel.userManagementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserManagermentTableView.dequeueReusableCell(withIdentifier: userManagementDetailTableViewCell, for: indexPath) as! UserManagementDetailTableViewCell
        cell.infoLabel.text = appInfoListModel.userManagementList[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listName = appInfoListModel.userManagementList[indexPath.row].name
        let listURL = appInfoListModel.userManagementList[indexPath.row].url
        
        NotificationCenter.default.post(name: NSNotification.Name("SettingDetail"), object: nil, userInfo: ["name":listName,"url":listURL])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
