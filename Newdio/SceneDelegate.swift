//
//  SceneDelegate.swift
//  Newdio
//
//  Created by najin on 2021/09/30.
//

import UIKit
////카카오 로그인
//import KakaoSDKAuth
////네이버 로그인
//import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // 애플리케이션이 실행된 직후 사용자의 화면에 보여지기 전에 호출
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        configureRootVC()
        configureNotification()
    }
    
    // 애플리케이션이 활성화 된 직후 사용자의 화면에 보여질 때 호출
    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.post(name: NotificationManager.Player.refresh, object: nil)
        
        // 앱 포그라운드 로그 전송
        LogManager.sendLogData(screen: MainTabBarController.shared.menu, action: .foreground, params: ["type": "launch", "language": CacheManager.getLanguage() ?? ""])
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // 앱 백그라운드 로그 전송
        LogManager.sendLogData(screen: MainTabBarController.shared.menu, action: .background, params: nil)
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
        // 플레이어 종료 로그 전송
        let playerItem = PlayerPresenter.shared
        if playerItem.player != nil {
            LogManager.sendLogData(screen: .player, action: .end, params: ["type": "player", "id": playerItem.trackList[playerItem.currentTrack].id ?? 0])
        }
        
        // 앱 종료 로그 전송
        LogManager.sendLogData(screen: MainTabBarController.shared.menu, action: .kill, params: nil)
        
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
//        //카카오 로그인 핸들러
//        if let url = URLContexts.first?.url {
//            if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                _ = AuthController.handleOpenUrl(url: url)
//            }
//        }
//
//        //네이버 로그인 핸들러
//        NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(URLContexts.first?.url)
    }
}

//MARK: - Configure

extension SceneDelegate {
    
    /// root VC 셋팅
    private func configureRootVC() {
        let mainViewController = MainTabBarController.shared
        self.window?.rootViewController  = mainViewController
        self.window?.makeKeyAndVisible()
    }
    
    /// notification 셋팅
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(main), name: NotificationManager.Main.main, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(home), name: NotificationManager.Main.home, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NotificationManager.Main.login, object: nil)
    }
}

//MARK: - Helpers

extension SceneDelegate {
    
    @objc func home(notification: Notification) {
        MainTabBarController.reset()
        configureRootVC()
    }
    
    @objc func main(notification: Notification) {
        configureRootVC()
    }
    
    @objc func login(notification: Notification) {
        let loginViewController = FavoriteViewController()
        
        let navController = UINavigationController(rootViewController: loginViewController)
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.shadowImage = UIImage()
        navController.view.backgroundColor = UIColor.newdioBlack
        navController.navigationBar.tintColor = .newdioWhite
        
        self.window?.rootViewController  = navController
        self.window?.makeKeyAndVisible()
    }
}
