//
//  KeywordSearchTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/12/27.
//

import UIKit

protocol KeywordSearchTableViewCellDelegate: AnyObject {
    func didTapDelete(index: Int)
}

class KeywordSearchTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "KeywordSearchTableViewCell"
    
    var delegate: KeywordSearchTableViewCellDelegate?
    var searchIndex = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = ""
        label.textColor = .newdioWhite
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_general_delete"), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .newdioBlack
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-50)
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapDelete() {
        delegate!.didTapDelete(index: searchIndex)
    }
}
