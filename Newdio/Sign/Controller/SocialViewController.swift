//
//  SocialViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/08.
//

import UIKit
////구글로그인
//import Firebase
//import GoogleSignIn
////카카오로그인
//import KakaoSDKCommon
//import KakaoSDKAuth
//import KakaoSDKUser
////네이버로그인
//import NaverThirdPartyLogin
////애플로그인
//import AuthenticationServices

class SocialViewController: UIViewController {

    //MARK: - Properties
    
//    private let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    private let tapLabelGestureRecognizer = UITapGestureRecognizer()
    
    private let logo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ic_icon")
        image.contentMode = .scaleAspectFill
        image.tintColor = .newdioMain
        return image
    }()
    
    private let googleButton: UIButton = {
        let button = SocialButton(frame: .zero, type: .google, backgroundColor: .google, titleColor: .newdioBlack)
        button.addTarget(self, action: #selector(didTapGoogle), for: .touchUpInside)
        return button
    }()
    
    private let kakaoButton: UIButton = {
        let button = SocialButton(frame: .zero, type: .kakao, backgroundColor: .kakao, titleColor: .newdioBlack)
        button.addTarget(self, action: #selector(didTapKakao), for: .touchUpInside)
        return button
    }()

    private let naverButton: UIButton = {
        let button = SocialButton(frame: .zero, type: .naver, backgroundColor: .naver, titleColor: .newdioWhite)
        button.addTarget(self, action: #selector(didTapNaver), for: .touchUpInside)
        return button
    }()
    
    private let appleButton: UIButton = {
        let button = SocialButton(frame: .zero, type: .apple, backgroundColor: .apple, titleColor: .newdioBlack)
        button.addTarget(self, action: #selector(didTapApple), for: .touchUpInside)
        return button
    }()
    
    private let agreeLabel1: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "social_login_agree_agreement".localized()
        label.textAlignment = .center
        label.textColor = .newdioWhite
        return label
    }()
        
    private let agreeLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "\("settings_terms_conditions".localized()) \("common_and".localized()) \("settings_personal_policy".localized())"
        label.textColor = .newdioWhite
        label.textAlignment = .center
        
        // 링크 단어 밑줄 처리
        let underlineAttriString = NSMutableAttributedString(string: label.text!)
        let range1 = (label.text! as NSString).range(of: "settings_terms_conditions".localized())
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        let range2 = (label.text! as NSString).range(of: "settings_personal_policy".localized())
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        
        label.attributedText = underlineAttriString
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultNav(title: "")
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        // 링크 라벨 탭 제스쳐 연결
        agreeLabel2.addGestureRecognizer(tapLabelGestureRecognizer)
        tapLabelGestureRecognizer.addTarget(self, action: #selector(didTapLinkLabel))
        
        view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.left.equalToSuperview().offset(140).priority(.low)
            make.right.equalToSuperview().offset(-140).priority(.low)
            make.width.lessThanOrEqualTo(200).priority(.high)
            make.height.equalTo(logo.snp.width)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(agreeLabel2)
        agreeLabel2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        view.addSubview(agreeLabel1)
        agreeLabel1.snp.makeConstraints { make in
            make.bottom.equalTo(agreeLabel2.snp.top).offset(-5)
            make.left.equalToSuperview().offset(72)
            make.right.equalToSuperview().offset(-71)
        }
        
        view.addSubview(appleButton)
        appleButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalTo(agreeLabel1.snp.top).offset(-30)
            make.height.equalTo(48)
        }
        
        if Locale.current.regionCode == Region.ko.rawValue {
            //한국인 경우만 네이버, 카카오 로그인 추가
            
            view.addSubview(naverButton)
            naverButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(18)
                make.right.equalToSuperview().offset(-18)
                make.bottom.equalTo(appleButton.snp.top).offset(-8)
                make.height.equalTo(48)
            }
            
            view.addSubview(kakaoButton)
            kakaoButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(18)
                make.right.equalToSuperview().offset(-18)
                make.bottom.equalTo(naverButton.snp.top).offset(-8)
                make.height.equalTo(48)
            }

            view.addSubview(googleButton)
            googleButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(18)
                make.right.equalToSuperview().offset(-18)
                make.bottom.equalTo(kakaoButton.snp.top).offset(-8)
                make.height.equalTo(48)
            }
        } else {
            view.addSubview(googleButton)
            googleButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(18)
                make.right.equalToSuperview().offset(-18)
                make.bottom.equalTo(appleButton.snp.top).offset(-8)
                make.height.equalTo(48)
            }
        }
    }
    
    //MARK: - API
    
    private func requestSocialToken(social: SocialType, token: String) {
        
        LoadingManager.show()
        
        SignAPI.signInAPI(social: social, token: token, error: { (error) in
            LoadingManager.hide()
            
            if error == .userInvalid {
                // 회원가입 처리
                let user = User(accessToken: token, social: social)
                self.signUpVC(user: user)
            } else {
                // error 팝업
                self.present(ErrorManager.errorToAlert(error: error), animated: false)
            }
        }) { () in
            LoadingManager.hide()
            
            // 로그인 처리
            self.signInVC()
        }
    }
    
    //MARK: - Helpers
    
    /// 뒤로가기 시 메인 화면으로 이동
    override func didTapNavBack() {
        NotificationCenter.default.post(name: NotificationManager.Main.main, object: nil)
    }
    
    /// 약관 링크 이동
    @objc func didTapLinkLabel() {
        let text = (agreeLabel2.text)!
        let termsRange = (text as NSString).range(of: "settings_terms_conditions".localized())
        let privacyRange = (text as NSString).range(of: "settings_personal_policy".localized())

        if tapLabelGestureRecognizer.didTapAttributedTextInLabel(label: agreeLabel2, inRange: termsRange) {
            Link.termsofservice.localizedLink().openURL()
        } else if tapLabelGestureRecognizer.didTapAttributedTextInLabel(label: agreeLabel2, inRange: privacyRange) {
            Link.privacypolicy.localizedLink().openURL()
        }
    }
    
    /// 가입 페이지로 이동
    private func signUpVC(user: User) {
        let vc = BirthViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    /// 로그인 후 메인 화면으로 이동
    private func signInVC() {
        NotificationCenter.default.post(name: NotificationManager.Main.home, object: nil)
    }
    
    //MARK: 구글 로그인
    @objc func didTapGoogle() {
        
        // 구글로그인 로그 전송
        LogManager.sendLogData(screen: .sign, action: .click, params: ["type": "login", "social": SocialType.google.rawValue])
        
//        //구글 토큰 초기화
//        GIDSignIn.sharedInstance.signOut()
//
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        let signInConfig = GIDConfiguration.init(clientID: clientID)
//
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
//
//            guard error == nil else { return }
//            guard let user = user else { return }
//
//            user.authentication.do { [self] authentication, error in
//
//                guard error == nil else { return }
//                guard let authentication = authentication else { return }
//
//                let idToken = authentication.idToken
//
//                requestSocialToken(social: .google, token: idToken!)
//            }
//        }
    }
    
    //MARK: 카카오 로그인
    @objc func didTapKakao() {
        
        // 카카오로그인 로그 전송
        LogManager.sendLogData(screen: .sign, action: .click, params: ["type": "login", "social": SocialType.kakao.rawValue])

//        if (AuthApi.hasToken()) {
//            //토큰 초기화
//            UserApi.shared.unlink { (error) in
//                if let _ = error {
//                } else {
//                    self.getKakaoInfo()
//                }
//            }
//        } else {
//            self.getKakaoInfo()
//        }
    }
    
    private func getKakaoInfo() {
//        // 카카오톡 설치 여부 확인
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let _ = error {
//                } else {
//                    let accessToken = oauthToken?.accessToken
//                    self.requestSocialToken(social: .kakao, token: accessToken!)
//                }
//            }
//        } else {
//            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
//               if let _ = error {
//               } else {
//                   let accessToken = oauthToken?.accessToken
//                   self.requestSocialToken(social: .kakao, token: accessToken!)
//               }
//            }
//        }
    }
    
    //MARK: 네이버 로그인
    @objc func didTapNaver() {
        
        // 네이버로그인 로그 전송
        LogManager.sendLogData(screen: .sign, action: .click, params: ["type": "login", "social": SocialType.naver.rawValue])
        
//        naverInstance?.delegate = self
//
//        //토큰 초기화
//        naverInstance?.requestDeleteToken()
//        naverInstance?.requestThirdPartyLogin()
    }

    private func getNaverInfo() {
//        guard let isValidAccessToken = naverInstance?.isValidAccessTokenExpireTimeNow() else { return }
//
//        if !isValidAccessToken { return }
//
//        guard let tokenType = naverInstance?.tokenType else { return }
//        guard let accessToken = naverInstance?.accessToken else { return }
//
//        // 이메일 동의 체크 여부 확인
//        SignAPI.naverLoginAPI(authorization: "\(tokenType) \(accessToken)", error: { (error) in
//            // error 팝업
//            self.present(ErrorManager.errorToAlert(error: error), animated: false)
//        }) { () in
//            // 로그인 처리
//            self.requestSocialToken(social: .naver, token: accessToken)
//        }
    }
    
    //MARK: 애플 로그인
    @objc func didTapApple() {
        
        // 애플로그인 로그 전송
        LogManager.sendLogData(screen: .sign, action: .click, params: ["type": "login", "social": SocialType.apple.rawValue])
        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
    }
}

//MARK: - Extension [네이버로그인]

//extension SocialViewController: NaverThirdPartyLoginConnectionDelegate {
//
//    // 로그인에 성공했을 경우 호출
//    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
//        getNaverInfo()
//    }
//
//    // 접근 토큰 갱신
//    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//    }
//
//    // 로그아웃 할 경우 호출(토큰 삭제)
//    func oauth20ConnectionDidFinishDeleteToken() {
//        naverInstance?.requestDeleteToken()
//    }
//
//    // 모든 Error
//    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
//        print("[Error] :", error.localizedDescription)
//    }
//}

//MARK: - Extension [애플로그인]

//extension SocialViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print(error.localizedDescription)
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//
//            // 애플 토큰 전송
//            let enidentityToken = String(data: appleIDCredential.identityToken!, encoding: .ascii) ?? ""
//            requestSocialToken(social: .apple, token: enidentityToken)
//        }
//    }
//
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//}
