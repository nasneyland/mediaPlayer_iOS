//
//  AppDelegate.swift
//  Newdio
//
//  Created by najin on 2021/09/30.
//

import UIKit
//AirPlay
import AVFoundation
////구글로그인
//import Firebase
//import GoogleSignIn
////카카오로그인
//import KakaoSDKCommon
//import KakaoSDKAuth
////네이버로그인
//import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 앱을 실행할 때 가장 먼저 호출되는 함수, 이것 다음에 최초 화면을 다루는 ViewController 속 viewDidLoad()가 호출된다.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 런치스크린 유지 시간
        Thread.sleep(forTimeInterval: 2.0)
        
        //앱 접속 로그 전송
        LogManager.sendLogData(screen: .launch, action: .null, params: nil)
        
        configureAirPlay()
        configureTabBar()
//        configureNav()
//        configureSocialLogin()
        
        return true
    }
    
    // 외부에서 앱으로 이동할 때 호출되는 함수
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

//        //구글 로그인 핸들러
//        if !GIDSignIn.sharedInstance.handle(url) { return false }
//
//        //카카오 로그인 핸들러
//        if (AuthApi.isKakaoTalkLoginUrl(url)) { return AuthController.handleOpenUrl(url: url) }
//
//        //네이버 로그인 핸들러
//        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        return true
    }
}

//MARK: - Configure

extension AppDelegate {
    
    /// AirPlay 환경설정
    private func configureAirPlay() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category.")
        }
    }
    
    /// TabBar 환경설정
    private func configureTabBar() {
        if #available(iOS 13.0, *) {
            // 탭바 색상 설정
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .newdioGray4
            UITabBar.appearance().standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                // iOS 버전 15 탭바 대응
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
    
    private func configureNav() {
        UINavigationBar.appearance().barTintColor = .newdioBlack
        UINavigationBar.appearance().tintColor = .newdioWhite
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    /// 소셜로그인 인증정보 셋팅
    private func configureSocialLogin() {
//        //구글로그인
//        FirebaseApp.configure()
//
//        // 카카오로그인
//        KakaoSDK.initSDK(appKey: APIKey.KakaoAPI.appKey)
//
//        //네이버로그인
//        let naver = NaverThirdPartyLoginConnection.getSharedInstance()
//
//        naver?.isNaverAppOauthEnable = true //// 네이버 앱으로 인증
//        naver?.isInAppOauthEnable = true // SafariViewController에서 인증
//        naver?.isOnlyPortraitSupportedInIphone() // 인증 화면을 iPhone의 세로 모드에서만 사용하기
//
//        naver?.serviceUrlScheme = APIKey.NaverAPI.serviceUrlScheme
//        naver?.consumerKey = APIKey.NaverAPI.consumerKey
//        naver?.consumerSecret = APIKey.NaverAPI.consumerSecret
//        naver?.appName = APIKey.NaverAPI.appName
    }
}
