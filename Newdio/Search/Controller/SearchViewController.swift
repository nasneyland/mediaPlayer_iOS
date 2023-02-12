//
//  SearchViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/27.
//

import UIKit

class SearchViewController: UIViewController {

    //MARK: - Properties
    
    private var searchButton: UIButton = {
        let btn = UIButton()
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: screenWidth - 100)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        btn.setImage(UIImage(named: "ic_general_search"), for: .normal)
        btn.backgroundColor = .newdioGray6
        btn.setTitle("search_insert_word".localized(), for: .normal)
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.layer.cornerRadius = 16
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLargeNav(title: "menu_search".localized())
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(45)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapSearch() {
        let vc = KeywordSearchViewController()
        vc.rootView = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
