//
//  KeywordSearchViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/27.
//

import UIKit

class KeywordSearchViewController: UIViewController {

    //MARK: - Properties
    
    var rootView: UIViewController?
    private var searchList = CacheManager.getSearchCache()
    private var viewHeight: CGFloat?
    
    private var searchButton: UIButton = {
        let btn = UIButton()
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: screenWidth - 145)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "ic_general_search"), for: .normal)
        btn.backgroundColor = .newdioGray6
        btn.layer.cornerRadius = 16
        btn.contentHorizontalAlignment = .left
        btn.isEnabled = false
        return btn
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.returnKeyType = UIReturnKeyType.search
        tf.font = UIFont.boldSystemFont(ofSize: 13)
        tf.textColor = .newdioWhite
        tf.enablesReturnKeyAutomatically = true
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("common_cancel".localized(), for: .normal)
        button.setTitleColor(.newdioWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    private let noneLabel: UILabel = {
        let label = UILabel()
        label.text = "search_no_recent_word".localized()
        label.textColor = .newdioGray1
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .newdioBlack
        tableView.register(KeywordSearchTableViewCell.self, forCellReuseIdentifier: KeywordSearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNotification()
        configureUI()
        configureTable()
    }
    
    //MARK: - Configure
    
    private func configureNotification(){
        viewHeight = view.frame.size.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTextField.becomeFirstResponder()
        searchTextField.delegate = self
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(45)
        }
        
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.top)
            make.bottom.equalTo(searchButton.snp.bottom)
            make.left.equalTo(searchButton.snp.left).offset(40)
            make.right.equalTo(searchButton.snp.right).offset(-10)
        }
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(searchButton.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(noneLabel)
        noneLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configureTable() {
        if searchList.count != 0 {
            tableView.isHidden = false
            noneLabel.isHidden = true
        } else {
            tableView.isHidden = true
            noneLabel.isHidden = false
        }
    }
    
    //MARK: - Helpers
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height = viewHeight! - keyboardSize.height
        }
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.size.height = viewHeight!
        self.view.layoutIfNeeded()
    }
    
    @objc func didTapBack() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func didTapDeleteAll() {
        let alert =  UIAlertController(title: "popup_notification".localized(), message: "search_delete_all_question".localized(), style:  UIAlertController.Style.alert)
        let yes =  UIAlertAction(title: "popup_confirm".localized(), style: .default, handler: { (action) in
            self.searchList = []
            UserDefaults.standard.set([], forKey: "SearchList")
            
            self.configureTable()
        })
        let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
        
        yes.setValue(UIColor(hex: "#69DB7C"), forKey: "titleTextColor")
        alert.addAction(cancel)
        alert.addAction(yes)
        alert.view.tintColor =  UIColor(ciColor: .white)
        present(alert, animated: true, completion: nil)
    }
    
    private func searchKeyword(keyword: String) {
        searchList.insert(keyword, at: 0)
        CacheManager.setSearchCache(searchList: searchList)
        
        let vc = SearchResultViewController()
        vc.keyword = keyword
        self.rootView?.navigationController?.pushViewController(vc, animated: false)
        
        self.dismiss(animated: false)
    }
}

//MARK: - TableView Delegate

extension KeywordSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeywordSearchTableViewCell.identifier) as! KeywordSearchTableViewCell
        cell.delegate = self
        
        cell.searchIndex = indexPath.row
        cell.titleLabel.text = searchList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchKeyword(keyword: searchList.remove(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .newdioBlack
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        let titleLabel = UILabel()
        titleLabel.textColor = .newdioWhite
        titleLabel.text = "search_recent".localized()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
        }
        
        let deleteButton = UIButton()
        deleteButton.setTitleColor(.newdioGray1, for: .normal)
        deleteButton.setTitle("search_delete_all".localized(), for: .normal)
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        deleteButton.addTarget(self, action: #selector(didTapDeleteAll), for: .touchUpInside)
        
        headerView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension KeywordSearchViewController: KeywordSearchTableViewCellDelegate {
    func didTapDelete(index: Int) {
        searchList.remove(at: index)
        CacheManager.setSearchCache(searchList: searchList)
        
        tableView.reloadData()
        configureTable()
    }
}

//MARK: - TextField Delegate

extension KeywordSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyword = textField.text?.lowercased() ?? ""
        
        if keyword.count != 0 {
            for (idx, searched) in searchList.enumerated() {
                if searched == keyword {
                    
                    searchKeyword(keyword: searchList.remove(at: idx))
                    
                    return true
                }
            }
            
            searchKeyword(keyword: keyword)
            
            return true
        } else {
            return false
        }
    }
}
