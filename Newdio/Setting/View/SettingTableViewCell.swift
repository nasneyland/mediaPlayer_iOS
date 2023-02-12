//
//  SettingTableViewCell.swift
//  Newdio
//
//  Created by najin on 2022/01/22.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "settingTableViewCell"
    
    var settingType: SettingType?
    var settingModel: [SettingModel] = []
    
    private let containerView: UIView = {
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
        label.text = ""
        label.textColor = .newdioGray1
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(SettingDetailTableViewCell.self, forCellReuseIdentifier: SettingDetailTableViewCell.identifier)
        table.register(UseEnvDetailTableViewCell.self, forCellReuseIdentifier: UseEnvDetailTableViewCell.identifier)
        table.backgroundColor = .clear
        table.contentInsetAdjustmentBehavior = .always
        return table
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
        self.selectionStyle = .none
        self.backgroundColor = .newdioBlack
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func setDetailCell(type: SettingType) {
        settingType = type
        
        switch settingType {
        case .useEnv:
            titleLabel.text = "settings_use_env".localized()
            settingModel = SettingListModel().useEnvList
        case .appInfo:
            titleLabel.text = "settings_app_info".localized()
            settingModel = SettingListModel().appInfoList
        case .agreement:
            titleLabel.text = "settings_terms_conditions".localized()
            settingModel = SettingListModel().agreementList
        case .userManagement:
            titleLabel.text = "settings_manage_account".localized()
            settingModel = SettingListModel().userManagementList
        case .none:
            titleLabel.text = ""
            settingModel = []
        }
        
        tableView.reloadData()
    }
}

//MARK: - Table Delegate, DataSource
extension SettingTableViewCell: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if settingType == .useEnv {
            let cell = tableView.dequeueReusableCell(withIdentifier: UseEnvDetailTableViewCell.identifier, for: indexPath) as! UseEnvDetailTableViewCell
            
            if indexPath.row == 0 {
                // 언어 설정
                cell.infoLabel.text = "settings_language".localized()
                
                if let lang = CacheManager.getLanguage() {
                    cell.infoDetailLabel.text = "settings_language_\(lang)".localized()
                } else {
                    if Locale.current.languageCode == "ko" {
                        cell.infoDetailLabel.text = "settings_language_ko".localized()
                    } else {
                        cell.infoDetailLabel.text = "settings_language_en".localized()
                    }
                }
            } else if indexPath.row == 1 {
                // 자동 재생 설정
                cell.infoLabel.text = "settings_auto_play".localized()
                cell.infoDetailLabel.text = "settings_auto_play_\(CacheManager.getAutoPlay())".localized()
            } else if indexPath.row == 2 {
                // 텍스트 크기 설정
                cell.infoLabel.text = "settings_text".localized()
                cell.infoDetailLabel.text = "settings_text_\(CacheManager.getTextSize())".localized()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailTableViewCell.identifier, for: indexPath) as! SettingDetailTableViewCell
            cell.infoLabel.text = settingModel[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let listName = settingModel[indexPath.row].name
        let listURL = settingModel[indexPath.row].url
        
        NotificationCenter.default.post(name: NotificationManager.Setting.detail, object: nil, userInfo: ["name": listName,"url": listURL])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
