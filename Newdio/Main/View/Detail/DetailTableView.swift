//
//  DetailTableView.swift
//  Newdio
//
//  Created by sg on 2021/12/01.
//

import UIKit

class DetailTableView: UIView {
    
    let navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let tableView: UITableView =  {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedSectionHeaderHeight = 50
        tableView.rowHeight = 200
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        return tableView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .black
        self.addSubview(self.tableView)
        self.addSubview(self.navigationView)

        self.navigationView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.navigationView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.navigationView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.navigationView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true

        self.tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
}
