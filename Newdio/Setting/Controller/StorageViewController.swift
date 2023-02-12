//
//  StorageViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/17.
//

import UIKit

class StorageViewController: UIViewController {
    
    //MARK: - Properties
    
    private var companyList: [Company] = []
    private var industryList: [Industry] = []
    private var newsList: [News] = []
    
    private var errorView: ErrorView!

    private let noneLabel: UILabel = {
        let label = UILabel()
        label.text = "settings_my_favorite_none".localized()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .newdioGray1
        label.isHidden = true
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .black
        tableView.register(StorageTableViewCell.self, forCellReuseIdentifier: StorageTableViewCell.identifier)
        tableView.register(NewsStorageTableViewCell.self, forCellReuseIdentifier: NewsStorageTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.isHidden = true
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LoadingManager.show()
        
        configureNav()
        configureUI()
        loadStorageData()
    }
    
    //MARK: - Configure
    
    private func configureNav() {
        
        title = "settings_my_favorite".localized()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_arrowdown"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(back))
    }
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(noneLabel)
        noneLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureError(type: ErrorType) {
        errorView = ErrorView(frame: .zero, type: type)
        errorView.delegate = self
        
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - API
    
    private func loadStorageData() {
        SignAPI.storageAPI(error: {(type) in
            LoadingManager.hide()
            
            self.configureError(type: type)
        }) { (data) in
            LoadingManager.hide()
            
            self.companyList = data.companyList ?? []
            self.industryList = data.industryList ?? []
            self.newsList = data.newsList ?? []
            
            if (self.companyList.count + self.industryList.count + self.newsList.count == 0) {
                self.tableView.isHidden = true
                self.noneLabel.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.noneLabel.isHidden = true
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func setNewsLike(newsId: Int) {
        PlayerAPI.newsHeartAPI(id: newsId, error: {(statusCode) in
            if statusCode == 0 {
                self.present(networkErrorPopup(), animated: false, completion: nil)
            } else if statusCode == 401 {
                self.present(tokenErrorPopup(), animated: false, completion: nil)
            } else if statusCode == 404 {
                self.present(userErrorPopup(), animated: false, completion: nil)
            } else {
                self.present(serverErrorPopup(), animated: false, completion: nil)
            }
        }) { (result) in
            LoadingManager.show()
            self.loadStorageData()
        }
    }
    
    private func setDetailLike(id: String) {
        DetailAPI.detailLikeAPI(id: id, error: {(statusCode) in
            if statusCode == 0 {
                self.present(networkErrorPopup(), animated: false, completion: nil)
            } else if statusCode == 401 {
                self.present(tokenErrorPopup(), animated: false, completion: nil)
            } else if statusCode == 404 {
                self.present(userErrorPopup(), animated: false, completion: nil)
            } else {
                self.present(serverErrorPopup(), animated: false, completion: nil)
            }
        }) { (result) in
            LoadingManager.show()
            self.loadStorageData()
        }
    }
    
    //MARK: - Helpers
    
    @objc func back() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - TableView Delegate

extension StorageViewController: UITableViewDelegate, UITableViewDataSource {
    
    //섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //섹션별 셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return companyList.count
        } else if section == 1 {
            return industryList.count
        } else if section == 2 {
            return newsList.count
        } else {
            return 0
        }
    }
    
    //셀 속성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let company = companyList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: StorageTableViewCell.identifier, for: indexPath) as! StorageTableViewCell
            
            let url = URL(string: company.logoURL ?? "")
            cell.logoImageView.kf.setImage(with: url)
            
            cell.nameLabel.text = company.name
            cell.id = company.id
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let industry = industryList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: StorageTableViewCell.identifier, for: indexPath) as! StorageTableViewCell
            
            let url = URL(string: industry.logoURL ?? "")
            cell.logoImageView.kf.setImage(with: url)
            
            cell.nameLabel.text = industry.name
            cell.id = industry.id
            cell.delegate = self
            return cell
        } else {
            let news = newsList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsStorageTableViewCell.identifier, for: indexPath) as! NewsStorageTableViewCell
            
            let url = URL(string: news.imageURL ?? "")
            cell.newsImageView.kf.setImage(with: url)
            
            cell.titleLabel.text = news.title
            cell.subtitleLabel.text = "\(news.site ?? "") · \(news.time!.toDate()!.utcToLocaleDate())"
            cell.id = news.id
            cell.delegate = self
            return cell
        }
    }
    
    //셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //셀 클릭 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let DetailVC = DetailViewController(detailType: .company)
            DetailVC.id = companyList[indexPath.row].id
            self.navigationController?.pushViewController(DetailVC, animated: true)
        } else if indexPath.section == 1 {
            let DetailVC = DetailViewController(detailType: .industry)
            DetailVC.id = industryList[indexPath.row].id
            self.navigationController?.pushViewController(DetailVC, animated: true)
        } else {
            PlayerPresenter.newsPlayer(newsId: newsList[indexPath.row].id)
        }
    }
    
    //헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .black
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.frame = CGRect(x: 15, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        
        if section == 0 {
            titleLabel.text = "common_company".localized()
            headerView.addSubview(titleLabel)
        } else if section == 1 {
            titleLabel.text = "common_industry".localized()
            headerView.addSubview(titleLabel)
        } else {
            titleLabel.text = "settings_news".localized()
            headerView.addSubview(titleLabel)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if companyList.count == 0 {
                return 0
            } else {
                return 50
            }
        } else if section == 1 {
            if industryList.count == 0 {
                return 0
            } else {
                return 50
            }
        } else {
            if newsList.count == 0 {
                return 0
            } else {
                return 50
            }
        }
    }
}

//MARK: - Error Delegate

extension StorageViewController: ErrorViewDelegate {
    func didTapRetryButton() {
        self.tableView.isHidden = true
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.loadStorageData()
        }
    }
}

//MARK: - Delegate

extension StorageViewController: StorageTableViewCellDelegate {
    func didTapHeartButton(id: String) {
        setDetailLike(id: id)
    }
}

extension StorageViewController: NewsStorageTableViewCellDelegate {
    func didTapHeartButton(id: Int) {
        setNewsLike(newsId: id)
    }
}
