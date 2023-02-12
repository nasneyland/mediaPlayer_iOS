//
//  ScrollViewController.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import UIKit

class ScrollViewController: UIViewController {

    //MARK:- Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK:- Configure
    
    func configureView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
    }
}
