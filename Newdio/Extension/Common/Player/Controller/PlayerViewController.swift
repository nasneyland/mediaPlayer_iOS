//
//  PlayerViewController.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import UIKit
import AVFoundation
import MediaPlayer
import Kingfisher

enum PlayerType {
    case live // 라이브
    case basic // 관련 뉴스
}

class PlayerViewController: UIViewController {
    
    //MARK: - Properties
    
    static var shared = PlayerViewController()

    private var initialTouchPoint = CGPoint(x: 0, y: 0)
    
    var playerItem = PlayerPresenter.shared
    var timeObserver: Any?
    
    var playerType: PlayerType = .basic
    var moreType = false
    
    private var newsId: Int!
    private var news: News!
    
    private let playerView = PlayerView()
    private var loginView: LoginView!
    private var errorView: ErrorView!
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_arrowdown"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private var listButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_list"), for: .normal)
        button.addTarget(self, action: #selector(didTapList), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private var heartButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "ic_general_heart_off"), for: .normal)
        button.tintColor = .newdioWhite
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    private var moreButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_more_vert_white"), for: .normal)
        button.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private var originalButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.backgroundColor = .newdioGray4
        button.setTitleColor(UIColor.newdioGray1, for: .normal)
        button.layer.cornerRadius = 22
        button.setImage(UIImage(named: "ic_general_arrowup"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("player_original".localized(), for: .normal)
        button.setTitleColor(.newdioWhite, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapOriginal), for: .touchUpInside)
        button.marginImageWithText(margin: 10)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureLogin()
        configureGesture()
        
        configureAirPlayCenter()
        configureNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playerView.contentTextView.font = UIFont.customFont(size: 16, weight: .regular)
    }
    
    ///라이브 뉴스 클릭한 경우
    func initLivePlayer(newsId: Int) {
        self.newsId = newsId
        self.playerType = .live
        self.moreType = false
        
        configureUI()
        loadLiveData(newsId: newsId)
    }
    
    ///특정 뉴스 클릭한 경우
    func initPlayer(newsId: Int) {
        self.newsId = newsId
        self.playerType = .basic
        self.moreType = false
        
        configureUI()
        loadNewsListData(newsId: newsId)
    }
    
    ///전체 듣기 한 경우
    func initPlayer(newsList: [NewsThumb]) {
        self.newsId = newsList[0].id
        self.playerType = .basic
        self.moreType = false
        
        configureUI()
        self.playerItem.trackList = newsList
        loadNewsData(newsId: newsId)
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        setBackgroundView(active: true)
        
        playerView.delegate = self
        
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(listButton)
        listButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.right.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.right.equalTo(listButton.snp.left).offset(-5)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.right.equalTo(moreButton.snp.left).offset(-5)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(originalButton)
        originalButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
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
        LoadingManager.hide()
        
        errorView = ErrorView(frame: .zero, type: type)
        errorView.delegate = self

        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        view.bringSubviewToFront(cancelButton)
    }
    
    private func configureGesture() {
        //뷰에 스와이프 추가
        let viewSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleViewSwipes(_:)))
        playerView.addGestureRecognizer(viewSwipeGestureRecognizer)
        
        //텍스트뷰에 스와이프 추가
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeGestureRecognizer.delegate = self
        playerView.contentTextView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectListNews), name: NotificationManager.Player.selectNews, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPlayer), name: NotificationManager.Player.refresh, object: nil)
    }
    
    private func configureAirPlayCenter() {
        let center = MPRemoteCommandCenter.shared()
        
       // 제어 센터 play 버튼 누르면 발생할 이벤트를 정의합니다.
        center.playCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
//            self.playerItem.isPlaying = true
            self.setPlayPause()
            return MPRemoteCommandHandlerStatus.success
        }

       // 제어 센터 pause 버튼 누르면 발생할 이벤트를 정의합니다.
        center.pauseCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
