//
//  HomeViewController.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit
import Alamofire
import SnapKit
import Gifu

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private var contentOffset : [CGFloat] = []
    
    private var refreshTopState = true
    private var refreshHomeState: [Bool] = []
    
    private var topNews: Category?
    private var homeNewsList: [Category] = []
    
    private var errorView: ErrorView!
    
    private lazy var homeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .newdioBlack
        table.showsVerticalScrollIndicator = false
        table.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.identifier)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        table.refreshControl = refresh
        table.isHidden = true
        return table
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.tintColor = .clear
        
        let gifImageView = GIFImageView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2 - 15),
                                                      y: 15,
                                                      width: 30,
                                                      height: 30))
        gifImageView.animate(withGIFNamed: "loading")
        
        let view = UIView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2 - 15),
                                        y: 15,
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
        
        loadHomeNewsData(loadType: .load)
    }
    
    //MARK: - Configure
    
    private func configureNav() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didTapMenu),
                                               name: NotificationManager.Main.newdio,
                                               object: nil)
    }
    
    private func configureUI() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
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
    
    private func loadHomeNewsData(loadType: LoadType) {
        
        HomeAPI.homeNewsAPI(error: {
            (type) in
            self.configureError(type: type)
            self.endLoading()
        }) {
            (data) in
            
            if loadType == .reload {
                // 뉴디오 리로드 로그 전송
                LogManager.sendLogData(screen: .newdio, action: .view, params: ["type": "reload"])
            } else {
                // 뉴디오 로드 로그 전송
                LogManager.sendLogData(screen: .newdio, action: .view, params: nil)
            }
            
            self.homeTableView.isHidden = false
            
            var categoryList = data
            
            //뉴스 리스트 셋팅
            if categoryList.count != 0 {
                self.topNews = categoryList.removeFirst()
                self.homeNewsList = categoryList.shuffled()
            }
            
            //홈 뉴스 초기화
            self.contentOffset = []
            self.refreshHomeState = []
            self.refreshTopState = true
            
            for _ in 0...categoryList.count {
                self.contentOffset.append(0)
                self.refreshHomeState.append(true)
            }
            
            self.configureUI()
            self.homeTableView.reloadData()
            self.endLoading()
        }
    }
    
    private func endLoading() {
        LoadingManager.hide()
        
        self.refresh.endRefreshing()
    }
    
    //MARK: - Helpers
    
    @objc func updateUI(refresh: UIRefreshControl) {
        // 뉴디오 새로고침 로그 전송
        LogManager.sendLogData(screen: .newdio, action: .drag, params: ["type": "reload"])
        
        // 홈 데이터 셋팅
        loadHomeNewsData(loadType: .reload)
    }
    
    // 탭바 버튼 클릭 이벤트
    @objc private func didTapMenu(){
        let indexPath = IndexPath(row: 0, section: 0)
        self.homeTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

//MARK: - Table Delegate, DataSource

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeNewsList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            // HOT 뉴스
            let cell = homeTableView.dequeueReusableCell(withIdentifier: TopTableViewCell.identifier, for: indexPath) as! TopTableViewCell
            cell.cellDelegate = self
            
            // HOT 뉴스 셋팅
            if let topNews = topNews {
                // 새로고침인 경우에만 (셀 재사용 버그 해결)
                if self.refreshTopState {
                    cell.updateCellWith(row: topNews)
                }
            }
            self.refreshTopState = false
            
            return cell
        } else {
            // 카테고리 뉴스
            let cell = homeTableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
            cell.cellDelegate = self

            let index = indexPath.row - 1
            
            // 카테고리 뉴스 정보 셋팅
            cell.categoryLabel.text = homeNewsList[index].title
            cell.updateCellWith(row: homeNewsList[index])
            
            // 카테고리 뉴스 위치 셋팅
            if self.refreshHomeState[index] {
                // 새로고침인 경우 스크롤 위치 초기화
                cell.homeCollectionView.setContentOffset(.zero, animated: false)
            } else {
                // 새로고침이 아닌 경우 저장된 스크롤 위치로 이동
                cell.homeCollectionView.contentOffset.x = contentOffset[indexPath.row]
            }
            
            self.refreshHomeState[index] = false
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeTableViewCell else {
            return
        }
        
        // 해당 카테고리 뉴스의 스크롤 위치 저장
        contentOffset[indexPath.row] = cell.homeCollectionView.contentOffset.x
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 400
        } else {
            return 220
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: - Collection Delegate

extension HomeViewController: TopCollectionViewCellDelegate {
    func collectionView(collectionviewcell: TopCollectionViewCell?, index: Int, didTappedInTableViewCell: TopTableViewCell) {
        if let category = didTappedInTableViewCell.category {
            // 핫 뉴스 클릭 로그 전송
            LogManager.sendLogData(screen: .newdio, action: .click, params: ["type": "hot", "position": index, "max_position": category.newsList.count - 1])
            
            // 플레이어 뷰 present
            PlayerPresenter.playNewsPlayer(newsId: category.newsList[index].id)
        }
    }
}

extension HomeViewController: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: HomeCollectionViewCell?, index: Int, didTappedInTableViewCell: HomeTableViewCell) {
        if let category = didTappedInTableViewCell.category {
            // 토픽 뉴스 클릭 로그 전송
            LogManager.sendLogData(screen: .newdio, action: .click, params: ["type": "topic", "category": category.name ?? "", "keyword": category.id ?? "", "position": index, "max_position": category.newsList.count - 1])
            
            // 플레이어 뷰 present
            PlayerPresenter.playNewsPlayer(newsId: category.newsList[index].id)
        }
    }
}

//MARK: - Error Delegate

extension HomeViewController: ErrorViewDelegate {
    func didTapRetry() {
        homeTableView.isHidden = true
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.loadHomeNewsData(loadType: .load)
        }
    }
}
