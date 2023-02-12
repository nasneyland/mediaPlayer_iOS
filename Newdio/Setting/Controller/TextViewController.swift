//
//  TextViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/15.
//

import UIKit

class TextViewController: UIViewController {

    //MARK: - Properties
    
    var titleName: String!
    var textType: String?
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .newdioWhite
        label.textAlignment = .center
        label.sizeToFit()
        label.text = "settings_text_prefer".localized()
        return label
    }()
    
    let textSelectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioGray6
        btn.tintColor = .newdioGray1
        btn.setTitle("", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapSelectText), for: .touchUpInside)
        return btn
    }()
    
    let textCheckButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioMain
        btn.tintColor = .newdioWhite
        btn.setTitle("settings_language_button".localized(), for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapCheckText), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureNav() {
        title = self.titleName
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_general_arrowleft"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(back))
    }
    
    private func configureUI() {
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(textSelectButton)
        textSelectButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        view.addSubview(textCheckButton)
        textCheckButton.snp.makeConstraints { make in
            make.top.equalTo(textSelectButton.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        if let text = UserDefaults.standard.string(forKey: "text") {
            self.textSelectButton.setTitle("settings_text_\(text)".localized(), for: .normal)
            self.textType = text
        } else {
            self.textSelectButton.setTitle("settings_text_original".localized(), for: .normal)
            self.textType = TextType.original.rawValue
        }
    }
    
    //MARK: - Helpers
    
    @objc func back() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSelectText() {

        let alert =  UIAlertController(title: "", message: "settings_text_select".localized(), preferredStyle: .actionSheet)
        let small =  UIAlertAction(title: "settings_text_small".localized(), style: .default) { (action) in
            self.textSelectButton.setTitle("settings_text_small".localized(), for: .normal)
            self.textType = TextType.small.rawValue
        }
        let original =  UIAlertAction(title: "settings_text_original".localized(), style: .default) { (action) in
            self.textSelectButton.setTitle("settings_text_original".localized(), for: .normal)
            self.textType = TextType.original.rawValue
        }
        let large =  UIAlertAction(title: "settings_text_large".localized(), style: .default) { (action) in
            self.textSelectButton.setTitle("settings_text_large".localized(), for: .normal)
            self.textType = TextType.large.rawValue
        }
    
        let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
        
        small.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        original.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        large.setValue(UIColor.newdioGray1, forKey: "titleTextColor")
        cancel.setValue(UIColor.newdioGray1, forKey: "titleTextColor")

        alert.addAction(small)
        alert.addAction(original)
        alert.addAction(large)
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
    
    @objc private func didTapCheckText() {
        UserDefaults.standard.set(self.textType, forKey: "text")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Home"), object: nil)
    }
}
