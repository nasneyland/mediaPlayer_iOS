//
//  SearchResultViewController.swift
//  Newdio
//
//  Created by najin on 2022/01/02.
//

import UIKit

class SearchResultViewController: UIViewController {

    //MARK: - Properties
    
    var keyword = ""
    var newsList: [NewsThumb] = []
    
    private var errorView: ErrorView!
    
    private let noneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .newdioGray1
        label.text = ""
        label.numberOfLines = 2
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let relatedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .newdioWhite
        label.text = "detail_related_news".localized()
        return label
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("player_listen_all".localized(), for: .normal)
        button.setTitleColor(.newdioGray1, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .newdioBlack
        tableView.isHidden = true
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingManager.show()

        configureNav()
        configureUI()
        
        loadSearchData(lastId: 0, loadType: .load)
    }
    
    //MARK: - Configure
    
    private func configureNav() {
        title = keyword
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_arrowleft"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapBack))
    }
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(noneLabel)
        noneLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureError(type: ErrorType) {
        errorView = ErrorView(frame: .zero, type: type)
        errorView.delegate = self
        
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - API
    
    private func loadSearchData(lastId: Int, loadType: LoadType) {
        SearchAPI.searchAPI(keyword: keyword, lastId: lastId, error: {(type) in
            LoadingManager.hide()
            
            if loadType == .load {
                self.configureError(type: type)
            }
        }) { (datas) in
            LoadingManager.hide()
            
            self.newsList += datas
            
            if loadType == .load {
                // 검색 결과 로드 로그 전송
                LogManager.sendLogData(screen: .search, action: .view, params: ["type": "search", "word": self.keyword, "count": self.newsList.count])
            } else {
                // 검색 결과 추가 로드 로그 전송
                LogManager.sendLogData(screen: .search, action: .view, params: ["type": "next_page", "word": self.keyword, "count": self.newsList.count])
            }
            
            if self.newsList.count == 0 {
                self.noneLabel.text = String(format: "search_no_word".localized(), String(self.keyword))
                self.noneLabel.targetColored(targetString: self.keyword)
                
                self.tableView.isHidden = true
                self.noneLabel.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.noneLabel.isHidden = true
                
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapBack() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapPlay() {
        PlayerPresenter.playListPlayer(newsList: newsList, vc: self)
        
        // 검색 결과 전체듣기 클릭 로그 전송
        LogManager.sendLogData(screen: .search, action: .click, params: ["type": "play_all", "word": self.keyword])
    }
}

//MARK: - TableView Delegate

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let news = newsList[indexPath.row]
        
        if CacheManager.isCachedNews(id: news.id) {
            cell.titleLabel.textColor = .newdioGray2
            cell.subtitleLabel.textColor = .newdioGray2
        } else {
            cell.titleLabel.textColor = .newdioWhite
            cell.subtitleLabel.textColor = .newdioGray1
        }
        
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = "\(news.site ?? "") · \(news.time.toDate()!.utcToLocale(type: .date) ?? "")"
        
        let url = URL(string: news.imageURL ?? "")
        cell.newsImageView.kf.setImage(with: url)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsId: Int = newsList[indexPath.row].id
        PlayerPresenter.playNewsPlayer(newsId: newsId)
        
        // 검색 결과 클릭 로그 전송
        LogManager.sendLogData(screen: .search, action: .click, params: ["type": "result", "word": self.keyword, "id": newsId, "position": indexPath.row, "count": newsList.count])
        
        tableView.reloadData()
    }
    
    //테이블 무한 스크롤 셋팅
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // 마지막 셀일때 다시 API 통신
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            
            // 검색 결과 추가 로드 로그 전송
            LogManager.sendLogData(screen: .search, action: .drag, params: ["type": "next_page", "word": self.keyword])
            
            self.loadSearchData(lastId: newsList.last?.id ?? 0, loadType: .more)
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

extension SearchResultViewController: ErrorViewDelegate {
    func didTapRetry() {
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        self.newsList = []
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.loadSearchData(lastId: self.newsList.last?.id ?? 0, loadType: .load)
        }
    }
}
