//
//  CompanySearchViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/16.
//

import UIKit

enum SearchType {
    case sign
    case discover
}

class CompanySearchViewController: UIViewController {

    //MARK: - Properties
    
    var industryList: [Industry] = []
    var companyList: [Company] = []
    var searchedCompanyList: [Company] = [] // 검색된 기업 리스트
    
    var searchType: SearchType?
    
    private var errorView: ErrorView!
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_search"), for: .normal)
        return button
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("common_cancel".localized(), for: .normal)
        button.setTitleColor(.newdioWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .newdioBlack
        tableView.register(CompanySearchTableViewCell.self, forCellReuseIdentifier: CompanySearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    init(type: SearchType) {
        super.init(nibName: nil, bundle: nil)
        
        searchType = type
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if industryList.count == 0 {
            LoadingManager.show()
            
            loadListData()
        } else {
            for industry in industryList {
                for company in industry.companyList {
                    var company = company
                    company.industry = industry.name
                    self.companyList.append(company)
                }
            }
            
            self.companyList = self.companyList.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.searchedCompanyList = self.companyList
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
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
            make.right.equalToSuperview().offset(-10)
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
    
    private func configureError(type: ErrorType) {
        errorView = ErrorView(frame: .zero, type: type)
        errorView.delegate = self
        
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - API
    
    private func loadListData() {
        DiscoverAPI.companyListAPI(error: {(type) in
            self.configureError(type: type)
            
            LoadingManager.hide()
        }) { (datas) in
            for industry in datas {
                for company in industry.companyList {
                    var company = company
                    company.industry = industry.name
                    self.companyList.append(company)
                }
            }
            
            LoadingManager.hide()
            
            self.companyList = self.companyList.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.searchedCompanyList = self.companyList
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapBack() {
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
        cell.logoImageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyId = searchedCompanyList[indexPath.row].id
        
        if searchType == .sign {
            NotificationCenter.default.post(name: NotificationManager.Sign.selectCompany, object: nil, userInfo: ["id": companyId ?? 0])
            
            self.dismiss(animated: true, completion: nil)
        } else {
            
            // 둘러보기 기업 검색 로그 전송
            LogManager.sendLogData(screen: .discover, action: .click, params: ["type": "search_co", "co_id": companyId ?? 0])
            
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: NotificationManager.Discover.company, object: nil, userInfo: ["id": companyId ?? 0])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //스크롤 시 키보드 내리기
        view.endEditing(false)
    }
}

//MARK: - TextField Extension

extension CompanySearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchedCompanyList = []
        
        if textField.text != "" {
            for company in self.companyList {
                if company.name.uppercased().contains(textField.text?.uppercased() ?? "") {
                    searchedCompanyList.append(company)
                }
            }
        } else {
            searchedCompanyList = companyList
        }
        
        self.tableView.reloadData()
    }
}

//MARK: - Error Delegate

extension CompanySearchViewController: ErrorViewDelegate {
    func didTapRetry() {
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.loadListData()
        }
    }
}
