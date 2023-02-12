//
//  ReportView.swift
//  Newdio
//
//  Created by najin on 2022/01/05.
//

import UIKit

protocol ReportViewDelegate: AnyObject {
    func didTapCancel()
    func didTapReport(type: ReportType, content: String)
}

class ReportView: UIView {

    //MARK: - Properties
    
    weak var delegate: ReportViewDelegate?
    
    private var reportType = ReportType.etc
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "player_report_reason".localized()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textColor = .newdioWhite
        return label
    }()
    
    private var translateErrorButton: UIButton = {
        let btn = ReportButton()
        btn.setTitle("player_report_translation".localized(), for: .normal)
        btn.addTarget(self, action: #selector(didTapTranslate), for: .touchUpInside)
        btn.setImage(UIImage(systemName:"circle"), for: .normal)
        btn.tintColor = .newdioGray2
        return btn
    }()
    
    private var summaryErrorButton: UIButton = {
        let btn = ReportButton()
        btn.setTitle("player_report_summary".localized(), for: .normal)
        btn.addTarget(self, action: #selector(didTapSummary), for: .touchUpInside)
        btn.setImage(UIImage(systemName:"circle"), for: .normal)
        btn.tintColor = .newdioGray2
        return btn
    }()
    
    private var soundErrorButton: UIButton = {
        let btn = ReportButton()
        btn.setTitle("player_report_sound".localized(), for: .normal)
        btn.addTarget(self, action: #selector(didTapSound), for: .touchUpInside)
        btn.setImage(UIImage(systemName:"circle"), for: .normal)
        btn.tintColor = .newdioGray2
        return btn
    }()
    
    private var etcErrorButton: UIButton = {
        let btn = ReportButton()
        btn.setTitle("player_report_etc".localized(), for: .normal)
        btn.addTarget(self, action: #selector(didTapEtc), for: .touchUpInside)
        btn.setImage(UIImage(systemName:"checkmark.circle.fill"), for: .normal)
        btn.tintColor = .newdioMain
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let stackView1 = UIStackView(arrangedSubviews: [translateErrorButton, summaryErrorButton])
        stackView1.axis = .horizontal
        stackView1.distribution = .fillEqually
        stackView1.spacing = 5
        let stackView2 = UIStackView(arrangedSubviews: [soundErrorButton, etcErrorButton])
        stackView2.axis = .horizontal
        stackView2.distribution = .fillEqually
        stackView2.spacing = 5
        let stackView3 = UIStackView(arrangedSubviews: [stackView1, stackView2])
        stackView3.axis = .vertical
        stackView3.distribution = .fillEqually
        stackView3.spacing = 5
        return stackView3
    }()
    
    private var reportTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .newdioGray4
        tv.layer.borderColor = UIColor.newdioGray2.cgColor
        tv.layer.borderWidth = 1
        tv.text = "player_report_reason_please".localized()
        tv.textColor = .lightGray
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return tv
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("common_cancel".localized(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.newdioGray1, for: .normal)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    private var reportButton: UIButton = {
        let button = UIButton()
        button.setTitle("player_report".localized(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(didTapReport), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var horizonLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        return view
    }()
    
    private var verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureNotification()
        configureGesture()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureGesture() {
        let tapLabelGestureRecognizer = UITapGestureRecognizer()
        tapLabelGestureRecognizer.addTarget(self, action: #selector(didTapReportView))
        addGestureRecognizer(tapLabelGestureRecognizer)
    }
    
    private func configureUI() {
        backgroundColor = .newdioGray4.withAlphaComponent(0.3)
        
        reportTextView.delegate = self
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(330)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.addSubview(reportTextView)
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(95)
        }
        
        contentView.addSubview(horizonLineView)
        horizonLineView.snp.makeConstraints { make in
            make.top.equalTo(reportTextView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentView.addSubview(verticalLineView)
        verticalLineView.snp.makeConstraints { make in
            make.top.equalTo(horizonLineView.snp.bottom)
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(1)
        }
        
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(horizonLineView.snp.bottom)
            make.right.equalTo(verticalLineView.snp.left)
            make.left.bottom.equalToSuperview()
        }

        contentView.addSubview(reportButton)
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(horizonLineView.snp.bottom)
            make.left.equalTo(verticalLineView.snp.right)
            make.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            contentView.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-keyboardSize.height / 2)
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        contentView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func didTapReportView() {
        endEditing(true)
    }
    
    @objc private func didTapTranslate() {
        reportType = .translate
        didTapButtonClick(clicked: translateErrorButton)
    }
    
    @objc private func didTapSummary() {
        reportType = .summary
        didTapButtonClick(clicked: summaryErrorButton)
    }
    
    @objc private func didTapSound() {
        reportType = .sound
        didTapButtonClick(clicked: soundErrorButton)
    }
    
    @objc private func didTapEtc() {
        reportType = .etc
        didTapButtonClick(clicked: etcErrorButton)
    }
    
    @objc private func didTapCancel() {
        delegate?.didTapCancel()
        resetData()
    }
    
    @objc private func didTapReport() {
        delegate?.didTapReport(type: self.reportType, content: reportTextView.text ?? "")
    }
    
    private func didTapButtonClick(clicked: UIButton) {
        let buttonList = [translateErrorButton, summaryErrorButton, soundErrorButton, etcErrorButton]
        for button in buttonList {
            if button == clicked {
                button.setImage(UIImage(systemName:"checkmark.circle.fill"), for: .normal)
                button.tintColor = .newdioMain
            } else {
                button.setImage(UIImage(systemName:"circle"), for: .normal)
                button.tintColor = .newdioGray2
            }
        }
    }
    
    private func resetData() {
        endEditing(true)
        
        didTapButtonClick(clicked: etcErrorButton)
        
        reportButton.isEnabled = false
        reportButton.setTitleColor(.gray, for: .normal)
        reportTextView.text = "player_report_reason_please".localized()
        reportTextView.textColor = .lightGray
    }
}

//MARK: - TextView Extension

extension ReportView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "player_report_reason_please".localized() {
            textView.text = nil
            textView.textColor = .newdioWhite
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "player_report_reason_please".localized()
            textView.textColor = .lightGray
        }
    }

    //글자수 만족 유효성검사
    func textViewDidChange(_ textView: UITextView) {
        let currentText = textView.text ?? ""
        
        if currentText.count >= 5 , currentText.count <= 500 {
            reportButton.isEnabled = true
            reportButton.setTitleColor(.newdioMain, for: .normal)
        } else {
            reportButton.isEnabled = false
            reportButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    //최대 500자만 입력가능하도록 설정
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 500
    }
}
