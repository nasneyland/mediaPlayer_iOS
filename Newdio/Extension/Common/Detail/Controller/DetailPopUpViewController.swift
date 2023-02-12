//
//  DetailPopUpViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/08.
//

import UIKit
import SnapKit

class DetailPopUpViewController: UIViewController {

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
        
        let attr = NSMutableAttributedString(string: " ")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        label.attributedText = attr
        return label
    }()
    
    //MARK: - Lifecycle
    
    init(description: String) {
        super.init(nibName: nil, bundle: nil)
        
        infoLabel.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureGesture()
    }
    
    //MARK: - Configure
    
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

    private func configureUI() {
        view.backgroundColor = .newdioBlack.withAlphaComponent(0.5)
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.right.equalToSuperview().offset(-50)
            make.width.equalTo(250)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.top).offset(-16)
            make.left.equalTo(infoLabel.snp.left).offset(-16)
            make.right.equalTo(infoLabel.snp.right).offset(16)
            make.bottom.equalTo(infoLabel.snp.bottom).offset(16)
        }
        
        view.bringSubviewToFront(infoLabel)
    }
    
    //MARK: - Helpers
    
    @objc func dismissView() {
        NotificationCenter.default.post(name: NotificationManager.Detail.closeInfo, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
