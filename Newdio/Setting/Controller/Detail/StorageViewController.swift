//
//  StorageViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/17.
//

import UIKit

class StorageViewController: UIViewController {
    
    //MARK: - Properties
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    var scrollMode = false
    
    private var companyList: [Company] = []
    private var industryList: [Industry] = []
    private var newsList: [News] = []
    
    private var errorView: ErrorView!

    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .newdioWhite
        label.text = "settings_my_favorite".localized()
        label.textAlignment = .center
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_arrowdown"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
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
        tableView.backgroundColor = .newdioBlack
        tableView.register(StorageTableViewCell.self, forCellReuseIdentifier: StorageTableViewCell.identifier)
        tableView.register(NewsStorageTableViewCell.self, forCellReuseIdentifier: NewsStorageTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = true
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadStorageData()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(110)
        }
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        titleView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
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
    
    private func configureGesture() {
        //뷰에 스와이프 추가
        let viewSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleViewSwipes(_:)))
        titleView.addGestureRecognizer(viewSwipeGestureRecognizer)

        //테이블뷰에 스와이프 추가
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //MARK: - API
    
    private func loadStorageData() {
        LoadingManager.show()
        
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
        PlayerAPI.newsHeartAPI(id: newsId, error: {(error) in
            self.present(ErrorManager.errorToAlert(error: error), animated: false)
        }) { (result) in
            LoadingManager.show()
            self.loadStorageData()
        }
    }
    
    private func setDetailLike(id: String) {
        DetailAPI.detailLikeAPI(id: id, error: {(error) in
            self.present(ErrorManager.errorToAlert(error: error), animated: false)
        }) { (result) in
            LoadingManager.show()
            self.loadStorageData()
        }
    }
    
    //MARK: - Helpers
    
    //뷰 스와이프
    @objc func handleViewSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view.window)
        if sender.state == .began {
            initialTouchPoint = touchPoint
        } else if sender.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    //테이블뷰 스와이프
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view.window)

        if sender.state == .began {
            initialTouchPoint = touchPoint
        }

        if tableView.contentOffset.y == 0 {
            //텍스트뷰 위치가 top인 경우
            if touchPoint.y - initialTouchPoint.y > 0 {
                //아래로 스와이프
                tableView.isScrollEnabled = false
            } else {
                //위로 스와이프
                tableView.isScrollEnabled = true
            }
        } else {
            //텍스트뷰 위치가 아래인 경우
            tableView.isScrollEnabled = true
        }
        
        tableView.isScrollEnabled = true
        if self.tableView.contentOffset.y == 0 {
            if sender.state == .began {
                scrollMode = false
                initialTouchPoint = touchPoint
            }
        }

        if scrollMode == false, sender.state != .began {
            //텍스트뷰 위치가 top인 경우
            if touchPoint.y - initialTouchPoint.y > 0 {
                //아래로 스와이프
                tableView.isScrollEnabled = false
                if sender.state == .changed {
                    if touchPoint.y - initialTouchPoint.y > 0 {
                        self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
                    }
                } else if sender.state == .ended || sender.state == .cancelled {
                    if touchPoint.y - initialTouchPoint.y > 200 {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        UIView.animate(withDuration: 0.3) {
                            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        }
                    }
                }
            }
        }

        if sender.state == .ended || sender.state == .cancelled {
            scrollMode = true
        }
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: false)
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
            cell.logoImageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
            
            cell.nameLabel.text = company.name
            cell.id = company.id
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let industry = industryList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: StorageTableViewCell.identifier, for: indexPath) as! StorageTableViewCell
            
            let url = URL(string: industry.logoURL ?? "")
            cell.logoImageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
            
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
            cell.subtitleLabel.text = "\(news.site ?? "") · \(news.time!.toDate()!.utcToLocale(type: .date))"
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
            DetailPresenter.addDetail(vc: self, id: companyList[indexPath.row].id, type: .company)
        } else if indexPath.section == 1 {
            DetailPresenter.addDetail(vc: self, id: industryList[indexPath.row].id, type: .industry)
        } else {
            PlayerPresenter.playNewsPlayer(newsId: newsList[indexPath.row].id, vc: self)
        }
    }
    
    //헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .newdioBlack
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        let titleLabel = UILabel()
        titleLabel.textColor = .newdioWhite
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
    func didTapRetry() {
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

//MARK: - Gesture Delegate

extension StorageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