//            self.playerItem.isPlaying = false
            self.setPlayPause()
            return MPRemoteCommandHandlerStatus.success
        }
        
        // 제어 센터 next 버튼 누르면 발생할 이벤트를 정의합니다.
        center.nextTrackCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            self.setNextAudio()
            return MPRemoteCommandHandlerStatus.success
        }

        // 제어 센터 previous 버튼 누르면 발생할 이벤트를 정의합니다.
        center.previousTrackCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            self.setPreviousAudio()
            return MPRemoteCommandHandlerStatus.success
        }
    }
    
    //MARK: - API
    
    private func loadNewsData(newsId: Int) {
        //특정 뉴스 데이터 셋팅 -> News
        PlayerAPI.newsAPI(id: newsId, error: {
            (type) in
            self.configureError(type: type)
        }) { (news) in
            //뉴스 정보 셋팅
            self.news = news
            
            //플레이어 셋팅
            self.setPlayerView()
            self.setPlayer()
        }
    }

    private func loadLiveData(newsId: Int) {
        // 라이브 News + List
        LiveAPI.liveNewsAPI(id: newsId, error: {
            (type) in
            self.configureError(type: type)
        }) { (news) in
            //뉴스 정보 셋팅
            self.news = news
            
            if self.moreType == false {
                //뉴스 플레이 리스트 셋팅
                let currentNews = NewsThumb(id: news.id, title: news.title, imageURL: news.imageURL!, site: news.site, time: news.time)
                self.playerItem.trackList = news.newsList
                self.playerItem.trackList.insert(currentNews, at: 0)
            } else {
                //뉴스 플레이 리스트 추가
                self.playerItem.trackList += news.newsList
            }

            //플레이어 셋팅
            self.setPlayerView()
            self.setPlayer()
        }
    }
    
    private func loadNewsListData(newsId: Int) {
        // News + List
        PlayerAPI.newsListAPI(id: newsId, error: {
            (type) in
            self.configureError(type: type)
        }) { (news) in
            //뉴스 정보 셋팅
            self.news = news
            
            //뉴스 플레이 리스트 셋팅
            let currentNews = NewsThumb(id: news.id, title: news.title, imageURL: news.imageURL!, site: news.site, time: news.time)
            self.playerItem.trackList = news.newsList
            self.playerItem.trackList.insert(currentNews, at: 0)

            //플레이어 셋팅
            self.setPlayerView()
            self.setPlayer()
        }
    }

    private func loadMoreNews(excludeList: String, relatedList: String) {
        //추가 News + List
        PlayerAPI.moreNewsAPI(excludeList: excludeList, relatedList: relatedList, error: {
            (type) in
        }) { (news) in
            //뉴스 리스트 추가 셋팅
            self.playerItem.trackList.insert(contentsOf: news, at: self.playerItem.trackList.count)

            //다음 뉴스 셋팅
            self.playerItem.currentTrack += 1
            self.newsId = self.playerItem.trackList[self.playerItem.currentTrack].id
            self.loadNewsData(newsId: self.newsId)
        }
    }
    
    //뉴스 좋아요
    private func setNewsHeart() {
        PlayerAPI.newsHeartAPI(id: self.news.id, error: {(error) in
            self.present(ErrorManager.errorToAlert(error: error), animated: false)
        }) { (result) in
            
            // 기사 좋아요 클릭 로그 전송
            LogManager.sendLogData(screen: .player, action: .click, params: ["type": "like", "like": result, "id": self.news.id ?? 0])
            
            if result == 1 {
                self.setHeartButton(active: true)
            } else {
                self.setHeartButton(active: false)
            }
        }
    }
    
    //MARK: - Selector
    
    @objc func refreshPlayer() {
        //다른 앱에서 제어할 때
        if let player = playerItem.player {
            //현재 재생중인지 체크
            if ((player.rate != 0) && (player.error == nil)) {
                setPlayButton(active: true)
            } else {
                setPlayButton(active: false)
            }
        }
    }
    
    @objc func selectListNews() {
        //리스트에서 뉴스 클릭 시
        self.newsId = playerItem.trackList[playerItem.currentTrack].id
        self.loadNewsData(newsId: newsId)
    }
    
    @objc func didTapLike() {
        //좋아요 셋팅
        if APIManager.isUser() {
            //회원이면 좋아요 처리
            setNewsHeart()
        } else {
            //비회원이면 로그인 뷰
            loginView.isHidden = false
        }
        
    }

    @objc func didTapList() {
        
        // 리스트 클릭 로그 전송
        LogManager.sendLogData(screen: .player, action: .click, params: ["type": "playlist", "id": self.news.id ?? 0])
        
        PlayerPresenter.addPlayList(vc: self)
    }
    
    @objc func didTapOriginal() {
        
        // 원문보기 로그 전송
        LogManager.sendLogData(screen: .player, action: .click, params: ["type": "original", "id": self.news.id ?? 0])
        
        let vc = OriginalNewsViewController(title: self.news.originalTitle ?? "", content: self.news.originalContent ?? "")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapMore() {
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .newdioWhite
        
        //공유하기
        let share =  UIAlertAction(title: "player_share".localized(), style: .default) { (action) in
            
            // 더보기 옵션 클릭 로그 전송
            LogManager.sendLogData(screen: .player, action: .click, params: ["type": "more", "id": self.news.id ?? 0, "position": 0])
            
            self.shareNews()
        }
        //신고하기
        let report =  UIAlertAction(title: "player_report_do".localized(), style: .default) { (action) in
            
            // 더보기 옵션 클릭 로그 전송
            LogManager.sendLogData(screen: .player, action: .click, params: ["type": "more", "id": self.news.id ?? 0, "position": 1])
            
            let vc = ReportViewController()
            vc.newsId = self.news.id ?? 0
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
        //사이트로 이동
        let link =  UIAlertAction(title: "player_link".localized(), style: .default) { (action) in
            
            // 더보기 옵션 클릭 로그 전송
            LogManager.sendLogData(screen: .player, action: .click, params: ["type": "more", "id": self.news.id ?? 0, "position": 2])
            
            if let webUrl = URL(string: "\(self.news.link ?? "")") {
                UIApplication.shared.open(webUrl, options: [:])
            }
        }
        let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
        
        alert.addAction(share)
        alert.addAction(report)
        alert.addAction(link)
        alert.addAction(cancel)

        //디바이스 타입이 iPad일때
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                // ActionSheet가 표현되는 위치를 저장해줍니다.
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //뷰 스와이프
    @objc func handleViewSwipes(_ sender: UIPanGestureRecognizer) {
        loginView.isHidden = true
        
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
                
                // 플레이어 오프 스크린 로그 전송
                LogManager.sendLogData(screen: .player, action: .foreground, params: ["type": "player", "id": self.news.id ?? 0])
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    //텍스트뷰 스와이프
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view.window)

        if sender.state == .began {
            initialTouchPoint = touchPoint
        }
        
        if self.playerView.contentTextView.contentOffset.y == 0 {
            //텍스트뷰 위치가 top인 경우
            if touchPoint.y - initialTouchPoint.y > 0 {
                //아래로 스와이프
                playerView.contentTextView.isScrollEnabled = false
                playerView.contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
            } else {
                //위로 스와이프
                playerView.contentTextView.isScrollEnabled = true
                playerView.contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            }
        } else {
            //텍스트뷰 위치가 아래인 경우
            playerView.contentTextView.isScrollEnabled = true
            playerView.contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        }
    }
    
    //MARK: - Helpers
    
    private func setBackgroundView(active: Bool) {
        originalButton.isHidden = active
        listButton.isHidden = active
        heartButton.isHidden = active
        moreButton.isHidden = active
        playerView.isHidden = active
    }
    
    private func setHeartButton(active: Bool) {
        if active {
            self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_on"), for: .normal)
            self.heartButton.tintColor = .newdioMain
        } else {
            self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
            self.heartButton.tintColor = .newdioWhite
        }
    }
    
    private func setPlayButton(active: Bool) {
        if active {
//            playerItem.isPlaying = true
            playerView.playPauseButton.setImage(#imageLiteral(resourceName: "ic_player_play"), for: .normal)
        } else {
//            playerItem.isPlaying = false
            playerView.playPauseButton.setImage(#imageLiteral(resourceName: "ic_player_stop"), for: .normal)
        }
    }
    
    private func setPlayerView() {
        
        // 플레이어 로드 로그 전송
        LogManager.sendLogData(screen: .player, action: .view, params: ["type": "player", "id": self.news.id ?? 0])
        
        LoadingManager.hide()
        setBackgroundView(active: false)
        
        //뉴스 읽음 처리
        CacheManager.setNewsCache(id: self.news.id)

        //플레이어 정보 셋팅
        print("--------")
        print(self.news.longSummary)
        
        let url = URL(string: self.news.imageURL ?? "")
        self.playerView.newsImageView.kf.setImage(with: url)
        self.playerView.idLabel.text = "\(self.news.id ?? 0)"
        self.playerView.siteLabel.text = self.news.site
        self.playerView.dateLabel.text = self.news.time.toDate()?.utcToLocale(type: .dateTime)
        self.playerView.titleLabel.text = self.news.title
        self.playerView.contentTextView.text = self.news.longSummary ?? ""

        self.heartButton.addTarget(self, action: #selector(self.didTapLike), for: .touchUpInside)
        
        //좋아요 셋팅
        if APIManager.isUser() {
            //회원용 버튼
            setHeartButton(active: self.news.likeState ?? false)
        } else {
            //비회원용 버튼
            setHeartButton(active: false)
        }

        //플레이리스트 셋팅
        PlayListViewController.shared.tableView.reloadData()
    }
    
    private func setPlayer() {
        if let audioUrl = URL(string: news.audioURL) {
            // time observer 초기화
            if let player = self.playerItem.player {
                player.removeTimeObserver(self.timeObserver)
            }
            
            // 플레이어 셋팅
            self.playerItem.player = AVPlayer(url: audioUrl)
            
            // 플레이어 time observer 셋팅
            if let player = self.playerItem.player {
                remoteCommandInfoCenterSetting()
                timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) {
                    time in
                    self.updateTime(time: time)
                }
            }
            
            // 총 재생시간 셋팅
            let totalDurationTime = self.playerItem.player?.currentItem?.asset.duration.seconds ?? 0.0
            playerView.totalTimeLabel.text = totalDurationTime.secondsToString()
//            playerView.currentTimeLabel.text = "00:00"
            
            // 플레이어 오디오 셋팅
            setPlayerAudio(totalTime: Int(totalDurationTime))
        } else {
            // 플레이어 초기화
            self.playerItem.player = nil
            
            // 재생시간 초기화
            playerView.currentTimeLabel.text = "00:00"
            playerView.totalTimeLabel.text = "00:00"
        }
    }
    
    private func setPlayerAudio(totalTime: Int) {
        if APIManager.isUser() {
            if let player = playerItem.player {
                if CacheManager.getAutoPlay() == AutoPlay.on.rawValue {
                    
                    // 플레이어 자동재생 로그 전송
                    LogManager.sendLogData(screen: .player, action: .autoClick, params: ["type": "play", "id": self.news.id ?? 0, "cur_time": 0, "max_time": totalTime])
                    
                    //자동 재생 모드인 경우 - play
                    setPlayButton(active: true)
                    player.play()
                    
                    //플레이어 바 셋팅
                    MainTabBarController.shared.setPlayerBar(news: news)
                } else {
                    //자동 재생 모드가 아닌 경우 - pause
                    setPlayButton(active: false)
                    player.pause()
                    
                    //플레이어 바 셋팅
                    MainTabBarController.shared.setPlayerBar(news: news)
                }
            }
        }
    }
    
    private func setPlayPause() {
        if APIManager.isUser() {
            if let player = playerItem.player {
                
                //플레이어 바 셋팅
                MainTabBarController.shared.setPlayerBar(news: news)
                
                let currentTime = Int(player.currentItem?.currentTime().seconds ?? 0.0)
                let totalTime = Int(player.currentItem?.asset.duration.seconds ?? 0.0)
                
                if ((player.rate != 0) && (player.error == nil)) {
                    //현재 재생중인지 체크
                    setPlayButton(active: false)
                    player.pause()
                    
                    // 플레이어 일시정지 로그 전송
                    LogManager.sendLogData(screen: .player, action: .click, params: ["type": "pause", "id": self.news.id ?? 0, "cur_time": currentTime, "max_time": totalTime])
                } else {
                    //현재 정지중인지 체크
                    setPlayButton(active: true)
                    player.play()
                    
                    // 플레이어 재생 로그 전송
                    LogManager.sendLogData(screen: .player, action: .click, params: ["type": "play", "id": self.news.id ?? 0, "cur_time": currentTime, "max_time": totalTime])
                }
            }
        }
    }
    
    //뉴스 공유하기
    private func shareNews() {
        let textToShare = ["[\("appname".localized())]\(news.title ?? "")\n\n\(news.site ?? "") | \(news.time.toDate()?.utcToLocale(type: .dateTime) ?? "")\n\n\(news.longSummary ?? "")\n\n\(SITE_URL)"]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view // 아이패드에서도 동작하도록 팝오버로 설정
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        activityVC.excludedActivityTypes = [ .airDrop ] //airDrop 제외
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func setNextAudio() {
        
        if playerItem.currentTrack + 1 < playerItem.trackList.count {
            //다음 뉴스가 있는 경우
            let currentId = self.news.id ?? 0
            
            playerItem.currentTrack += 1
            let nextId = playerItem.trackList[playerItem.currentTrack].id ?? 0
            
            self.newsId = nextId
            self.loadNewsData(newsId: newsId)
            
            // 다음 뉴스 클릭 로그 전송
            LogManager.sendLogData(screen: .player, action: .click, params: ["type": "next", "to_id": nextId, "id": currentId])
        } else {
            //다음 뉴스가 없는 경우 추가 로딩
            self.moreType = true
            
            //추가 뉴스 셋팅
            if playerType == .live {
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
    
    private func setPreviousAudio() {
        if playerItem.currentTrack != 0 {
            //이전 뉴스가 있는 경우
            let currentId = self.news.id ?? 0
            
            playerItem.currentTrack -= 1
            let nextId = playerItem.trackList[playerItem.currentTrack].id ?? 0
            
            self.newsId = nextId
            
            self.loadNewsData(newsId: self.newsId)
            
            // 이전 뉴스 클릭 로그 전송
            LogManager.sendLogData(screen: .player, action: .click, params: ["type": "previous", "to_id": nextId, "id": currentId])
        }
    }

    /// AirPlay 오디오 정보 셋팅
    func remoteCommandInfoCenterSetting() {
        playerItem.airPlayCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = playerItem.airPlayCenter.nowPlayingInfo ?? [String: Any]()

        // 현재 재생중인 뉴스 정보 셋팅
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.news.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = self.news.site
        
        // 콘텐츠 길이 초기 셋팅
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.player?.currentItem?.duration.seconds ?? 0.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        
        // 오디오 이미지 셋팅
        if let url = URL(string: self.news.imageURL ?? "") {
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource,
                                                     options: nil,
                                                     progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    let image = value.image
                    let resizedImage = image.crop(rect: CGRect(x: image.size.width / 2 - image.size.height / 2, y: 0, width: image.size.height, height: image.size.height))
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: resizedImage)
                    
                    self.playerItem.airPlayCenter.nowPlayingInfo = nowPlayingInfo
                case .failure(_):
                    self.playerItem.airPlayCenter.nowPlayingInfo = nowPlayingInfo
                }
            }
        } else {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage())
            
            self.playerItem.airPlayCenter.nowPlayingInfo = nowPlayingInfo
        }

        
    }
    
    func remoteCommandTimeInfo(convertTime: Float) {
        var nowPlayingInfo = playerItem.airPlayCenter.nowPlayingInfo ?? [String: Any]()

        // 콘텐츠 총 길이
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.player?.currentItem?.duration.seconds ?? 0.0
        // 콘텐츠 재생 시간에 따른 progressBar 초기화
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerItem.player?.rate
        // 콘텐츠 현재 재생시간
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = convertTime

        playerItem.airPlayCenter.nowPlayingInfo = nowPlayingInfo
    }
}

//MARK: - Player Extension

extension PlayerViewController: PlayerViewDelegate {

    func updateTime(time: CMTime) {
        
        let currentTime = playerItem.player?.currentItem?.currentTime().seconds ?? 0.0
        playerView.currentTimeLabel.text = currentTime.secondsToString()
        
        if currentTime == playerItem.player?.currentItem?.duration.seconds ?? 0.0 {
            if CacheManager.getAutoPlay() == AutoPlay.on.rawValue {
                setNextAudio()
            } else {
                playerItem.player?.seek(to: .zero)
                setPlayButton(active: false)
                setPlayer()
                
                // 플레이어 자동재생 로그 전송
                LogManager.sendLogData(screen: .player, action: .autoClick, params: ["type": "pause", "id": self.news.id ?? 0, "cur_time": currentTime, "max_time": currentTime])
            }
        }
        
        let playingTime = time.value / 1000000000
        let convertTime = Float(playingTime)

        
        remoteCommandTimeInfo(convertTime: convertTime)
    }

    func didTapPlay() {
        if APIManager.isUser() {
            setPlayPause()
        } else {
            loginView.isHidden = false
        }
    }

    func didTapForward() {
        setNextAudio()
    }
        
    func didTapBackward() {
        setPreviousAudio()
    }
}

//MARK: - Login Delegate

extension PlayerViewController: LoginViewDelegate {
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

extension PlayerViewController: ErrorViewDelegate {
    func didTapRetry() {
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if self.playerType == .live {
                self.loadLiveData(newsId: self.newsId)
            } else {
                if self.moreType {
                    self.loadNewsListData(newsId: self.newsId)
                } else {
                    self.loadNewsData(newsId: self.newsId)
                }
            }
        }
    }
}

//MARK: - Gesture Delegate

extension PlayerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
