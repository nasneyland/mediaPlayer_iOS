//
//  DiscoverPopUpViewController.swift
//  Newdio
//
//  Created by najin on 2022/01/16.
//

import UIKit

class DiscoverPopUpViewController: UIViewController {

    //MARK: - Configure
    
    var touchViewPoint = CGPoint(x: 0.0, y: 0.0)
    var touchPoint = CGPoint(x: 0.0, y: 0.0)
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotification()
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureNotification() {
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(touchViewPoint.y - touchPoint.y)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(touchViewPoint.x - touchPoint.x - 250)
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
        NotificationCenter.default.post(name: NotificationManager.Discover.closeInfo, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
