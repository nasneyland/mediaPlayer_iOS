//
//  PlayerViewController.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    //MARK: - Properties

//    var timeObserver: Any?
//    var isSeeking: Bool = false
//    var metadataOutput: AVPlayerItemMetadataOutput?
    
    var playerItem = PlayerPresenter.shared
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    var activeTouchPoint = CGPoint(x: 0, y: 0)
    
    var detailType = true
    
    var newsId: Int!
    var news: News!
    
    let playerView = PlayerView()
    private var loginView: LoginView!
    private var errorView: ErrorView!
    private var reportView: ReportView!
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_arrowdown"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    var listButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_list"), for: .normal)
        button.addTarget(self, action: #selector(didTapListButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var heartButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    var moreButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "ic_general_more_vert_white"), for: .normal)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    var originalButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.backgroundColor = .newdioGray4
        button.setTitleColor(UIColor.newdioGray1, for: .normal)
        button.layer.cornerRadius = 22
        button.setImage(UIImage(named: "ic_general_arrowup"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("player_original".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapOriginal), for: .touchUpInside)
        button.marginImageWithText(margin: 10)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(newsId: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.newsId = newsId
        
        configureUI()
        
        loadNewsDetailData(newsId: newsId)
    }
    
    init(news: [NewsThumb]) {
        super.init(nibName: nil, bundle: nil)
        
        self.newsId = news[0].id
        
        configureUI()
        
        self.playerItem.trackList = news
        loadNewsData(newsId: newsId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure

    private func configureUI() {
        view.backgroundColor = .black
        
        playerView.isHidden = true
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
        
        configureLogin()
        configureReport()
        configureGesture()
        
        notification()
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
    
    private func configureReport() {
        reportView = ReportView(frame: .zero)
        
        reportView.isHidden = true
        reportView.delegate = self
        
        view.addSubview(reportView)
        reportView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
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
        self.modalPresentationStyle = .overFullScreen
        
        //뷰에 스와이프 추가
        let viewSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleViewSwipes(_:)))
        playerView.addGestureRecognizer(viewSwipeGestureRecognizer)
        
        //텍스트뷰에 스와이프 추가
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeGestureRecognizer.delegate = self
        playerView.contentTextView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    private func notification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playListSelect(_:)), name: Notification.Name("PlayerListSelect"),object: nil)
    }
    
    //MARK: - API

    //뉴스 상세보기 + 플레이리스트
    private func loadNewsDetailData(newsId: Int) {
        
          PlayerAPI.newsDetailAPI(id: newsId, error: {
              (type) in
              self.detailType = true
              self.configureError(type: type)
          }) { (news) in
              let currentNews = NewsThumb(id: news.id, title: news.title, imageURL: news.imageURL, site: news.site, time: news.time)
              self.playerItem.trackList = news.newsList
              self.playerItem.trackList.insert(currentNews, at: 0)
              
              self.news = news
              self.setPlayerView()
          }
    }
    
    //뉴스 상세보기
    private func loadNewsData(newsId: Int) {
        
          PlayerAPI.newsAPI(id: newsId, error: {
              (type) in
              self.detailType = false
              self.configureError(type: type)
          }) { (news) in
              self.news = news
              self.setPlayerView()
          }
    }
    
    private func setNewsHeart() {
        PlayerAPI.newsHeartAPI(id: self.news.id, error: {(statusCode) in
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
            if result == 1 {
                self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_on"), for: .normal)
            } else {
                self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
            }
        }
    }
    
    private func setNewsReport(type: ReportType, description: String) {
        
        LoadingManager.show()
        
        PlayerAPI.newsReportAPI(id: self.news.id, type: type, description: description, error: {(type) in
            LoadingManager.hide()
            
            if type == .server {
                self.present(serverErrorPopup(), animated: false)
            } else {
                self.present(networkErrorPopup(), animated: false)
            }
        }) { () in
            LoadingManager.hide()
            
            self.reportView.resetData()
            self.reportView.isHidden = true
        }
    }
    
    //MARK: - Selector
    
    // 좋아요 버튼 클릭
    @objc func didTapLikeButton() {
        setNewsHeart()
    }

    // 더보기 버튼 클릭
    @objc func didTapMoreButton() {
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share =  UIAlertAction(title: "player_share".localized(), style: .default) { (action) in
            self.shareNews()
        }
        let report =  UIAlertAction(title: "player_report_do".localized(), style: .default) { (action) in
            self.reportView.isHidden = false

        }
        let link =  UIAlertAction(title: "player_link".localized(), style: .default) { (action) in
            if let webUrl = URL(string: "\(self.news.link ?? "")") {
                UIApplication.shared.open(webUrl, options: [:])
            }
        }

        let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)

        share.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        report.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        link.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        cancel.setValue(UIColor.newdioGray1, forKey: "titleTextColor")

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
    
    //리스트 버튼 클릭
    @objc func didTapListButton() {
        let listVC = PlayListViewController.shared
        listVC.modalPresentationStyle = .overFullScreen
        present(listVC, animated: true, completion: nil)
    }
    
    // 원문 보기 클릭
    @objc func didTapOriginal() {
        let vc = OriginalNewsViewController(title: self.news.originalTitle ?? "", content: self.news.originalContent ?? "")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    //닫기 버튼 클릭
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
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
    
    // 플레이리스트 뉴스 클릭 - notification selector
    @objc func playListSelect(_ notification:NSNotification) {
        self.newsId = playerItem.trackList[playerItem.currentTrack].id
        self.loadNewsData(newsId: newsId)
    }
    
    // 로그인 팝업
    @objc func didTapLoginButton() {
        loginView.isHidden = false
    }
    
    //MARK: - Helpers
    
    // 플레이어 뷰 셋팅
    func setPlayerView() {
        
        LoadingManager.hide()
        CacheManager.setNewsCache(id: self.news.id)
        
        self.originalButton.isHidden = false
        self.listButton.isHidden = false
        self.heartButton.isHidden = false
        self.moreButton.isHidden = false
        self.playerView.isHidden = false
        
        self.playerView.siteLabel.text = self.news.site
        self.playerView.dateLabel.text = self.news.time.toDate()?.utcToLocale()
        self.playerView.titleLabel.text = self.news.title
        self.playerView.contentTextView.text = self.news.longSummary ?? ""
        
        let url = URL(string: self.news.imageURL ?? "")
        self.playerView.newsImageView.kf.setImage(with: url)
        
        //오디오 셋팅
        if let audioUrl = URL(string: news.audioURL) {
            self.playerItem.player = AVPlayer(url: audioUrl)
            //self.playerDidTapPlayPauseButton() // 자동 플레이 방지
        }
        
        //좋아요 셋팅
        if isUser() {
            //회원용 버튼
            self.heartButton.addTarget(self, action: #selector(self.didTapLikeButton), for: .touchUpInside)
            
            if self.news.likeState ?? false {
                self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_on"), for: .normal)
            } else {
                self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
            }
        } else {
            //비회원용 버튼
            self.heartButton.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
            self.heartButton.addTarget(self, action: #selector(self.didTapLoginButton), for: .touchUpInside)
        }
    }
    
    //뉴스 공유하기
    private func shareNews() {
        let textToShare = ["\(news.title ?? "")\n\n\(news.site ?? "") | \(news.time.toDate()?.utcToLocale() ?? "")\n\n\(news.longSummary ?? "")\n\n[\("appname".localized())] \("app_slogan".localized())\nhttps://www.traydcorp.com/newdio"]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view // 아이패드에서도 동작하도록 팝오버로 설정
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        activityVC.excludedActivityTypes = [ .airDrop ] //airDrop 제외
        self.present(activityVC, animated: true, completion: nil)
    }
    
    

//    // AirPlay 세팅
//    func initPlayer() {
//        // Audio Session 설정
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playback, mode: .default, options: [])
//        } catch let error as NSError { print("audioSession 설정 오류 : \(error.localizedDescription)") }
//        // 음악 파일 가져오기
//        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sample")
//        else { print("음악 파일이 없습니다.")
//            return
//        }
//        // audio player를 초기화합니다.
//        do {
//
//        } catch let error as NSError {
//            print("플레이어 초기화 오류 발생 : \(error.localizedDescription)")
//        }
//    }
    
//    func remoteCommandCenterSetting() {
//        // remote control event 받기 시작
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//        let center = MPRemoteCommandCenter.shared()
//       // 제어 센터 재생버튼 누르면 발생할 이벤트를 정의합니다.
//        center.playCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
//            self.playerItem.player?.play()
//            self.playerControlView.playPauseButton.setImage(#imageLiteral(resourceName: "ic_general_stop_black"), for: .normal)
//            return MPRemoteCommandHandlerStatus.success
//
//        }
//       //  제어 센터 pause 버튼 누르면 발생할 이벤트를 정의합니다.
//        center.pauseCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
//            self.playerItem.player?.pause()
//            self.playerControlView.playPauseButton.setImage(#imageLiteral(resourceName: "ic_general_play_black"), for: .normal)
//            return MPRemoteCommandHandlerStatus.success
//        }
//    }
    
//    func remoteCommandInfoCenterSetting(convertTime: Float) {
//        print("[Log_CheckP3]")
//        let center = MPNowPlayingInfoCenter.default()
//        var nowPlayingInfo = center.nowPlayingInfo ?? [String: Any]()
//
//        nowPlayingInfo[MPMediaItemPropertyTitle] = self.newsTitle
//        nowPlayingInfo[MPMediaItemPropertyArtist] = self.newsSite
//        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: imgUrlDown(url: self.newImageUrl))
//
//        // 콘텐츠 총 길이
//        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.player?.currentItem?.duration.seconds ?? 0.0
//        // 콘텐츠 재생 시간에 따른 progressBar 초기화
//        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerItem.player?.rate
//       // 콘텐츠 현재 재생시간
//        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = convertTime
//        center.nowPlayingInfo = nowPlayingInfo
//
//    }
    
//        func playerDidTapPlayPauseButton() {
//            if self.soundItem.isSpeaking {
//                playerView.playPauseButton.setImage(UIImage(named: "ic_player_stop"), for: .normal)
//                self.soundItem.pauseVoice()
//            } else {
//                playerView.playPauseButton.setImage(UIImage(named: "ic_player_play"), for: .normal)
//                self.soundItem.playVoice(text: news.longSummary ?? "")
//
//            //플레이어 바 셋팅
////            MainTabBarController.shared.setPlayerBar(newsId: self.newsId, image: self.newImageUrl, title: self.newsTitle, site: self.newsSite)
//        }
        
        /* [21.11.22] 플레이어 비활성화 */
//        print("[Log_CheckP1]")
//        if let player = playerItem.player {
//            if player.timeControlStatus == .playing {
//                playerControlView.playPauseButton.setImage(#imageLiteral(resourceName: "ic_general_play_black"), for: .normal)
//                player.pause()
//            } else if player.timeControlStatus == .paused {
//                player.play()
//                playerControlView.playPauseButton.setImage(#imageLiteral(resourceName: "ic_general_stop_black"), for: .normal)
//
//                //플레이어 바 셋팅
//                MainTabBarController.shared.setPlayerBar(newsId: self.newsId, image: self.newImageUrl, title: self.newsTitle, site: self.newsSite)
//            }
//        }
//
//        // 재생중인 시간타임
//        timeObserver = playerItem.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) {
//            time in
//            print("[Log_CheckP2]")
//            self.updateTime(time: time)
//        }
//    }

}

//MARK: - Player Extension

extension PlayerViewController: PlayerViewDelegate {
//
//    func updateTime(time: CMTime) {
//
//        let currentTime = playerItem.player?.currentItem?.currentTime().seconds ?? 0.0
//        let totalDurationTime = playerItem.player?.currentItem?.duration.seconds ?? 0.0
//        let playingTime = time.value / 1000000000
//        let convertTime = Float(playingTime)
//
//        // TimeSlider
//        playerControlView.timeSlider.tintColor = .newdioGray1
//
//        let time1 = playerItem.player?.currentItem?.currentTime().seconds ?? 0
//        let time2 = playerItem.player?.currentItem?.duration.seconds ?? 0
//        let sliderTime = time1 / time2
//        playerControlView.timeSlider.value = Float(sliderTime)
//
//        // TimeLabel
//        playerControlView.currentTimeLabel.text = secondsToString(sec: currentTime)
//        playerControlView.totalTimeLabel.text = secondsToString(sec: totalDurationTime)
//
//
//        print("[Log_Time_Tracker]:\(convertTime)")
//
//        initPlayer()
//        remoteCommandCenterSetting()
//        remoteCommandInfoCenterSetting(convertTime: convertTime)
//
//    }

    // 플레이 버튼 클릭
    func playerViewDidTapPlayPauseButton(_ playerControlsView: PlayerView) {
//        if isUser() {
//            print("play")
//        } else {
//            loginView.isHidden = false
//        }
    }

    // 다음 버튼 클릭
    func playerViewDidTapForwardButton(_ playerControlsView: PlayerView) {

        if playerItem.currentTrack + 1 < playerItem.trackList.count {
            playerItem.currentTrack += 1
            
            self.newsId = playerItem.trackList[playerItem.currentTrack].id
            self.loadNewsData(newsId: newsId)
        } else {
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
                
                self.playerItem.currentTrack += 1
                
                self.newsId = self.playerItem.trackList[self.playerItem.currentTrack].id
                self.loadNewsData(newsId: self.newsId)
            }
        }
    }
        
    // 이전 버튼 클릭
    func playerViewDidTapBackwardButton(_ playerControlsView: PlayerView) {

        if playerItem.currentTrack != 0 {
            playerItem.currentTrack -= 1
            
            self.newsId = playerItem.trackList[playerItem.currentTrack].id
            self.loadNewsData(newsId: self.newsId)
        }
        
        /* [21.11.22] 플레이어 비활성화 */

//        if playerItem.currentTrack > 0 {
//            playerItem.currentTrack -= 1
//            newsDetailView.titleLabel.text = self.newsList[playerItem.currentTrack].title
//            newsDetailView.newsImageView.setImageUrl(url: self.newsList[playerItem.currentTrack].imageURL)
//            newsDetailView.siteLabel.text = self.newsList[playerItem.currentTrack].site
//            newsDetailView.dateLabel.text = self.newsList[playerItem.currentTrack].time.setDateString()
//            newsDetailView.contentTextView.text = self.newsList[playerItem.currentTrack].content
//
//            if let audioUrl = URL(string: self.newsList[playerItem.currentTrack].audioURL) {
//                self.playerItem.player = AVPlayer(url: audioUrl)
//                self.playerDidTapPlayPauseButton()
//            }
//        }
    }
        
//        loginPopup()

        /* [21.11.22] 플레이어 비활성화 */

//        print("[List_Count]:\(self.newsList.count)")
//        if playerItem.currentTrack < (self.newsList.count - 1) {
//            playerItem.currentTrack += 1
//         //   print("[List_No]:\(playerItem.currentTrack)")
//            newsDetailView.titleLabel.text = self.newsList[playerItem.currentTrack].title
//            newsDetailView.newsImageView.setImageUrl(url: self.newsList[playerItem.currentTrack].imageURL)
//            newsDetailView.siteLabel.text = self.newsList[playerItem.currentTrack].site
//            newsDetailView.dateLabel.text = self.newsList[playerItem.currentTrack].time.setDateString()
//            newsDetailView.contentTextView.text = self.newsList[playerItem.currentTrack].content
//
//            if let audioUrl = URL(string: self.newsList[playerItem.currentTrack].audioURL) {
//                self.playerItem.player = AVPlayer(url: audioUrl)
//                self.playerDidTapPlayPauseButton()
//            }
//
//        print("[List_Data]:\(self.newsList[playerItem.currentTrack])")
//        }
}

//MARK: - Report Delegate

extension PlayerViewController: ReportViewDelegate {
    func didTapReport(type: ReportType, content: String) {
        setNewsReport(type: type, description: content)
    }
    
    func didTapCancel() {
        reportView.isHidden = true
    }
}

//MARK: - Login Delegate

extension PlayerViewController: LoginViewDelegate {
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

extension PlayerViewController: ErrorViewDelegate {
    func didTapRetryButton() {
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if self.detailType {
                self.loadNewsDetailData(newsId: self.newsId)
            } else {
                self.loadNewsData(newsId: self.newsId)
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
