//
//  CompanyListViewController.swift
//  Newdio
//
//  Created by SG on 2021/11/16.
//

import UIKit
import SnapKit

class CompanyListViewController: UIViewController {
    
    private let companyCollectionIdentifier = "comListCollectionViewCell"
    private let indusCollectionIdentifier = "indusCollectionViewCell"
    
    private var selectState = 0 //기업,산업 선택 구분
    
    private var companyList: [Industry] = [] //전체 산업-기업 리스트
    private var company: [Company] = [] //각 산업의 첫번째 기업 리스트
    private var companyArrayCnt = 0
    
    private var industryList: [Industry] = [] // 각 산업 메인 리스트
    
    private var likeCompany: [String] = [] // 관심추가 기업 리스트
    private var likeIndus: [String] = [] // 관심 추가 산업 리스트

    
    lazy var companyListCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero)
        collection.register(ComListCollectionViewCell.self, forCellWithReuseIdentifier: companyCollectionIdentifier)
        return collection
    }()
    
    lazy var IndusCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero)
        collection.register(IndusCollectionViewCell.self, forCellWithReuseIdentifier: indusCollectionIdentifier)
        return collection
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "social_login_interested_company".localized()
        label.textAlignment = .center
        label.textColor = .newdioWhite
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "social_login_three_more_company".localized()
        label.textColor = .newdioGray1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let comBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("common_company".localized(), for: .normal)
        btn.backgroundColor = .newdioGray6
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    private let industBtn: UIButton = {
       let btn = UIButton()
        btn.setTitle("common_industry".localized(), for: .normal)
        btn.backgroundColor = .newdioGray6
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        return view
    }()
    
    private let addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("0개 추가", for: .normal)
        btn.setTitleColor(.newdioMain, for: .normal)
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    
    private let ComListcollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let InduscollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private func configureCollcetion() {
        ComListcollectionView.register(ComListCollectionViewCell.self,
                                forCellWithReuseIdentifier: ComListCollectionViewCell.identifier)
        ComListcollectionView.delegate = self
        ComListcollectionView.dataSource = self
        
        InduscollectionView.register(IndusCollectionViewCell.self,
                                forCellWithReuseIdentifier: IndusCollectionViewCell.identifier)
        InduscollectionView.delegate = self
        InduscollectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 네비게이션
        configureItem()
        
        // 뷰 세팅
        viewDidLayoutSubviews()
    
        // 버튼 세팅
        addButtonAction()
        
        // 컬렉션 세팅
        configureCollcetion()
        
        // API
        loadListData(url: CompanyListAPI.companyListURL)
    }
    

    private func configureItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_general_arrowleft_white"),
            style: .done,
            target: self,
            action: #selector(didTapBack)
        )

        self.navigationController?.navigationBar.tintColor = .newdioGray2
    }
    
    @objc func didTapBack() {
        let navVC = UINavigationController(rootViewController:GenderViewController())
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(comBtn)
        view.addSubview(industBtn)
        view.addSubview(bottomView)
        view.addSubview(ComListcollectionView)
        view.addSubview(InduscollectionView)
        view.addSubview(addBtn)
        
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(61)
            make.right.equalToSuperview().offset(-62)
            make.top.equalToSuperview().offset(108)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(97)
            make.right.equalToSuperview().offset(-96)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        comBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
        industBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 32))
            make.right.equalToSuperview().offset(-100)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
        }
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.left.right.bottom.equalToSuperview()
        }
        ComListcollectionView.snp.makeConstraints { make in
            make.top.equalTo(industBtn.snp.bottom).offset(24)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        InduscollectionView.snp.makeConstraints { make in
            make.top.equalTo(industBtn.snp.bottom).offset(24)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        addBtn.snp.makeConstraints { make in
            make.top.equalTo(bottomView).offset(22)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
    }
    
    private func addButtonAction() {
        comBtn.addTarget(self, action: #selector(didTapCom), for: .touchUpInside)
        industBtn.addTarget(self, action: #selector(didTapIndust), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        didTapCom()
    }
    
    @objc func didTapCom() {
        
        self.selectState = 0
        
        comBtn.backgroundColor = .newdioMain
        comBtn.setTitleColor(.white, for: .normal)
  
        industBtn.backgroundColor = .newdioGray6
        industBtn.setTitleColor(.newdioGray1, for: .normal)
        
        titleLabel.text =  "social_login_interested_company".localized()
        descriptionLabel.text = "social_login_three_more_company".localized()
        
        ComListcollectionView.isHidden = false
        InduscollectionView.isHidden = true
    
    }

    @objc func didTapIndust() {
        
        self.selectState = 1
        
        industBtn.backgroundColor = .newdioMain
        industBtn.setTitleColor(.white, for: .normal)
        
        comBtn.backgroundColor = .newdioGray6
        comBtn.setTitleColor(.newdioGray1, for: .normal)
        
        titleLabel.text = "social_login_interested_industry".localized()
        descriptionLabel.text = "social_login_one_more_company".localized()
        
        ComListcollectionView.isHidden = true
        InduscollectionView.isHidden = false

    }
    
    func alertMessage(content: String) {
        let alert = UIAlertController(title: "알림", message: content, preferredStyle: UIAlertController.Style.alert)
                    
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)
                    present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapAdd() {
//        let navVC = UINavigationController(rootViewController: HomeViewController())
//        navVC.modalPresentationStyle = .fullScreen
//        self.present(navVC, animated: false)
      
        // 유효성 검사
        if self.likeIndus.count >= 1 && self.likeCompany.count >= 3 {
            alertMessage(content: "\n 선택한 기업은 \n \(self.likeCompany) \n\n 선택한 산업은 \n \(self.likeIndus)")
        } else if self.likeCompany.count < 3 {
            alertMessage(content: "social_login_three_more_company".localized())
        } else if self.likeIndus.count < 1 {
            alertMessage(content: "social_login_one_more_company".localized())
        }
    }
    
    // API
    private func loadListData(url: String) {
        CompanyListAPI.listAPI(url: url, error: {(type) in
        }) { (datas) in
            self.companyList = datas
            
            for i in 0 ..< self.companyList.count {
                self.companyList[i].indexState = 0
                
                self.company.append(Company(name: self.companyList[i].companyList![0].name,
                                            id: self.companyList[i].companyList![0].id,
                                            logoURL: self.companyList[i].companyList![0].logoURL,
                                            abbreviation: nil,
                                            description: nil,
                                            industry: nil,
                                            companyIndex: self.companyArrayCnt,
                                            companyDetailIndex: 0,
                                            likeState: false))
                                    
                self.industryList.append(Industry(name: self.companyList[i].name,
                                                  id: self.companyList[i].id,
                                                  logoURL: self.companyList[i].logoURL,
                                                  companyList: [],
                                                  indexState: nil,
                                                  likeState: false))
            
                self.companyArrayCnt += 1
            }
            
            print("[Log_indusList]:\(self.industryList)")
            
            self.companyArrayCnt = 0
            self.ComListcollectionView.reloadData()
            self.InduscollectionView.reloadData()
            
        }
    }
    
}

extension CompanyListViewController: UICollectionViewDelegate {
 
    // Data Resource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == ComListcollectionView {
         
            return self.company.count
        } else if collectionView == InduscollectionView {
            print("[Log_cell_Count]:\(self.companyList.count)")
            return self.industryList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == ComListcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComListCollectionViewCell.identifier, for: indexPath) as! ComListCollectionViewCell
            
            cell.nameLabel.backgroundColor = .black
            cell.nameLabel.text = self.company[indexPath.row].name
            cell.imageView.setImageUrl(url: self.company[indexPath.row].logoURL!)
            
            if self.company[indexPath.row].likeState == true {
                cell.heartButton.isHidden = false
                cell.imageView.alpha = 0.79
                
                self.likeCompany.append(self.company[indexPath.row].id)
         
            } else if self.company[indexPath.row].likeState == false {
                cell.heartButton.isHidden = true
                cell.imageView.alpha = 1
                
            }
            
            let removedDuplicate = Set(self.likeCompany)
            self.likeCompany = Array(removedDuplicate)
            self.likeCompany = self.likeCompany.sorted(by:>)
            
            self.addBtn.setTitle("\(self.likeCompany.count + self.likeIndus.count)개 추가", for: .normal)
            
            print("[Log_like_company]:\(self.likeCompany)")
            return cell
            
        } else if collectionView == InduscollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndusCollectionViewCell.identifier, for: indexPath) as! IndusCollectionViewCell
            
            cell.nameLabel.backgroundColor = .black
            cell.nameLabel.text = self.industryList[indexPath.row].name
            cell.imageView.setImageUrl(url: self.industryList[indexPath.row].logoURL!)
  
            if self.industryList[indexPath.row].likeState == true {
                cell.heartButton.isHidden = false
                cell.imageView.alpha = 0.79
                

                self.likeIndus.append(self.industryList[indexPath.row].id!)
         
            } else if self.industryList[indexPath.row].likeState == false {
                cell.heartButton.isHidden = true
                cell.imageView.alpha = 1
              
            }
            
            let removedDuplicate = Set(self.likeIndus)
            self.likeIndus = Array(removedDuplicate)
            self.likeIndus = self.likeIndus.sorted(by:>)
            
            self.addBtn.setTitle("\(self.likeCompany.count + self.likeIndus.count)개 추가", for: .normal)
            
            return cell
    
        }
    
        return UICollectionViewCell()
        
    }
}

