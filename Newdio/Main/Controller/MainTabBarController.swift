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
    
    private var newsId = 0
    private let playerView = PlayerBarView()
    
    var selectViewName = "appname".localized()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configurePlayerView()
    }
    
    static func reset() {
        shared = MainTabBarController()
    }
    
    // MARK: - Configure UI

    private func configureVC() {
        let homeVC = templateNavigationViewController(HomeViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_home_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_home_on"), title: "appname".localized())
        let liveVC = templateNavigationViewController(LiveViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_live_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_live_on"), title: "menu_live".localized())
        let discoverVC = templateNavigationViewController(DiscoverViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_discover_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_discover_on"),  title: "menu_discover".localized())
        let searchVC = templateNavigationViewController(SearchViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_search_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_search_on"),  title: "menu_search".localized())
        let settingVC = templateNavigationViewController(SettingViewController(), unselectedImage: #imageLiteral(resourceName: "ic_bar_setting_off"), selectedImage: #imageLiteral(resourceName: "ic_bar_setting_on"),  title: "menu_settings".localized())
        
        self.tabBar.tintColor = .white
        self.viewControllers = [homeVC, liveVC, discoverVC, searchVC, settingVC]
    }
    
    private func configurePlayerView() {
        
        playerView.layer.cornerRadius = 20
        playerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPlayerBar))
        playerView.addGestureRecognizer(tapGesture)
        
//        view.addSubview(playerView)
//        playerView.snp.makeConstraints { make in
//            make.bottom.equalTo(tabBar.snp.top)
//            make.left.right.equalTo(view)
//            make.height.equalTo(56)
//        }
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
        nav.view.backgroundColor = UIColor.black
        nav.navigationBar.isTranslucent = true
        
        return nav
    }
    
    func setPlayerBar(newsId: Int, image: String, title: String, site: String) {
        self.newsId = newsId
        
        let url = URL(string: image)
        self.playerView.newsImageView.kf.setImage(with: url)
        
        playerView.titleLabel.text = title
        playerView.siteLabel.text = site
    }
    
    @objc func tapPlayerBar() {
        if newsId != 0 {
            PlayerPresenter.newsPlayer(newsId: newsId)
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        var screen: ScreenLog = .null
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
            screen = .settings
        default:
            screen = .null
        }
        
        var menu: ScreenLog = .null
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
            menu = .settings
        default:
            menu = .null
        }
        
        if selectViewName == item.title! {
            if selectViewName == "appname".localized() {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Newdio"),object: nil)
            } else if selectViewName == "menu_live".localized() {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Live"),object: nil)
            } else if selectViewName == "menu_discover".localized() {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Discover"),object: nil)
            }
        } else {
            LogManager.sendLogData(screen: screen, action: .click, params: ["type": "menu", "id": "\(menu)"])
        }
        
        selectViewName = item.title!
    }
}

