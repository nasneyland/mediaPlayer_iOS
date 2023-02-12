//
//  AppInfoTableViewCell.swift
//  Newdio
//
//  Created by sg on 2021/11/25.
//

import UIKit

class AppInfoTableViewCell: UITableViewCell {
    
    private let appInfoDetailTableViewCell = "appInfoDetailTableViewCell"
    
    lazy var appInfoDetailTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(AppInfoDetailTableViewCell.self, forCellReuseIdentifier: appInfoDetailTableViewCell)
        return table
    }()
    
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
        label.text = "앱정보"
        label.textColor = .newdioGray1
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureTable()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
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
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(24)
        }
        
        containerView.addSubview(appInfoDetailTableView)
        appInfoDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
    
        }
        
    }
    
    private func configureTable() {
        appInfoDetailTableView.delegate = self
        appInfoDetailTableView.dataSource = self
        
        appInfoDetailTableView.backgroundColor = .none
        appInfoDetailTableView.showsHorizontalScrollIndicator = false
    }
    
}

extension AppInfoTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appInfoDetailTableView.dequeueReusableCell(withIdentifier: appInfoDetailTableViewCell, for: indexPath) as! AppInfoDetailTableViewCell
        return cell
    }
}
