//
//  LiveViewController.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit
import Gifu

class LiveViewController: UIViewController {

    //MARK: - Properties
    
    private var nextURL: String?
    private var liveList: [Live] = []
    
    private var errorView: ErrorView!
    
    private lazy var liveTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .none
        table.rowHeight = UITableView.automaticDimension
        table.register(LiveTableViewCell.self, forCellReuseIdentifier: LiveTableViewCell.identifier)
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
        
        loadLiveData(id: 0, loadType: .load)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        liveTableView.reloadData()
    }
    
    //MARK: - Configure
    
    private func configureNotification() {
        // 탭바 버튼 클릭 Notipication Receive
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapMenu),
            name: NotificationManager.Main.live,
            object: nil)
        
        // 팝업 창 닫을 시
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapClose),
            name: NotificationManager.Live.closeInfo,
            object: nil)
    }
    
    private func configureNav() {
        setLargeNav(title: "menu_live".localized())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_help_off"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapHelp))
    }
    
    private func configureUI() {
        liveTableView.delegate = self
        liveTableView.dataSource = self
        
        view.addSubview(liveTableView)
        liveTableView.snp.makeConstraints { make in
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
    
    private func loadLiveData(id: Int, loadType: LoadType) {
   
        LiveAPI.liveAPI(id: id, error: {(type) in
            
            // 첫 로드시 에러나면 에러 뷰 나타내기
            if loadType == .load {
                self.configureError(type: type)
            }
            
            self.endLoading()
        }) { (datas) in
            
            switch loadType {
            case .load:
                // 라이브 로드 로그 전송
                LogManager.sendLogData(screen: .live, action: .view, params: nil)
            case .reload:
                // 라이브 새로고침 로드 로그 전송
                LogManager.sendLogData(screen: .live, action: .view, params: ["type": "reload", "id": datas.last?.id ?? 0, "pre_id": self.liveList.last?.id ?? 0])
                self.liveList = []
            case .more:
                // 라이브 추가 로드 로그 전송
                LogManager.sendLogData(screen: .live, action: .view, params: ["type": "next_page", "id": datas.last?.id ?? 0, "pre_id": self.liveList.last?.id ?? 0])
            }
            
            self.liveTableView.isHidden = false
            
            self.liveList += datas
            self.configureUI()
            self.liveTableView.reloadData()
            self.endLoading()
        }
    }
    
    private func endLoading() {
        LoadingManager.hide()
        self.refresh.endRefreshing()
    }
    
    //MARK: - Helpers
    
    @objc func updateUI(refresh: UIRefreshControl) {
        
        // 라이브 새로고침 로그 전송
        LogManager.sendLogData(screen: .live, action: .drag, params: ["type": "reload"])
        
        self.loadLiveData(id: 0, loadType: .reload)
    }
    
    @objc func didTapClose() {
        navigationController?.navigationBar.tintColor = .newdioWhite
    }
    
    @objc func didTapMenu(){
        let indexPath = IndexPath(row: 0, section: 0)
        self.liveTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
                       
    @objc func didTapHelp() {
        navigationController?.navigationBar.tintColor = .newdioMain
        
        let vc = LivePopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - TableView Extension

extension LiveViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.liveList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = liveTableView.dequeueReusableCell(withIdentifier: LiveTableViewCell.identifier, for: indexPath) as! LiveTableViewCell
        
        if liveList.count != 0 {
            let live = self.liveList[indexPath.row]
            
            cell.delegate = self
            cell.newsId = live.id
        
            // 카테고리 세팅
            if live.category.count != 0 {
                cell.categoryNameLabel.text = live.category
                
                let companyButtonList = [cell.companyNameButton1, cell.companyNameButton2, cell.companyNameButton3]
                
                //label 초기화
                for companyButton in companyButtonList {
                    companyButton.isHidden = true
                    companyButton.setTitle("", for: .normal)
                }
                
                //label에 데이터 셋팅
                for idx in 0..<live.companyList.count {
                    if idx < 3 {
                        let companyName = live.companyList[idx].name
                        if companyName.count <= 6 {
                            companyButtonList[idx].setTitle(String(format: "#%@", companyName), for: .normal)
                        } else {
                            companyButtonList[idx].setTitle(String(format: "#%@...", companyName.prefix(6) as CVarArg), for: .normal)
                        }
                        
                        companyButtonList[idx].isHidden = false
                        let companyId = live.companyList[idx].id
                        cell.companyId[idx] = companyId
                    }
                }
            } else {
                cell.categoryNameLabel.text = ""
            }
            
            //긍정도 셋팅
            if live.sentiment > 0.6 && live.sentiment <= 1.0 {
                cell.sentimentView.image = UIImage(named: "ic_live_green")
            } else if live.sentiment >= 0.4 && live.sentiment <= 0.6 {
                cell.sentimentView.image = UIImage(named: "ic_live_yellow")
            } else if live.sentiment >= 0 && live.sentiment < 0.4 {
                cell.sentimentView.image = UIImage(named: "ic_live_red")
            } else {
                cell.sentimentView.image = nil
            }
            
            //제목 셋팅
            cell.contentTextView.text = live.title!
            
            //업로드 시간 셋팅
            let postDate = live.date.toDate()
            let timeAgo = postDate!.setTimeAgo()
            cell.dateLabel.text = timeAgo
            
            //글자 크기 셋팅
            cell.contentTextView.font = UIFont.customFont(size: 15, weight: .regular)
        }

        return cell
    }

    // 테이블 무한 스크롤 셋팅
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // 마지막 셀일때 다시 API 통신
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            // 라이브 추가 로드 로그 전송
            LogManager.sendLogData(screen: .live, action: .drag, params: ["type": "next_page", "id": self.liveList.last?.id ?? 0])
            
            self.loadLiveData(id: liveList.last?.id ?? 0, loadType: .more)
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

extension LiveViewController: ErrorViewDelegate {
    func didTapRetry() {
        LoadingManager.show()
        
        self.liveTableView.isHidden = true
        self.liveList = []
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.loadLiveData(id: self.liveList.last?.id ?? 0, loadType: .load)
        }
    }
}

//MARK: - Cell Delegate

extension LiveViewController: LiveTableViewCellDelegate {
    func didTapNews(newsId: Int) {
        PlayerPresenter.liveNewsPlayer(newsId: newsId)
        
        // 라이브 기사 클릭 로그 전송
        LogManager.sendLogData(screen: .live, action: .click, params: ["type": "live", "id": newsId, "last_id": liveList.last?.id ?? 0])
    }
    
    func didTapHashTag(companyId: String, newsId: Int) {
        DetailPresenter.startDetail(id: companyId, type: .company)
        
        // 라이브 해시태그 클릭 로그 전송
        LogManager.sendLogData(screen: .live, action: .click, params: ["type": "company", "id": newsId, "co_id": companyId])
    }
}
