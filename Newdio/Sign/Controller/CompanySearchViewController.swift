//
//  CompanySearchViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/16.
//

import UIKit

class CompanySearchViewController: UIViewController {

    //MARK: - Properties
    
    var companyList: [Company] = []
    var searchedCompanyList: [Company] = []
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_search"), for: .normal)
        return button
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("common_cancel".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .black
        tableView.register(CompanySearchTableViewCell.self, forCellReuseIdentifier: CompanySearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    init(industryList: [Industry]) {
        super.init(nibName: nil, bundle: nil)
        
        for industry in industryList {
            for company in industry.companyList! {
                var company = company
                company.industry = industry.name
                self.companyList.append(company)
            }
        }
        
        self.companyList = self.companyList.sorted(by: {$0.name ?? "" < $1.name ?? ""})
        self.searchedCompanyList = self.companyList
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTextField.delegate = self
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(50)
        }
        
        searchView.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(searchButton.snp.height)
        }
        
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(searchButton.snp.right).offset(10)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(searchView.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
    }
    
    //MARK: - Helpers
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Extension

extension CompanySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedCompanyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanySearchTableViewCell.identifier, for: indexPath) as! CompanySearchTableViewCell
        
        let company = searchedCompanyList[indexPath.row]
        cell.companyLabel.text = company.name
        cell.industryLabel.text = company.industry
        
        let url = URL(string: company.logoURL ?? "")
        cell.logoImageView.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectedCompany"), object: nil, userInfo: ["id": searchedCompanyList[indexPath.row].id])
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // 헤더 여백 제거
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}

//MARK: - Extension

extension CompanySearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchedCompanyList = []
        
        for company in self.companyList {
            if company.name!.uppercased().contains(textField.text?.uppercased() ?? "") {
                searchedCompanyList.append(company)
            }
        }
        
        self.tableView.reloadData()
    }
}
