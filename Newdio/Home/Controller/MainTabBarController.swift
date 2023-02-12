//
//  MainTabBarController.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit
import SnapKit
import AVFoundation

class MainTabBarController: UITabBarController {

    // MARK: - Properties
    
    static var shared = MainTabBarController()
    
    var playerItem = PlayerPresenter.shared
    var playMode = false
    var selectViewName = "appname".localized()
    var menu: ScreenLog = .newdio
    
    private let playerView = PlayerBarView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configurePlayerView()
    }
    
    static func reset() {
        shared = MainTabBarController()
        
        PlayerPresenter.reset()
    }
    
    // MARK: - Configure UI

    private func configureVC() {
        let homeVC = templateNavigationViewController(HomeViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_home_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_home_on"), title: "appname".localized())
        let liveVC = templateNavigationViewController(LiveViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_live_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_live_on"), title: "menu_live".localized())
        let discoverVC = templateNavigationViewController(DiscoverViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_discover_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_discover_on"),  title: "menu_discover".localized())
        let searchVC = templateNavigationViewController(SearchViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_search_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_search_on"),  title: "menu_search".localized())
        let settingVC = templateNavigationViewController(SettingViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_setting_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_setting_on"),  title: "menu_settings".localized())
        
        self.tabBar.tintColor = .newdioWhite
        self.viewControllers = [homeVC, liveVC, discoverVC, searchVC, settingVC]
    }
    
    private func configurePlayerView() {
        playerView.delegate = self
        playerView.isHidden = true
        
        playerView.layer.cornerRadius = 20
        playerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        //플레이어 바 탭 이벤트
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPlayerBar))
        playerView.addGestureRecognizer(tapGesture)
        
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.bottom.equalTo(tabBar.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(56)
        }
    }

    // MARK: - Helpers

    private func templateNavigationViewController(_ viewController: UIViewController, unselectedImage: UIImage, selectedImage: UIImage, title: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        
        //탭바 구성
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        
        //네비게이션 구성
        nav.navigationBar.shadowImage = UIImage()
        nav.view.backgroundColor = UIColor.newdioBlack
        nav.navigationBar.isTranslucent = true
        
        return nav
    }
    
    /// 플레이어 바 셋팅
    func setPlayerBar(news: News) {
        
        //플레이 모드로 변경하는 경우
        if self.playMode == false {
            self.playMode.toggle()
            self.playerView.isHidden = false
            
            //AirPlayMode 시작
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
        
        //플레이어 바 이미지 셋팅
        let url = URL(string: news.imageURL ?? "")
        self.playerView.newsImageView.kf.setImage(with: url)
        
        //플레이어 바 내용 셋팅
        playerView.titleLabel.text = news.title
        playerView.siteLabel.text = news.site
        
        //플레이어 바 재생,중지 버튼 셋팅
        if let player = playerItem.player {
            if ((player.rate != 0) && (player.error == nil)) {
                playerView.playButton.setImage(#imageLiteral(resourceName: "ic_general_stop_white"), for: .normal)
            } else {
                playerView.playButton.setImage(#imageLiteral(resourceName: "ic_general_play"), for: .normal)
            }
        }
    }
    
    //플레이어 바 클릭시 플레이어 뷰 present
    @objc func tapPlayerBar() {
        PlayerPresenter.openPlayer()
    }
}

//MARK: - Audio Extension

extension MainTabBarController: PlayerBarViewDelegate {
    
    //플레이어 재생,정지 버튼 클릭
    func didTapPlay() {
        if let player = playerItem.player {
            
            let currentTime = Int(player.currentItem?.currentTime().seconds ?? 0.0)
            let totalTime = Int(player.currentItem?.asset.duration.seconds ?? 0.0)
            let newsId = playerItem.trackList[playerItem.currentTrack].id ?? 0
            
            if ((player.rate != 0) && (player.error == nil)) {
                playerView.playButton.setImage(#imageLiteral(resourceName: "ic_general_play"), for: .normal)
                player.pause()
                
                // 플레이어 일시정지 로그 전송
                LogManager.sendLogData(screen: .player, action: .click, params: ["type": "pause", "id": newsId, "cur_time": currentTime, "max_time": totalTime])
            } else {
                playerView.playButton.setImage(#imageLiteral(resourceName: "ic_general_stop_white"), for: .normal)
                player.play()
                
                // 플레이어 재생 로그 전송
                LogManager.sendLogData(screen: .player, action: .click, params: ["type": "play", "id": newsId, "cur_time": currentTime, "max_time": totalTime])
            }
        }
    }
    
    //플레이어 리스트 버튼 클릭
    func didTapList() {
        PlayerPresenter.openPlayList()
    }
    
    //플레이어 취소 버튼 클릭
    func didTapCancel() {
        if let player = playerItem.player {
            //플레이 중지
            player.pause()
        }
        
        playMode = false
        playerView.isHidden = true
        
        //AirPlayMode 중지
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        // 플레이어 종료 로그 전송
        LogManager.sendLogData(screen: .player, action: .end, params: ["type": "player", "id": playerItem.trackList[playerItem.currentTrack].id ?? 0])
    }
}

//MARK: - TabBar Extension

extension MainTabBarController: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var screen: ScreenLog = .null
        
        //로그 전송용 screen 설정
        switch selectViewName {
        case "appname".localized():
            screen = .newdio
        case "menu_live".localized():
            screen = .live
        case "menu_discover".localized():
            screen = .discover
        case "menu_search".localized():
            screen = .search
        case "menu_settings".localized():
            screen = .setting
        default:
            screen = .null
        }
        
        //로그 전송용 menu 설정
        switch item.title! {
        case "appname".localized():
            menu = .newdio
        case "menu_live".localized():
            menu = .live
        case "menu_discover".localized():
            menu = .discover
        case "menu_search".localized():
            menu = .search
        case "menu_settings".localized():
            menu = .setting
        default:
            menu = .null
        }
        
        if selectViewName == item.title! {
            //현재 있는 위치와 이동할 위치가 같을 경우 - 스크롤 탑으로
            if selectViewName == "appname".localized() {
                NotificationCenter.default.post(name: NotificationManager.Main.newdio,object: nil)
            } else if selectViewName == "menu_live".localized() {
                NotificationCenter.default.post(name: NotificationManager.Main.live,object: nil)
            } else if selectViewName == "menu_discover".localized() {
                NotificationCenter.default.post(name: NotificationManager.Main.discover,object: nil)
            }
        } else {
            //현재 있는 위치와 이동할 위치가 같을 경우 - 메뉴 클릭 로그 전송
            LogManager.sendLogData(screen: screen, action: .click, params: ["type": "menu", "id": "\(menu)"])
        }
        
        selectViewName = item.title!
    }
}
