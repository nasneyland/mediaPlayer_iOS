//
//  VersionViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/09.
//

import UIKit

class VersionViewController: UIViewController {

    //MARK: - Properties
    
    var titleName: String!
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "ic_icon.png")
        iv.tintColor = .newdioMain
        return iv
    }()
    
    let versionTitleLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .newdioWhite
        label.textAlignment = .center
        label.text = "settings_current_version".localized()
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .newdioMain
        label.textAlignment = .center
        label.text = "0.0.0"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [versionTitleLabel, versionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultNav(title: titleName)
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        versionLabel.text = CacheManager.getVersion()
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(62)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