extension CompanyListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == ComListcollectionView {
        
        let companyIndex: Int = self.company[indexPath.row].companyIndex!
        let addIndex: Int = self.companyList[companyIndex].indexState!
      
        if self.company[indexPath.row].likeState == false {
            self.company[indexPath.row].likeState = true
            
            for x in 1...3 {
                
                let companyIndex: Int = self.company[indexPath.row].companyIndex!
                
                if self.companyList[companyIndex].indexState! + 1 < self.companyList[companyIndex].companyList!.count {
                    self.companyList[companyIndex].indexState! = self.companyList[companyIndex].indexState! + 1
                    
                    let addIndex: Int = self.companyList[companyIndex].indexState!
                    
                    self.company.insert(Company(name: self.companyList[companyIndex].companyList![addIndex].name,
                                                id: self.companyList[companyIndex].companyList![addIndex].id,
                                                logoURL: self.companyList[companyIndex].companyList![addIndex].logoURL,
                                                abbreviation: nil,
                                                description: nil,
                                                industry: nil,
                                                companyIndex: companyIndex,
                                                companyDetailIndex: addIndex,
                                                likeState: false),
                                        at: indexPath.row + x)
                }
            }
        } else if self.company[indexPath.row].likeState == true {
            self.company[indexPath.row].likeState = false
            
            let cancleIndex = Int(self.likeCompany.firstIndex(of: self.company[indexPath.row].id) ?? 0)
           
            print("[Log_like_delete]: \(cancleIndex)")
            self.likeCompany.remove(at: cancleIndex)
        }
    
        self.ComListcollectionView.reloadData()
            
            
        } else if collectionView == InduscollectionView {
            if self.industryList[indexPath.row].likeState == false {
                self.industryList[indexPath.row].likeState = true
            
            } else if self.industryList[indexPath.row].likeState == true {
                self.industryList[indexPath.row].likeState = false
           
                let cancleIndex = Int(self.likeIndus.firstIndex(of: self.industryList[indexPath.row].id!) ?? 0)
               
                print("[Log_like_delete]: \(cancleIndex)")
                self.likeIndus.remove(at: cancleIndex)
                
            }
            self.InduscollectionView.reloadData()
        }
    }
}

extension CompanyListViewController: UICollectionViewDelegateFlowLayout {
    
    //DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (view.frame.size.width/3)-3,
            height: (view.frame.size.width/3)-3
        )
    }
    
    //section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3 // 세로
    }
}
