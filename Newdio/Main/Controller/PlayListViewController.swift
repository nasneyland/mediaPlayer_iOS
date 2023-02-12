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
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    var scrollMode = false
    
    var playerItem = PlayerPresenter.shared
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.text = "player_playlist".localized()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        return tableView
    }()
    
    var moreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .newdioGray4
        button.setTitleColor(UIColor.newdioGray1, for: .normal)
        button.layer.cornerRadius = 22
        button.setImage(UIImage(named: "ic_general_arrowdown_gray"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("player_more".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
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
    }
    
    static func reset() {
        shared = PlayListViewController()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        view.backgroundColor = .black
        
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
        self.modalPresentationStyle = .overFullScreen
        
        //뷰에 스와이프 추가
        let viewSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleViewSwipes(_:)))
        titleView.addGestureRecognizer(viewSwipeGestureRecognizer)

        //테이블뷰에 스와이프 추가
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //MARK: - Helpers
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    @objc func didTapMore() {
        var excludeList = ""
        var relatedList = ""
        
        for (idx, news) in playerItem.trackList.enumerated() {
            if idx == 0 {
                relatedList += "\(news.id!)"
                excludeList += "\(news.id!)"
            } else if idx < 20 {
                relatedList = "\(relatedList),\(news.id!)"
                excludeList = "\(excludeList),\(news.id!)"
            } else {
                excludeList = "\(excludeList),\(news.id!)"
            }
        }
        
        PlayerAPI.moreNewsAPI(excludeList: excludeList, relatedList: relatedList, error: {
            (type) in
        }) { (news) in
            self.playerItem.trackList.insert(contentsOf: news, at: self.playerItem.trackList.count)
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableView Delegate

extension PlayListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerItem.trackList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let news = playerItem.trackList[indexPath.row]
        
        if CacheManager.isCachedNews(id: news.id) {
            cell.titleLabel.textColor = .newdioGray2
            cell.subtitleLabel.textColor = .newdioGray2
        } else {
            cell.titleLabel.textColor = .white
            cell.subtitleLabel.textColor = .newdioGray1
        }
        
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = "\(news.site ?? "") · \(news.time?.toDate()!.utcToLocaleDate() ?? "")"
        
        let url = URL(string: news.imageURL ?? "")
        cell.newsImageView.kf.setImage(with: url)
        
        if indexPath.row == playerItem.currentTrack {
            cell.backgroundColor = .newdioGray4
            cell.titleLabel.textColor = .newdioMain
            cell.subtitleLabel.textColor = .newdioMain
        } else {
            cell.backgroundColor = .black
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .newdioGray5

//        if let audioUrl = URL(string: self.receiveList[indexPath.row].audioURL) {
//            self.playerItem.player = AVPlayer(url: audioUrl)
//            playerItem.player?.play()
//        }

        playerItem.currentTrack = indexPath.row

        // player Event
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayerListSelect"), object: nil, userInfo: nil)

        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            if self.playerItem.currentTrack > indexPath.row {
                self.playerItem.currentTrack -= 1
            }
            
            self.playerItem.trackList.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        deleteAction.image = UIImage(named: "ic_playerl_delete")
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
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
