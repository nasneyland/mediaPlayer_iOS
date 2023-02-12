//
//  ReportViewController.swift
//  Newdio
//
//  Created by najin on 2022/01/20.
//

import UIKit

class ReportViewController: UIViewController {

    //MARK: - Properties
    
    var newsId: Int = 0
    var reportType: ReportType!
    
    var backButton: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .top
        button.setImage(UIImage(named: "ic_general_arrowleft"), for: .normal)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .newdioGray2
        label.text = "player_report_do".localized()
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .newdioWhite
        label.textAlignment = .center
        label.sizeToFit()
        label.text = "player_report_reason_select".localized()
        return label
    }()
    
    let typeSelectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioGray4
        btn.tintColor = .newdioGray1
        btn.setTitle("", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapType), for: .touchUpInside)
        return btn
    }()
    
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "player_report_reason_please".localized()
        return label
    }()
    
    private var reportTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .newdioGray4
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return tv
    }()
    
    private var reportButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("player_report".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = .newdioGray6
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(didTapReport), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        reportTextView.delegate = self
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(25)
        }
        
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(typeSelectButton)
        typeSelectButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        view.addSubview(reportTextView)
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(typeSelectButton.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(112)
        }
        
        reportTextView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(reportButton)
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(reportTextView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    //MARK: - API
    
    @objc func setNewsReport() {
        LoadingManager.show()
        
        PlayerAPI.newsReportAPI(id: self.newsId, report: Report(type: self.reportType, content: self.reportTextView.text), error: {(error) in
            LoadingManager.hide()
            
            self.present(ErrorManager.errorToAlert(error: error), animated: false)
        }) { () in
            LoadingManager.hide()
            
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapType() {
        let alert =  UIAlertController(title: "", message: "player_report_reason_select".localized(), preferredStyle: .actionSheet)
        alert.view.tintColor = .newdioWhite
        
        let translate =  UIAlertAction(title: "player_report_translation".localized(), style: .default) { (action) in
            self.typeSelectButton.setTitle("player_report_translation".localized(), for: .normal)
            self.reportType = .translate
            self.enableReport()
        }
        let summary =  UIAlertAction(title: "player_report_summary".localized(), style: .default) { (action) in
            self.typeSelectButton.setTitle("player_report_summary".localized(), for: .normal)
            self.reportType = .summary
            self.enableReport()
        }
        let sound =  UIAlertAction(title: "player_report_sound".localized(), style: .default) { (action) in
            self.typeSelectButton.setTitle("player_report_sound".localized(), for: .normal)
            self.reportType = .sound
            self.enableReport()
        }
        let etc =  UIAlertAction(title: "player_report_etc".localized(), style: .default) { (action) in
            self.typeSelectButton.setTitle("player_report_etc".localized(), for: .normal)
            self.reportType = .etc
            self.enableReport()
        }
    
        let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
        
        alert.addAction(translate)
        alert.addAction(summary)
        alert.addAction(sound)
        alert.addAction(etc)
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
    
    @objc private func didTapReport() {
        self.setNewsReport()
    }
    
    private func enableReport() {
        let currentTextCount = reportTextView.text.count
        
        if currentTextCount == 0 {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
            
            if currentTextCount >= 5 , currentTextCount <= 500, reportType != nil {
                reportButton.isEnabled = true
                reportButton.backgroundColor = .newdioMain
            } else {
                reportButton.isEnabled = false
                reportButton.backgroundColor = .newdioGray6
            }
        }
    }
}

//MARK: - TextField Delegate

extension ReportViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //글자수 만족 유효성검사
        self.enableReport()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        //최대 500자만 입력가능하도록 설정
        return updatedText.count <= 500
    }
}
