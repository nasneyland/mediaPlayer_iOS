//
//  DetailViewController.swift
//  Newdio
//
//  Created by sg on 2021/12/01.
//

import UIKit

enum DetailType {
    case company
    case industry
}

class DetailViewController: UIViewController {

    //MARK: - Properties
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    
    var id: String!
    var type: DetailType!
    var company: Company! = nil
    var industry: Industry! = nil
    var newsList: [NewsThumb] = []
    
    private var loginView: LoginView!
    private var errorView: ErrorView!
    
    private let detailTableView: UITableView =  {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedSectionHeaderHeight = 50
        tableView.rowHeight = 200
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.bounces = false
        return tableView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .newdioWhite
        label.text = ""
        return label
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_arrowleft_white"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private var heartButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
        button.tintColor = .newdioWhite
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private var infoButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_info_off"), for: .normal)
        button.addTarget(self, action: #selector(didTapInfo), for: .touchUpInside)
        button.tintColor = .newdioWhite
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private var relatedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .newdioWhite
        label.text = "detail_related_news".localized()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("player_listen_all".localized(), for: .normal)
        button.setTitleColor(.newdioGray1, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(detailType: DetailType) {
        super.init(nibName: nil, bundle: nil)
        
        type = detailType
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTable()
        configureLogin()
        
        configureGesture()
        configureNotification()
        
        if type == .company {
            loadCompanyData(id: id, loadType: .load)
        } else {
            loadIndustryData(id: id, loadType: .load)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        LoadingManager.show()
    }
    
    //MARK: - Configure
    
    private func configureTable() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        detailTableView.register(DetailHeaderTableViewCell.self, forCellReuseIdentifier: DetailHeaderTableViewCell.identifier)
        
        detailTableView.separatorStyle = .none
        detailTableView.isHidden = true
    }
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(40)
            if type == .company {
                make.right.equalToSuperview().offset(-16)
                make.width.equalTo(40)
            } else {
                make.right.equalToSuperview()
                make.width.equalTo(0)
            }
        }
        
        view.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            
            make.width.height.equalTo(40)
            if type == .company {
                make.right.equalTo(infoButton.snp.left).offset(-5)
            } else {
                make.right.equalTo(infoButton.snp.left).offset(-15)
            }
        }
        
        view.addSubview(detailTableView)
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func configureLogin() {
        loginView = LoginView(frame: .zero)
        
        loginView.isHidden = true
        loginView.delegate = self
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
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
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didTapClose), name: NotificationManager.Detail.closeInfo, object: nil)
    }
    
    private func configureGesture() {
        //뷰에 좌우 스와이프 추가
        let viewSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleViewSwipes(_:)))
        self.view.addGestureRecognizer(viewSwipeGestureRecognizer)
    }
    
    //MARK: - API
    
    private func loadCompanyData(id: String, loadType: LoadType) {
        DetailAPI.companyDetailAPI(id: id, error: {(type) in
            self.configureError(type: type)
            
            LoadingManager.hide()
        }) { (datas) in
            self.company = datas
            self.loadCompanyNewsData(id: id, lastId: 0, loadType: loadType)
            
            self.setHeartButton()
        }
    }
    
    private func loadCompanyNewsData(id: String, lastId: Int, loadType: LoadType) {
        DetailAPI.companyNewsListAPI(id: id, lastId: lastId, error: {(type) in
            if lastId == 0 {
                self.configureError(type: type)
            }
            LoadingManager.hide()
        }) { (datas) in
            self.detailTableView.isHidden = false
            self.heartButton.isHidden = false
            self.infoButton.isHidden = false
            
            if loadType == .load {
                // 기업 상세보기 로드 로그 전송
                LogManager.sendLogData(screen: .detail, action: .view, params: ["type": "company", "id": id])
            } else if loadType == .more {
                // 기업 기사 추가 로드 로그 전송
                LogManager.sendLogData(screen: .detail, action: .view, params: ["type": "next_page", "co_id": id, "id": datas.last?.id ?? 0, "pre_id": self.newsList.last?.id ?? 0])
            }
            
            self.newsList += datas
            self.detailTableView.reloadData()
            
            LoadingManager.hide()
        }
    }
    
    private func loadIndustryData(id: String, loadType: LoadType) {
        DetailAPI.industryDetailAPI(id: id, error: {(type) in
            self.configureError(type: type)
            
            LoadingManager.hide()
        }) { (datas) in
            self.industry = datas
            self.loadIndustryNewsData(id: id, lastId: 0, loadType: loadType)
            
            self.setHeartButton()
        }
    }
    
    private func loadIndustryNewsData(id: String, lastId: Int, loadType: LoadType) {
        DetailAPI.industryNewsListAPI(id: id, lastId: lastId, error: {(type) in
            if lastId == 0 {
                self.configureError(type: type)
            }
            
            LoadingManager.hide()
        }) { (datas) in
            self.detailTableView.isHidden = false
            self.heartButton.isHidden = false
            self.infoButton.isHidden = false
            
            if loadType == .load {
                // 산업 상세보기 로드 로그 전송
                LogManager.sendLogData(screen: .detail, action: .view, params: ["type": "industry", "id": id])
            } else if loadType == .more {
                // 산업 기사 추가 로드 로그 전송
                LogManager.sendLogData(screen: .detail, action: .view, params: ["type": "next_page", "in_id": id, "id": datas.last?.id ?? 0, "pre_id": self.newsList.last?.id ?? 0])
            }
            
            self.newsList += datas
            self.detailTableView.reloadData()
            
            LoadingManager.hide()
        }
    }
    
    private func setDetailHeart(id: String) {
        DetailAPI.detailLikeAPI(id: id, error: {(error) in
            self.present(ErrorManager.errorToAlert(error: error), animated: false)
        }) { (result) in
            if self.type == .company {
                
                // 기업 좋아요 클릭 로그 전송
                LogManager.sendLogData(screen: .detail, action: .click, params: ["type": "like", "like": result, "co_id": id])
                
                if result == 1 {
                    self.company.likeState = true
                } else {
                    self.company.likeState = false
                }
            } else {
                
                // 산업 좋아요 클릭 로그 전송
                LogManager.sendLogData(screen: .detail, action: .click, params: ["type": "like", "like": result, "in_id": id])
                
                if result == 1 {
                    self.industry.likeState = true
                } else {
                    self.industry.likeState = false
                }
            }
            
            self.setHeartButton()
        }
    }
    
    //MARK: - Helpers
    
    private func setHeartButton() {
        //좋아요 셋팅
        if APIManager.isUser() {
            //회원용 버튼
            self.heartButton.addTarget(self, action: #selector(self.didTapHeart), for: .touchUpInside)
            
            if type == .company {
                if self.company.likeState ?? false {
                    heartButton.setImage(UIImage(named: "ic_general_heart_on"), for: .normal)
                    heartButton.tintColor = .newdioMain
                } else {
                    heartButton.setImage(UIImage(named: "ic_general_heart_off"), for: .normal)
                    heartButton.tintColor = .newdioWhite
                }
            } else {
                if self.industry.likeState ?? false {
                    heartButton.setImage(UIImage(named: "ic_general_heart_on"), for: .normal)
                    heartButton.tintColor = .newdioMain
                } else {
                    heartButton.setImage(UIImage(named: "ic_general_heart_off"), for: .normal)
                    heartButton.tintColor = .newdioWhite
                }
            }
        } else {
            //비회원용 버튼
            self.heartButton.tintColor = .newdioWhite
            self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
            self.heartButton.addTarget(self, action: #selector(self.didTapLogin), for: .touchUpInside)
        }
    }
    
    @objc func handleViewSwipes(_ sender: UIPanGestureRecognizer) {
        loginView.isHidden = true
        
        let touchPoint = sender.location(in: self.view.window)
        if sender.state == .began {
            initialTouchPoint = touchPoint
        } else if sender.state == .changed {
            if touchPoint.x - initialTouchPoint.x > 0 {
                self.view.frame = CGRect(x: touchPoint.x - initialTouchPoint.x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if touchPoint.x - initialTouchPoint.x > (self.view.frame.width / 2) {
                self.dismiss(animated: false, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    @objc func didTapLogin() {
        loginView.isHidden = false
    }
    
    @objc func didTapCancel() {
        self.dismiss(animated: false)
    }
    
    @objc func didTapHeart() {
        
        let id = type == .company ? company.id : industry.id
        
        setDetailHeart(id: id)
    }
    
    @objc func didTapInfo() {
        infoButton.tintColor = .newdioMain
        
        // 기업 상세정보 클릭 로그 전송
        LogManager.sendLogData(screen: .detail, action: .click, params: ["type": "info", "co_id": company.id ?? 0])
        
        let vc = DetailPopUpViewController(description: company.description ?? "")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapClose() {
        infoButton.tintColor = .newdioWhite
    }
    
    @objc func didTapPlay() {
        
        if type == .company {
            // 기업 전체듣기 클릭 로그 전송
            LogManager.sendLogData(screen: .detail, action: .click, params: ["type": "play_all", "co_id": company.id ?? 0])
        } else {
            // 기업 전체듣기 클릭 로그 전송
            LogManager.sendLogData(screen: .detail, action: .click, params: ["type": "play_all", "in_id": industry.id ?? 0])
        }
        
        PlayerPresenter.playListPlayer(newsList: newsList, vc: self)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return newsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 80
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderTableViewCell.identifier) as! DetailHeaderTableViewCell
            
            headerCell.playAllButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
            
            if company != nil {
                //기업 이미지 셋팅
                let url = URL(string: company.logoURL ?? "")
                headerCell.headerImageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
                
                //기업 상세정보 셋팅
                headerCell.titleLabel.text = company.name
                headerCell.subTitleLabel.text = company.industry
            }
            
            if industry != nil {
                //산업 이미지 셋팅
                let url = URL(string: industry.logoURL ?? "")
                headerCell.headerImageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
                
                //산업 상세정보 셋팅
                headerCell.titleLabel.text = industry.name
                headerCell.subTitleLabel.text = ""
            }
            
            return headerCell
          
        } else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
            if newsList.count != 0 {
                let news = newsList[indexPath.row]
                
                // 뉴스 이미지 셋팅
                let url = URL(string: news.imageURL ?? "")
                cell.newsImageView.kf.setImage(with: url)
                
                // 뉴스 상세정보 셋팅
                cell.subtitleLabel.text = "\(news.site ?? "") · \(news.time.toDate()!.utcToLocale(type: .date))"
                cell.titleLabel.text = news.title
                
                // 캐싱된 뉴스 읽음 처리
                if CacheManager.isCachedNews(id: news.id) {
                    cell.titleLabel.textColor = .newdioGray2
                    cell.subtitleLabel.textColor = .newdioGray2
                } else {
                    cell.titleLabel.textColor = .newdioWhite
                    cell.subtitleLabel.textColor = .newdioGray1
                }
            }
            return cell
        }

        return UITableViewCell()
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let newsId = newsList[indexPath.row].id ?? 0
            let lastId = newsList.last?.id ?? 0
            
            let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell
            
            // 뉴스 읽음 처리
            cell?.titleLabel.textColor = .newdioGray2
            cell?.subtitleLabel.textColor = .newdioGray2
            
            // 뉴스 플레이어 뷰 present
            PlayerPresenter.playNewsPlayer(newsId: newsId , vc: self)
            
            if type == .company {
                // 기업 기사 클릭 로그 전송
                LogManager.sendLogData(screen: .detail, action: .click, params: ["type": "news", "co_id": company.id ?? 0, "id": newsId, "last_id": lastId])
            } else {
                // 산업 기사 클릭 로그 전송
                LogManager.sendLogData(screen: .detail, action: .click, params: ["type": "news", "in_id": industry.id ?? 0, "id": newsId, "last_id": lastId])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: .zero)
        } else {
            let headerView = UIView()
            
            headerView.backgroundColor = .newdioBlack
            headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

            headerView.addSubview(playButton)
            playButton.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-15)
                make.width.equalTo(60)
                make.top.bottom.equalToSuperview()
            }
            
            headerView.addSubview(relatedLabel)
            relatedLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(playButton.snp.left).offset(5)
                make.top.bottom.equalToSuperview()
            }
            
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // title 나타내는 지점
        let offset = 180.0

        if scrollView.contentOffset.y > offset {
            playButton.isHidden = false
            
            if type == .company {
                self.titleLabel.text = company.name
            } else {
                self.titleLabel.text = industry.name
            }
        } else {
            playButton.isHidden = true
            
            self.titleLabel.text = ""
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // 스크롤 무한 로딩 - 마지막 셀일때 다시 API 통신
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom == height {
            let lastId = newsList.last?.id ?? 0
            
            if type == .company {
                self.loadCompanyNewsData(id: company.id, lastId: lastId , loadType: .more)
                
                // 기업 기사 추가 로드 로그 전송
                LogManager.sendLogData(screen: .detail, action: .drag, params: ["type": "next_page", "co_id": company.id ?? 0, "id": lastId])
            } else {
                self.loadIndustryNewsData(id: industry.id, lastId: lastId , loadType: .more)
                
                // 산업 기사 추가 로드 로그 전송
                LogManager.sendLogData(screen: .detail, action: .drag, params: ["type": "next_page", "in_id": industry.id ?? 0, "id": lastId])
            }
        }
    }
}

//MARK: - Login Delegate

extension DetailViewController: LoginViewDelegate {
    func didTapConfirm() {
        loginView.isHidden = true
        NotificationCenter.default.post(name: NotificationManager.Main.login, object: nil)
    }
    
    func didTapBack() {
        loginView.isHidden = true
    }
    
    func didTapBackground() {
        loginView.isHidden = true
    }
}

//MARK: - Error Delegate

extension DetailViewController: ErrorViewDelegate {
    func didTapRetry() {
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if self.type == .company {
                self.loadCompanyData(id: self.id, loadType: .load)
            } else {
                self.loadIndustryData(id: self.id, loadType: .load)
            }
        }
    }
}
