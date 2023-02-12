//
//  TopNewsTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/09.
//

import UIKit
import Pageboy

class TopNewsTableViewCell: UITableViewCell {

    //MARK:- Properties
    
    private var topNewsVCs: Array<UIViewController> = []
    
//    var topNews: NewsModel? {
//        didSet {
//            setNews(news: topNews!)
//        }
//    }
    
    private var topNewsPageVC: PageboyViewController = {
        let vc = PageboyViewController()
        vc.view.backgroundColor = .yellow
        return vc
    }()
    
    //MARK:- Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .yellow
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Configure
    
    func configureCell() {
        contentView.addSubview(topNewsPageVC.view)
        topNewsPageVC.view.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(contentView)
            make.height.equalTo(contentView.snp.width)
        }
    }
    
    //MARK:- Helpers
    
//    private func setNews(news: NewsModel) {
//        print(news)
//    }
}

//MARK:- Extension

extension TopNewsTableViewCell: PageboyViewControllerDataSource {
    public func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return 5
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return topNewsVCs[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

//protocol ManagementCollectionViewCellDelegate: AnyObject {
//    func cell(_ didSelect: ManagementCollectionViewCell)
//}

//class ManagementCollectionViewCell: UICollectionViewCell {
//
//    //MARK: - Properties
//
//    var lockedMember: LockedMember? {
//        didSet {
//            configure(member: lockedMember!)
//        }
//    }
//
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textAlignment = .center
//        label.numberOfLines = 1
//
//        return label
//    }()
//
//    private let profileImageView: UIImageView = {
//        let iv = UIImageView(image: #imageLiteral(resourceName: "img_general_profile_square"))
//        iv.clipsToBounds = true
//        iv.contentMode = .scaleAspectFill
//        iv.layer.borderColor = UIColor.darkGray.cgColor
//        iv.layer.borderWidth = 0.25
//        return iv
//    }()
//
//    //MARK: - Lifecycle
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.backgroundColor = .none
//
//        contentView.addSubview(profileImageView)
//        profileImageView.layer.cornerRadius = 40 / 2 * widthAdjust
//        profileImageView.snp.makeConstraints { make in
//            make.width.height.equalTo(40 * widthAdjust)
//            make.centerX.equalToSuperview()
//        }
//
//        contentView.addSubview(nameLabel)
//        nameLabel.snp.makeConstraints { make in
//            make.top.equalTo(profileImageView.snp.bottom).offset(8 * heightAdjust)
//            make.width.lessThanOrEqualTo(40 * widthAdjust)
//            make.centerX.equalToSuperview()
//        }
//
//        profileImageView.isUserInteractionEnabled = true
//        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage)))
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//
//    //MARK: - Selectros
//    @objc func didTapImage() {
//
//    }
//}
