//
//  DetailViewController.swift
//  Newdio
//
//  Created by sg on 2021/12/01.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - Properties
    
    lazy var detailTableView = DetailTableView(frame: self.view.frame)
    private var loginView: LoginView!
    private var errorView: ErrorView!
    
    var type: DetailType!
    var company: Company! = nil
    var industry: Industry! = nil
    var newsList: [NewsThumb] = []
    var id: String!
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.text = ""
        return label
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_arrowleft_white"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    var heartButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    var infoButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_info_off"), for: .normal)
        button.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private var relatedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "detail_related_news".localized()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("player_listen_all".localized(), for: .normal)
        button.tintColor = .newdioGray1
        button.setTitleColor(.newdioGray1, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(tapPlayAllButton), for: .touchUpInside)
        return button
    }()
    
    private var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .black
        return headerView
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
        
        LoadingManager.show()

        configureUI()
        configureTable()
        configureLogin()
        
        notification()
        
        if type == .company {
            loadCompanyData(id: id)
        } else {
            loadIndustryData(id: id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        
    }
    
    //MARK: - Configure
    
    private func configureTable() {
        self.detailTableView.tableView.delegate = self
        self.detailTableView.tableView.dataSource = self
        self.detailTableView.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "DetailContent")
        self.detailTableView.tableView.register(DetailHeaderTableViewCell.self, forCellReuseIdentifier: "DetailHeader")
        
        detailTableView.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        detailTableView.isHidden = true
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
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
            make.top.equalToSuperview().offset(60)
            
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
    
    //MARK: - API
    
    private func loadCompanyData(id: String) {
        DetailAPI.companyDetailAPI(id: id, error: {(type) in
            self.configureError(type: type)
            self.endLoading()
        }) { (datas) in
            self.company = datas
            self.loadCompanyNewsData(id: id, lastId: 0)
            
            self.setHeartButton()
        }
    }
    
    private func loadCompanyNewsData(id: String, lastId: Int) {
        DetailAPI.companyNewsListAPI(id: id, lastId: lastId, error: {(type) in
            if lastId == 0 {
                self.configureError(type: type)
            }
            self.endLoading()
        }) { (datas) in
            self.detailTableView.isHidden = false
            self.heartButton.isHidden = false
            self.infoButton.isHidden = false
            
            self.newsList += datas
            self.detailTableView.tableView.reloadData()
            self.endLoading()
        }
    }
    
    private func loadIndustryData(id: String) {
        DetailAPI.industryDetailAPI(id: id, error: {(type) in
            self.configureError(type: type)
            self.endLoading()
        }) { (datas) in
            self.industry = datas
            self.loadIndustryNewsData(id: id, lastId: 0)
            
            self.setHeartButton()
        }
    }
    
    private func loadIndustryNewsData(id: String, lastId: Int) {
        DetailAPI.industryNewsListAPI(id: id, lastId: lastId, error: {(type) in
            if lastId == 0 {
                self.configureError(type: type)
            }
            self.endLoading()
        }) { (datas) in
            self.detailTableView.isHidden = false
            self.heartButton.isHidden = false
            self.infoButton.isHidden = false
            
            self.newsList += datas
            self.detailTableView.tableView.reloadData()
            self.endLoading()
        }
    }
    
    private func setDetailHeart(id: String) {
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
            if self.type == .company {
                if result == 1 {
                    self.company.likeState = true
                } else {
                    self.company.likeState = false
                }
            } else {
                if result == 1 {
                    self.industry.likeState = true
                } else {
                    self.industry.likeState = false
                }
            }
            
            self.setHeartButton()
        }
    }
    
    private func endLoading() {
        LoadingManager.hide()
    }
    
    private func setHeartButton() {
        //좋아요 셋팅
        if isUser() {
            //회원용 버튼
            self.heartButton.addTarget(self, action: #selector(self.didTapHeartButton), for: .touchUpInside)
            
            if type == .company {
                if self.company.likeState ?? false {
                    heartButton.setImage(UIImage(named: "ic_general_heart_on"), for: .normal)
                } else {
                    heartButton.setImage(UIImage(named: "ic_general_heart_off"), for: .normal)
                }
            } else {
                if self.industry.likeState ?? false {
                    heartButton.setImage(UIImage(named: "ic_general_heart_on"), for: .normal)
                } else {
                    heartButton.setImage(UIImage(named: "ic_general_heart_off"), for: .normal)
                }
            }
        } else {
            //비회원용 버튼
            self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
            self.heartButton.addTarget(self, action: #selector(self.didTapLoginButton), for: .touchUpInside)
        }
    }
    
    //MARK: - Helpers
    
    func notification() {
        // 팝업 창 닫을 시
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(popUpClose),
            name: NSNotification.Name(rawValue: "Detail_Info_close"),
            object: nil)
    }
    
    @objc func didTapLoginButton() {
        loginView.isHidden = false
    }
    
    @objc func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapHeartButton() {
        
        let id = type == .company ? company.id : industry.id
        
        setDetailHeart(id: id!)
    }
    
    @objc func didTapInfoButton() {
        infoButton.setImage(UIImage(named: "ic_general_info_on"), for: .normal)
        
        let vc = DetailPopUpViewController(description: company.description ?? "")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    // popUpClose
    @objc func popUpClose() {
        infoButton.setImage(UIImage(named: "ic_general_info_off"), for: .normal)
    }
    
    @objc func tapPlayAllButton() {
        if newsList.count > 100 {
            PlayerPresenter.newsListPlayer(news: Array(newsList[...99]))
        } else {
            PlayerPresenter.newsListPlayer(news: newsList)
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
  
    //섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return newsList.count
        }
    }
    
    //셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 80
        }
    }
  
    //셀 속성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "DetailHeader") as! DetailHeaderTableViewCell
            
            headerCell.playAllButton.addTarget(self, action: #selector(tapPlayAllButton), for: .touchUpInside)
            
            if company != nil {
                let url = URL(string: company.logoURL ?? "")
                headerCell.headerImageView.kf.setImage(with: url)
                
                headerCell.titleLabel.text = company.name
                headerCell.subTitleLabel.text = company.industry
            }
            
            if industry != nil {
                let url = URL(string: industry.logoURL ?? "")
                headerCell.headerImageView.kf.setImage(with: url)
                
                headerCell.titleLabel.text = industry.name
                headerCell.subTitleLabel.text = ""
            }
            
            return headerCell
          
        } else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailContent") as! NewsTableViewCell
            if newsList.count != 0 {
                let news = newsList[indexPath.row]
                
                let url = URL(string: news.imageURL ?? "")
                cell.newsImageView.kf.setImage(with: url)
                
                cell.subtitleLabel.text = "\(news.site ?? "") · \(news.time!.toDate()!.utcToLocaleDate())"
                cell.titleLabel.text = news.title
                
                if CacheManager.isCachedNews(id: news.id) {
                    cell.titleLabel.textColor = .newdioGray2
                    cell.subtitleLabel.textColor = .newdioGray2
                } else {
                    cell.titleLabel.textColor = .white
                    cell.subtitleLabel.textColor = .newdioGray1
                }
            }
            return cell
        }

        return UITableViewCell()
      
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell
            
            cell?.titleLabel.textColor = .newdioGray2
            cell?.subtitleLabel.textColor = .newdioGray2
            
            PlayerPresenter.newsPlayer(newsId: newsList[indexPath.row].id)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: .zero)
        } else {
            
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
    
    //스크롤 이벤트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = 180.0

        if scrollView.contentOffset.y > offset {
            playButton.isHidden = false
            if type == .company {
                self.titleLabel.text = company.name
            } else {
                self.titleLabel.text = industry.name
            }
            scrollView.contentInset = UIEdgeInsets(top: self.detailTableView.navigationView.frame.height, left: 0, bottom: 0, right: 0)
        } else {
            playButton.isHidden = true
            self.titleLabel.text = ""
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    //테이블 무한 스크롤 셋팅
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // 마지막 셀일때 다시 API 통신
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if type == .company {
                self.loadCompanyNewsData(id: company.id, lastId: newsList.last?.id ?? 0)
            } else {
                self.loadIndustryNewsData(id: industry.id, lastId: newsList.last?.id ?? 0)
            }
        }
    }
}

//MARK: - Login Delegate

extension DetailViewController: LoginViewDelegate {
    func didTapCheckButton() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Login"), object: nil)
    }
    
    func didTapBackButton() {
        loginView.isHidden = true
    }
    
    func didTapBackgroundView() {
        loginView.isHidden = true
    }
}

//MARK: - Error Delegate

extension DetailViewController: ErrorViewDelegate {
    func didTapRetryButton() {
        self.detailTableView.isHidden = true
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        company = nil
        industry = nil
        newsList = []
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if self.type == .company {
                self.loadCompanyData(id: self.id)
            } else {
                self.loadIndustryData(id: self.id)
            }
        }
    }
}
