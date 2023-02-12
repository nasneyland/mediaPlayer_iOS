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
        iv.image = UIImage(named: "ic_general_newdio.png")
        return iv
    }()
    
    let versionTitleLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
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
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else { return }
        
        versionLabel.text = "\(version)"
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    @objc func back() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.popViewController(animated: true)
    }
}
