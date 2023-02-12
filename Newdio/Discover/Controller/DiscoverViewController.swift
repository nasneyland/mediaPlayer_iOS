//
//  DiscoverViewController.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit
import Gifu

class DiscoverViewController: UIViewController {
    
    //MARK: - Properties
    
    var companyList: [Company] = []
    var industryList: [Industry] = []
    var rankVO: Rank?
    
    private var errorView: ErrorView!
    
    private var refreshCompanyState = true
    private var refreshIndustryState = true
    private var refreshRankCompanyState = true
    private var refreshDailyRankCompanyState = true
    private var refreshRankIndustryState = true

    private lazy var discoverTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .none
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UITableView.automaticDimension
        table.register(CompanyTableViewCell.self, forCellReuseIdentifier: CompanyTableViewCell.identifier)
        table.register(CompanyRankTableViewCell.self, forCellReuseIdentifier: CompanyRankTableViewCell.identifier)
        table.register(IndustryTableViewCell.self, forCellReuseIdentifier: IndustryTableViewCell.identifier)
        table.register(IndustryRankTableViewCell.self, forCellReuseIdentifier: IndustryRankTableViewCell.identifier)
        table.refreshControl = refresh
        table.contentInsetAdjustmentBehavior = .always
        table.isHidden = true
        return table
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.tintColor = .clear
        
