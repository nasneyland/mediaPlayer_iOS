//
//  LivePopUpViewController.swift
//  Newdio
//
//  Created by sg on 2021/11/23.
//

import UIKit
import SnapKit

class LivePopUpViewController: UIViewController {

    //MARK: - Configure
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.sizeToFit()
        let attr = NSMutableAttributedString(string: "\("live_info_1".localized())\n\("live_info_2".localized())")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        label.attributedText = attr
        return label
    }()
    
    private var infoStackView: UIStackView = {
        let positiveButton = UIButton()
        positiveButton.setImage(UIImage(named: "ic_live_green"), for: .normal)
        positiveButton.setTitle(" \("live_info_positive".localized())", for: .normal)
        positiveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        let unknownButton = UIButton()
        unknownButton.setImage(UIImage(named: "ic_live_yellow"), for: .normal)
        unknownButton.setTitle(" \("live_info_unknown".localized())", for: .normal)
        unknownButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        let negativeButton = UIButton()
        negativeButton.setImage(UIImage(named: "ic_live_red"), for: .normal)
        negativeButton.setTitle(" \("live_info_negative".localized())", for: .normal)
        negativeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        let view = UIStackView(arrangedSubviews: [positiveButton, unknownButton, negativeButton])
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fill
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureGesture()
    }
    
    //MARK: - Configure

    private func configureUI() {
        view.backgroundColor = .newdioBlack.withAlphaComponent(0.5)
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.right.equalToSuperview().offset(-50)
            make.width.equalTo(260)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.top).offset(-16)
            make.left.equalTo(infoLabel.snp.left).offset(-16)
            make.right.equalTo(infoLabel.snp.right).offset(16)
            make.bottom.equalTo(infoLabel.snp.bottom).offset(46)
        }
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        view.bringSubviewToFront(infoLabel)
    }
    
    private func configureGesture() {
        // 화면 터치시 view dismiss
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeDownGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeUpGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeUpGestureRecognizer)
    }
    
    //MARK: - Helpers
    
    @objc func dismissView() {
        NotificationCenter.default.post(name: NotificationManager.Live.closeInfo,object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
