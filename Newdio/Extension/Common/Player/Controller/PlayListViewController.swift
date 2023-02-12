//
//  PlayListViewController.swift
//  Newdio
//
//  Created by sg on 2021/11/11.
//

import UIKit
import SnapKit
import AVFoundation

class PlayListViewController: UIViewController {

    //MARK: - Properties
    
    static var shared = PlayListViewController()
    
    var playerItem = PlayerPresenter.shared
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    var scrollMode = false
    var listMode = false
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.text = "player_playlist".localized()
        label.textColor = .newdioWhite
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .newdioBlack
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        return tableView
    }()
    
    private var moreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioGray4
        button.setTitleColor(UIColor.newdioGray1, for: .normal)
        button.layer.cornerRadius = 22
        button.setImage(UIImage(named: "ic_general_arrowdown_gray"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("player_more".localized(), for: .normal)
        button.setTitleColor(.newdioWhite, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        button.marginImageWithText(margin: 10)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        configureUI()
        configureGesture()
        
        tableView.reloadData()
        
        // 리스트 로드 로그 전송
        LogManager.sendLogData(screen: .player, action: .view, params: ["type": "playlist", "id": playerItem.trackList[playerItem.currentTrack].id ?? 0])
    }
    
    static func reset() {
        // 싱글톤 플레이리스트 초기화
        shared = PlayListViewController()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
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
    
    private func loadMoreNews(excludeList: String, relatedList: String) {
        PlayerAPI.moreNewsAPI(excludeList: excludeList, relatedList: relatedList, error: {
            (type) in
            print("error")
        }) { (news) in
            self.playerItem.trackList.insert(contentsOf: news, at: self.playerItem.trackList.count)
            self.tableView.reloadData()
        }
    }
    
    private func loadLiveData(newsId: Int) {
        LiveAPI.liveNewsAPI(id: newsId, error: {
            (type) in
            print("error")
        }) { (news) in
            self.playerItem.trackList += news.newsList
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 뷰 스와이프
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
    
    /// 테이블뷰 스와이프
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
    
    /// 더보기 버튼 클릭
    @objc func didTapMore() {
        //추가 뉴스 셋팅
        if PlayerViewController.shared.playerType == .live {
            loadLiveData(newsId: playerItem.trackList.last?.id ?? 0)
        } else {
            var excludeList = ""
            var relatedList = ""
            
            for (idx, news) in playerItem.trackList.enumerated() {
                if idx == 0 {
                    relatedList += "\(news.id)"
                    excludeList += "\(news.id)"
                } else if idx < 20 {
                    relatedList = "\(relatedList),\(news.id)"
                    excludeList = "\(excludeList),\(news.id)"
                } else {
                    excludeList = "\(excludeList),\(news.id)"
                }
            }
            
            loadMoreNews(excludeList: excludeList, relatedList: relatedList)
        }
    }
}

//MARK: - TableView Delegate

extension PlayListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerItem.trackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let news = playerItem.trackList[indexPath.row]
        
        // 뉴스 정보 셋팅
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = "\(news.site ?? "") · \(news.time.toDate()!.utcToLocale(type: .date) ?? "")"
        
        // 뉴스 이미지 셋팅
        let url = URL(string: news.imageURL ?? "")
        cell.newsImageView.kf.setImage(with: url)
        
        // 현재 뉴스 활성화 처리
        if indexPath.row == playerItem.currentTrack {
            cell.backgroundColor = .newdioGray4
            cell.titleLabel.textColor = .newdioMain
            cell.subtitleLabel.textColor = .newdioMain
        } else {
            cell.backgroundColor = .newdioBlack
            
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 리스트 기사 클릭 로그 전송
        LogManager.sendLogData(screen: .player, action: .click, params: ["type": "playlist", "id": playerItem.trackList[playerItem.currentTrack].id ?? 0, "to_id": playerItem.trackList[indexPath.row].id ?? 0])
        
        //현재 재생중인 셀 셋팅
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .newdioGray5

        playerItem.currentTrack = indexPath.row

        NotificationCenter.default.post(name: NotificationManager.Player.selectNews, object: nil, userInfo: nil)

        // 플레이리스트
        self.dismiss(animated: false) {
            if self.listMode {
                // 리스트만 present 된 상황에서 플레이어 뷰 present
                PlayerPresenter.openPlayer()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //슬라이드 삭제 액션 셋팅
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            if self.playerItem.currentTrack > indexPath.row {
                self.playerItem.currentTrack -= 1
            }
            
            self.playerItem.trackList.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        //삭제 뷰 셋팅
        deleteAction.image = UIImage(named: "ic_playerl_delete")
        deleteAction.backgroundColor = .newdioRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: - Gesture Delegate

extension PlayListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