        let gifImageView = GIFImageView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2 - 15),
                                                      y: 0,
                                                      width: 30,
                                                      height: 30))
        gifImageView.animate(withGIFNamed: "loading")
        
        let view = UIView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2 - 15),
                                        y: 0,
                                        width: 30,
                                        height: 30))
        view.backgroundColor = .darkGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        refresh.addSubview(view)
        refresh.addSubview(gifImageView)
        
        return refresh
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingManager.show()
        
        configureNotification()
        configureNav()
        configureUI()
        
        loadCompanyData(loadType: .load)
    }
    
    //MARK: - Configure
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapMenu),
            name: NotificationManager.Main.discover,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapCompany),
            name: NotificationManager.Discover.company,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapIndustry),
            name: NotificationManager.Discover.industry,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapClose),
            name: NotificationManager.Discover.closeInfo,
            object: nil)
    }
    
    private func configureNav() {
        setLargeNav(title: "menu_discover".localized())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_search"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    private func configureUI() {
        self.view.backgroundColor = .newdioBlack
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        view.addSubview(discoverTableView)
        discoverTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
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
    
    private func loadCompanyData(loadType: LoadType) {
        DiscoverAPI.recommandCompanyAPI(error: {(type) in
            self.configureError(type: type)
            self.endLoading()
        }) { (companyList) in
            self.companyList = companyList
            self.loadRankData(loadType: loadType)
        }
    }
    
    private func loadRankData(loadType: LoadType) {
        DiscoverAPI.rankListAPI(error: {(type) in
            self.configureError(type: type)
            self.endLoading()
        }) { (rank) in
            self.rankVO = rank
            self.loadDailyRankData(loadType: loadType)
        }
    }
    
    private func loadDailyRankData(loadType: LoadType) {
        DiscoverAPI.dailyRankListAPI(error: {(type) in
            self.configureError(type: type)
            self.endLoading()
        }) { (rank) in
            self.rankVO?.dailyCompanyRankList = rank.dailyCompanyRankList
            self.rankVO?.dailyUpdate = rank.dailyUpdate
            self.loadIndustryData(loadType: loadType)
        }
    }
    
    private func loadIndustryData(loadType: LoadType) {
        DiscoverAPI.indusTotalListAPI(error: {(type) in
            self.configureError(type: type)
            self.endLoading()
        }) { (industryList) in
            self.industryList = industryList
            self.discoverTableView.isHidden = false
            self.discoverTableView.reloadData()
            
            if loadType == .load {
                // 둘러보기 로드 로그 전송
                LogManager.sendLogData(screen: .discover, action: .view, params: nil)
            } else if loadType == .reload {
                // 둘러보기 로드 로그 전송
                LogManager.sendLogData(screen: .discover, action: .view, params: ["type": "reload"])
            }
            
            self.endLoading()
        }
    }
    
    private func endLoading() {
        LoadingManager.hide()
        self.refresh.endRefreshing()
    }
    
    //MARK: - Helpers
    
    @objc func updateUI(refresh: UIRefreshControl) {
        
        self.refreshCompanyState = true
        self.refreshIndustryState = true
        self.refreshRankCompanyState = true
        self.refreshDailyRankCompanyState = true
        self.refreshRankIndustryState = true
        
        // 둘러보기 새로고침 로그 전송
        LogManager.sendLogData(screen: .discover, action: .drag, params: ["type": "reload"])
        
        loadCompanyData(loadType: .reload)
    }
    
    @objc func didTapSearch() {
        let vc = CompanySearchViewController(type: .discover)
        vc.industryList = []
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapClose() {
//        discoverTableView.reloadData()
    }
    
    @objc func didTapMenu(){
        let indexPath = IndexPath(row: 0, section: 0)
        self.discoverTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func didTapCompany(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        
        if let data = userInfo?["id"] as? String {
            DetailPresenter.startDetail(id: data, type: .company)
        }
    }
    
    @objc func didTapIndustry(_ notification: NSNotification) {
        let userInfo = notification.userInfo
                
        if let data = userInfo?["id"] as? String {
            DetailPresenter.startDetail(id: data, type: .industry)
        }
    }
    
    @objc func didTapDailyCompanyRank(sender: UIButton, forEvent event: UIEvent) {
        setPopUpView(sender: sender, forEvent: event, text: "discover_daily_rank_company_description".localized())
        
        let i = IndexPath(item: 1, section: 0)
//        let cell = discoverTableView.cellForRow(at: i) as! CompanyRankTableViewCell
//        cell.infoButton.tintColor = .newdioMain
    }
    
    @objc func didTapRealtimeCompanyRank(sender: UIButton, forEvent event: UIEvent) {
        setPopUpView(sender: sender, forEvent: event, text: "discover_hot_rank_company_description".localized())
        
        let i = IndexPath(item: 2, section: 0)
//        let cell = discoverTableView.cellForRow(at: i) as! CompanyRankTableViewCell
//        cell.infoButton.tintColor = .newdioMain
    }
    
    @objc func didTapRealtimeIndustryRank(sender: UIButton, forEvent event: UIEvent) {
        setPopUpView(sender: sender, forEvent: event, text: "discover_hot_rank_industry_description".localized())
        
        let i = IndexPath(item: 4, section: 0)
//        let cell = discoverTableView.cellForRow(at: i) as! IndustryRankTableViewCell
//        cell.infoButton.tintColor = .newdioMain
    }
    
    private func setPopUpView(sender: UIButton, forEvent event: UIEvent, text: String) {
        let touches = event.touches(for: sender)
        let touch = touches?.first
        
        let vc = DiscoverPopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.touchViewPoint = (touch?.location(in: self.view))!
        vc.touchPoint = (touch?.location(in: sender))!
        vc.infoLabel.text = text
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - Delegate, DataSource

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            //추천 기업 리스트
            let cell = discoverTableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.identifier, for: indexPath) as! CompanyTableViewCell
            
            if self.refreshCompanyState == true, companyList.count != 0 {
                //추천 기업 셋팅
                cell.updateCellWith(row: companyList)
                self.refreshCompanyState = false
            }
    
            return cell
            
        } else if (indexPath.row == 1) {
            //일간 기업 순위
            let cell = discoverTableView.dequeueReusableCell(withIdentifier: CompanyRankTableViewCell.identifier, for: indexPath) as! CompanyRankTableViewCell
            
            cell.rankType = .daily
            cell.infoButton.tintColor = .newdioGray1
            
            if self.refreshDailyRankCompanyState == true, rankVO != nil {
                // 일간 기업 순위 셋팅
                cell.updateDailyCompanyCellWith(company: rankVO?.dailyCompanyRankList ?? [])
                cell.updateTimeLabel.text = String(format: "search_criteria".localized(), rankVO?.dailyUpdate.toDate()?.utcToLocale(type: .time) as! CVarArg)
                cell.titleLabel.text = "discover_daily_rank_company".localized()
                cell.infoButton.addTarget(self, action: #selector(didTapDailyCompanyRank), for: .touchUpInside)
                self.refreshDailyRankCompanyState = false
            }
          
            return cell
            
        } else if (indexPath.row == 2) {
            //실시간 기업 순위
            let cell = discoverTableView.dequeueReusableCell(withIdentifier: CompanyRankTableViewCell.identifier, for: indexPath) as! CompanyRankTableViewCell
            
            cell.rankType = .realTime
            cell.infoButton.tintColor = .newdioGray1
            
            if self.refreshRankCompanyState == true, rankVO != nil {
                //실시간 기업 순위 셋팅
                cell.updateCompanyCellWith(company: rankVO?.companyRankList ?? [])
                cell.updateTimeLabel.text = String(format: "search_criteria".localized(), rankVO?.update.toDate()?.utcToLocale(type: .time) as! CVarArg)
                
                cell.titleLabel.text = "discover_hot_rank_company".localized()
                cell.infoButton.addTarget(self, action: #selector(didTapRealtimeCompanyRank), for: .touchUpInside)
                self.refreshRankCompanyState = false
            }
          
            return cell
            
        } else if (indexPath.row == 3) {
            //전체 산업 리스트
            let cell = discoverTableView.dequeueReusableCell(withIdentifier: IndustryTableViewCell.identifier, for: indexPath) as! IndustryTableViewCell
            
            if self.refreshIndustryState == true, industryList.count != 0 {
                //전체 산업 리스트 셋팅
                cell.updateCellWith(row: industryList)
                self.refreshIndustryState = false
            }
            
            return cell
            
        } else {
            //실시간 산업 순위
            let cell = discoverTableView.dequeueReusableCell(withIdentifier: IndustryRankTableViewCell.identifier, for: indexPath) as! IndustryRankTableViewCell
            
            cell.infoButton.tintColor = UIColor.newdioGray1
            
            if self.refreshRankIndustryState == true, rankVO != nil {
                //실시간 산업 순위 셋팅
                cell.updateIndustryCellWith(industry: rankVO?.industryRankList ?? [])
                cell.updateTimeLabel.text = String(format: "search_criteria".localized(), rankVO?.update.toDate()?.utcToLocale(type: .time) as! CVarArg)
                
                cell.infoButton.addTarget(self, action: #selector(didTapRealtimeIndustryRank), for: .touchUpInside)
                self.refreshRankIndustryState = false
            }
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 190
        case 1:
            return 410
        case 2:
            return 410
        case 3:
            return 240
        case 4:
            return 350
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: - Error Delegate

extension DiscoverViewController: ErrorViewDelegate {
    func didTapRetry() {
        LoadingManager.show()
        
        discoverTableView.isHidden = true
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.loadCompanyData(loadType: .load)
        }
    }
}
