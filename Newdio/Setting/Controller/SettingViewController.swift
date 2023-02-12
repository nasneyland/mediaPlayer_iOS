//
//  SettingViewController.swift
//  Newdio
//
//  Created by sg on 2021/11/24.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var settingTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .none
        table.rowHeight = UITableView.automaticDimension
        table.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.identifier)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.contentInsetAdjustmentBehavior = .always
        return table
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        configureNav()
        settingTableView.reloadData()
    }
    
    //MARK: - Configure
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goDetail(_:)),
                                               name: NotificationManager.Setting.detail,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(goLogin),
                                               name: NotificationManager.Setting.login,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goStorage),
                                               name: NotificationManager.Setting.storage,
                                               object: nil)
    }
    
    private func configureNav() {
        setLargeNav(title: "menu_settings".localized())
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_setting_ticket"),
//                                                            style: .plain,
//                                                            target: self,
//                                                            action: #selector(buy))
//
//        if let lang = CacheManager.getLanguage() {
//            if lang == Language.ko.rawValue {
//                navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_setting_ticket_kor")
//            } else {
//                navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_setting_ticket_eng")
//            }
//        } else {
//            if Locale.current.languageCode == Language.ko.rawValue {
//                navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_setting_ticket_kor")
//            } else  {
//                navigationItem.rightBarButtonItem?.image = UIImage(named: "ic_setting_ticket_eng")
//            }
//        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .newdioBlack
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    @objc func goLogin() {
        NotificationCenter.default.post(name: NotificationManager.Main.login, object: nil)
    }
    
    @objc func goStorage() {
        let vc = StorageViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @objc func goDetail(_ notification:NSNotification) {
        let name = notification.userInfo!["name"] as! String
        let url = notification.userInfo!["url"] as! Link

        if url != .none {
            // 해당 url로 이동
            url.localizedLink().openURL()
            
            // URL 이동 로그 전송
            if name == "settings_notice".localized() {
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "notice", "language": CacheManager.getLanguage() ?? ""])
            } else if name == "settings_faq".localized() {
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "faq", "language": CacheManager.getLanguage() ?? ""])
            } else if name == "settings_tc_service".localized() {
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "service", "language": CacheManager.getLanguage() ?? ""])
            } else if name == "settings_tc_privacy".localized() {
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "privacy", "language": CacheManager.getLanguage() ?? ""])
            } else if name == "settings_tc_payment".localized() {
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "subscriptions", "language": CacheManager.getLanguage() ?? ""])
            } else if name == "settings_evaluation".localized() {
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "feedback", "language": CacheManager.getVersion()])
            }
        } else {
            if name == "settings_version_info".localized() {
                //버전 정보
                let vc = VersionViewController()
                vc.titleName = name
                self.navigationController?.pushViewController(vc, animated: false)
                
                //버전 정보 로그 전송
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "version", "version": CacheManager.getVersion()])
            } else if name == "settings_share".localized() {
                //앱 공유하기
//                shareAppInfo()
                
                //앱 공유하기 로그 전송
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "share", "language": CacheManager.getLanguage() ?? "", "version": CacheManager.getVersion()])
            } else if name == "settings_bug".localized() {
                //버그 또는 문의
//                sendEmailTapped()
                
                //버그 또는 문의 로그 전송
                LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "bug", "version": CacheManager.getVersion()])
            } else if name == "settings_text".localized() {
                //텍스트 크기
                let vc = TextViewController()
                vc.titleName = name
                self.navigationController?.pushViewController(vc, animated: false)
            } else if name == "settings_auto_play".localized() {
                //자동 재생 모드
                let vc = AutoPlayViewController()
                vc.titleName = name
                self.navigationController?.pushViewController(vc, animated: false)
            } else if name == "settings_language".localized() {
                //언어설정
                let vc = LanguageViewController()
                vc.titleName = name
                self.navigationController?.pushViewController(vc, animated: false)
            } else if name == "settings_logout".localized() {
                //로그아웃
                logout()
            } else if name == "settings_secession".localized() {
                //탈퇴
                let vc = SecessionViewController()
                vc.titleName = name
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    /// 내장 공유하기 기능 구현
    private func shareAppInfo() {
        let textToShare = [ "appname".localized() + " - " + "app_slogan".localized() + "\n\(SITE_URL)" ]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view // 아이패드에서도 동작하도록 팝오버로 설정
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        activityVC.excludedActivityTypes = [ .airDrop ] //airDrop 제외
        self.present(activityVC, animated: true, completion: nil)
    }
    
    /// 로그아웃 기능 구현
    private func logout() {
        let alert =  UIAlertController(title: "popup_notification".localized(), message: "popup_logout".localized(), style:  UIAlertController.Style.alert)
        alert.view.tintColor = .newdioWhite
        
        let yes = UIAlertAction(title: "popup_confirm".localized(), style: .default, handler: { (action) in
            APIManager.deleteAllToken()
            NotificationCenter.default.post(name: NotificationManager.Main.home, object: nil)
            
            //로그아웃 로그 전송
            LogManager.sendLogData(screen: .setting, action: .click, params: ["type": "logout"])
        })
        let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
        
        yes.setValue(UIColor.newdioMain, forKey: "titleTextColor")
        
        alert.addAction(yes)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Table Delegate, DataSource

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if APIManager.isUser() {
            return 5
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = settingTableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier, for: indexPath) as! UserInfoTableViewCell
            
            // 셀 새로고침
            cell.refreshUserInfo()
            
            return cell
        } else {
            let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
            
            // 설정 분류 셋팅
            if indexPath.row == 1 {
                cell.setDetailCell(type: .useEnv)
            } else if indexPath.row == 2 {
                cell.setDetailCell(type: .appInfo)
            } else if indexPath.row == 3 {
                cell.setDetailCell(type: .agreement)
            } else if indexPath.row == 4 {
                cell.setDetailCell(type: .userManagement)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130
        case 1:
            return 250
        case 2:
            return 380
        case 3:
            return 250
        case 4:
            return 200
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: - Mail Delegate

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmailTapped() {
        
        //기기 정보 셋팅
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        //버전 정보 셋팅
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return }
    
        if MFMailComposeViewController.canSendMail() {

            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self

            compseVC.setSubject("[\("appname".localized())] \("settings_bug".localized())")
            compseVC.setToRecipients([MAIN_EMAIL])
            compseVC.setMessageBody("<br/><br/><br/>\("settings_phone_info".localized()) : \(identifier)<br/>\("settings_os_version".localized()) : \(UIDevice.current.systemVersion)<br/>\("settings_app_version".localized()) : \(version)", isHTML: true)

            self.present(compseVC, animated: true, completion: nil)

        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    // 메일 전송 성공시
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // 메일 전송 실패시
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController.init(title: "popup_send_mail_error".localized(),
                                                        message: "popup_send_mail_error_info".localized(),
                                                        style: .alert)
        sendMailErrorAlert.addAction(UIAlertAction.init(title: "popup_confirm".localized(), style: .default, handler: nil))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}
