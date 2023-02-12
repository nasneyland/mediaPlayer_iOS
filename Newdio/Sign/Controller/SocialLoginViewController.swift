//
//  SocialLoginViewController.swift
//  Newdio
//
//  Created by 박지영 on 2021/10/27.
//

import UIKit
import SnapKit
import Alamofire
//import KakaoSDKCommon
//import KakaoSDKAuth
//import KakaoSDKUser
import AuthenticationServices
import NaverThirdPartyLogin
import Firebase
import GoogleSignIn
import SwiftJWT
import Security


class SocialLoginViewController: UIViewController {

    static let shared = SocialLoginViewController()
    
    private let logo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "img_general_newdio_big")
        image.contentMode = .scaleAspectFit
        return image
    }()

    // 로그인 버튼
    /// 구글 버튼
    private let googleBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "img_general_google"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 303)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("Google로 계속하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }()
    
    ///카카오 버튼
    private let kakaoBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "img_general_kakao"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 303)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.frame = CGRect(x: 8, y: 8, width: 32, height: 32)
        button.setTitle("카카오로 계속하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)

        button.backgroundColor = UIColor(hex:"#F8E318")
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }()

    
    ///네이버 버튼
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    ///네이버 로그인 용

    private let naverBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "img_general_naver"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 303)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.frame = CGRect(x: 8, y: 8, width: 32, height: 32)
        button.setTitle("네이버로 계속하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
 
        button.backgroundColor = UIColor(hex: "#03C75A")
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }()
    
    ///애플 버튼
    func appleCustomLoginButton() {
        if #available(iOS 13.0, *) { //13미만일 경우 따로 처리 필요할 듯
            let customAppleLoginBtn = UIButton()
            customAppleLoginBtn.layer.cornerRadius = 3.0
            customAppleLoginBtn.backgroundColor = UIColor.white
            customAppleLoginBtn.setTitle("Apple로 계속하기", for: .normal)
            customAppleLoginBtn.setTitleColor(UIColor.black, for: .normal)
            customAppleLoginBtn.contentMode = .scaleAspectFit
            customAppleLoginBtn.frame = CGRect(x: 4, y: 4, width: 32, height: 32)
            customAppleLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            customAppleLoginBtn.setImage(UIImage(named: "img_general_apple"), for: .normal)
            customAppleLoginBtn.imageView?.contentMode = .scaleAspectFill
            customAppleLoginBtn.imageEdgeInsets = UIEdgeInsets.init(top: 15, left: 8, bottom: 15, right: 306)
            customAppleLoginBtn.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.view.addSubview(customAppleLoginBtn)

            // Setup Layout Constraints to be in the center of the screen(위치조정)
            customAppleLoginBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(18)
                make.right.equalToSuperview().offset(-18)
                make.top.equalTo(naverBtn.snp.bottom).offset(8)
                make.height.equalTo(48)
            }
        }
    }

    func getCredentialState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "USER_ID") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // Credential is valid
                // Continiue to show 'User's Profile' Screen
                
                break
            case .revoked:
                // Credential is revoked.
                // Show 'Sign In' Screen
                break
            case .notFound:
                // Credential not found.
                // Show 'Sign In' Screen
                break
            default:
                break
            }
        }
    }

    //이용약관 1째줄
    private let agreeLabelOne: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "social_login_agree_agreement".localized()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    //이용약관 2째줄
    private let agreeLabelTwo: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "social_login_agreement".localized()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubViews()
        appleCustomLoginButton()
        addButtonAction()
    }

   //크기 조절
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logo.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(128)
            make.right.equalToSuperview().offset(-127)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(164)
            make.height.equalTo(120)
        }

        googleBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(logo.snp.bottom).offset(144)
            make.height.equalTo(48)
        }

        kakaoBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(googleBtn.snp.bottom).offset(8)
            make.height.equalTo(48)
        }

        naverBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(kakaoBtn.snp.bottom).offset(8)
            make.height.equalTo(48)
        }

        agreeLabelOne.snp.makeConstraints { make in
            make.top.equalTo(naverBtn.snp.bottom).offset(88)
            make.left.equalToSuperview().offset(72)
            make.right.equalToSuperview().offset(-71)
        }

        agreeLabelTwo.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(72)
            make.right.equalToSuperview().offset(-71)
            make.top.equalTo(agreeLabelOne.snp.bottom)
        }
    }

    //화면에 subview를 붙입니다
    private func addSubViews() {
        view.addSubview(logo)
        view.addSubview(kakaoBtn)
        view.addSubview(naverBtn)
        view.addSubview(googleBtn)
        view.addSubview(agreeLabelOne)
        view.addSubview(agreeLabelTwo)
     }

    //버튼 이벤트
    private func addButtonAction() {
        kakaoBtn.addTarget(self, action: #selector(didTapKakao), for: .touchUpInside)
        naverBtn.addTarget(self, action: #selector(didTapNaver), for: .touchUpInside)
        googleBtn.addTarget(self, action: #selector(didTapGoogle), for: .touchUpInside)
    }


    // MARK: -GoogleLogin
    @objc func didTapGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
         let signInConfig = GIDConfiguration.init(clientID: clientID)

       GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
         guard error == nil else { return }

         guard let authentication = user?.authentication else { return }
         let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)

         // 인증정보 등록
         Auth.auth().signIn(with: credential) {result, error in
             self.loadSocialData(url: SocialAPI.googleURL)
             
             }
             self.loadSocialData(url: SocialAPI.kakaoURL)
             self.moveVC()
         }
       
    }
    
    
    // MARK: -KakaoLogin
    @objc func didTapKakao() {
//        // 카카오톡 설치 여부 확인
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoTalk() success.")
//
//                    //do something
//                    _ = oauthToken
//                    self.loadSocialData(url: SocialAPI.kakaoURL)
//                    self.moveVC()
//
//                    //소셜 토큰 해제
//                    UserApi.shared.unlink {(error) in
//                        if let error = error {
//                            print(error)
//                        }
//                        else {
//                            print("unlink() success.")
//                        }
//                    }
//
//                    }
//            }
//        }
    }
    
    
    // MARK: -NaverLogin
    @objc func didTapNaver() {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    private func getNaverInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }

        if !isValidAccessToken {
          return
        }

        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        //print(accessToken)
        let authorization = "\(tokenType) \(accessToken)"
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])

        req.responseJSON { response in
          guard let result = response.value as? [String: Any] else { return }
          guard let object = result["response"] as? [String: Any] else { return }
          print(result)
//          guard let name = object["name"] as? String else { return }
//          guard let email = object["email"] as? String else { return }
//          guard let nickname = object["nickname"] as? String else { return }
        }
      }
    
    // MARK: -AppleLogin
    @objc func actionHandleAppleSignin() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    //MARK: - API(앱 자체 토큰 처리)
    private func loadSocialData(url: String) {
        SocialAPI.socialAPI(url: url, parameters: SocialAPI.param) {
            // 에러 처리
            fatalError()
        } completion: { socialVO in
            
            // 성공 시
            print("성공 시 : \(socialVO)")
        }
    }
    
    //MARK: - 다음 화면으로 이동(생년월일)
    private func moveVC() {
        let vc = UINavigationController(rootViewController: BirthViewController())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// 네이버 로그인에 필요한 함수
extension SocialLoginViewController: NaverThirdPartyLoginConnectionDelegate {
  // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
  func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
  }

  // 로그인에 성공했을 경우 호출
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
    getNaverInfo()
    self.loadSocialData(url: SocialAPI.kakaoURL)
    oauth20ConnectionDidFinishDeleteToken() //네이버 토큰 삭제
    moveVC()
  }

  // 접근 토큰 갱신
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
  }

  // 로그아웃 할 경우 호출(토큰 삭제)
  func oauth20ConnectionDidFinishDeleteToken() {
    loginInstance?.requestDeleteToken()
  }

  // 모든 Error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
     print("[Error] :", error.localizedDescription)
  }
}

//애플 로그인 관련 내용
extension SocialLoginViewController: ASAuthorizationControllerDelegate {

    // Authorization Failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }


    // Authorization Succeeded
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            let identityToken = appleIDCredential.identityToken

            let enidentityToken = String(data: appleIDCredential.identityToken!, encoding: .ascii) ?? ""
            let enauth = String(data: appleIDCredential.authorizationCode!, encoding: .ascii) ?? ""
        
            self.loadSocialData(url: SocialAPI.appleURL)
            self.moveVC()

        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Get user data using an existing iCloud Keychain credential
            // Write your code
    
        }
    }
}

extension SocialLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

}


