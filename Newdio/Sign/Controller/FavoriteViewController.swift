//
//  FavoriteViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/09.
//

import UIKit

class FavoriteViewController: UIViewController {

    //MARK: - Properties
    
    var user: User!
    
    private var lastContentOffset: CGFloat = 0.0
    
    private var industryList: [Industry] = [] // 각 산업 메인 리스트
    
    private var addCompanyIndexList: [Int] = [] // 추가된 기업 리스트
    private var unopenedCompanyList: [Company] = [] //오픈되지 않은 기업 리스트
    private var openedCompanyList: [Company] = [] //오픈된 기업 리스트
    
    private var likeCompanyList: [String] = [] // 관심추가 기업 리스트
    private var likeIndustryList: [String] = [] // 관심추가 산업 리스트
    
    private var errorView: ErrorView!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "social_login_interested_company".localized()
        label.textColor = .newdioWhite
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "social_login_three_more_company".localized()
        label.textColor = .newdioGray1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioBlack
        return view
    }()
    
    private let companyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("common_company".localized(), for: .normal)
        btn.backgroundColor = .newdioMain
        btn.setTitleColor(.newdioWhite, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapCompany), for: .touchUpInside)
        return btn
    }()
    
    private let industryButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("common_industry".localized(), for: .normal)
        btn.backgroundColor = .newdioGray6
        btn.setTitleColor(.newdioGray1, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(didTapIndustry), for: .touchUpInside)
        return btn
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioBlack
        return view
    }()
    
    private lazy var companyListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 90, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.bounces = false
        collection.backgroundColor = .newdioBlack
        collection.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        collection.contentInset = UIEdgeInsets(top: 0, left:10, bottom:0, right:10)
        return collection
    }()
    
    private lazy var industryListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 90, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.bounces = false
        collection.backgroundColor = .newdioBlack
        collection.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        collection.contentInset = UIEdgeInsets(top: 0, left:10, bottom:0, right:10)
        return collection
    }()
    
    private let addButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .newdioGray6
        btn.setTitle(String(format: "social_add_count".localized(), String("0")), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.setTitleColor(.newdioMain, for: .normal)
        btn.titleLabel?.textAlignment = .center
//        btn.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return btn
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNotification()
        setDefaultNav(title: "")
        configureUI()
        configureCollection()
        
        loadListData()
    }
    
    /// 뒤로가기 시 메인 화면으로 이동
    override func didTapNavBack() {
        NotificationCenter.default.post(name: NotificationManager.Main.main, object: nil)
    }
    
    //MARK: - Configure
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(searchedCompany),
                                               name: NotificationManager.Sign.selectCompany,
                                               object: nil)
    }
    
    private func configureView(active: Bool) {
        infoView.isHidden = active
        buttonView.isHidden = active
        addButton.isHidden = active
        bottomView.isHidden = active
    }
    
    private func configureUI() {
        view.backgroundColor = .newdioBlack
        
        configureView(active: true)
        
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }
        
        infoView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(20)
        }
        
        infoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subtitleLabel.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        
        buttonView.addSubview(companyButton)
        companyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-60)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(80)
        }
        
        buttonView.addSubview(industryButton)
        industryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(60)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(80)
        }
        
        view.addSubview(companyListCollectionView)
        companyListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        view.addSubview(industryListCollectionView)
        industryListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.bringSubviewToFront(addButton)
    }
    
    private func configureCollection() {
        companyListCollectionView.isHidden = false
        industryListCollectionView.isHidden = true
        
        companyListCollectionView.delegate = self
        companyListCollectionView.dataSource = self
        
        industryListCollectionView.delegate = self
        industryListCollectionView.dataSource = self
    }
    
    private func configureError(type: ErrorType) {
        errorView = ErrorView(frame: .zero, type: type)
        errorView.delegate = self
        
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - API
    
    private func loadListData() {
        LoadingManager.show()
        
        DiscoverAPI.companyListAPI(error: {(type) in
            self.configureError(type: type)
            
            LoadingManager.hide()
        }) { (datas) in
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "ic_general_search"),
                style: .done,
                target: self,
                action: #selector(self.didTapSearch)
            )
            
            self.configureView(active: false)
            
            self.industryList = datas

            for (inIdx, industry) in self.industryList.enumerated() {
                
                self.industryList[inIdx].likeState = false
                
                for (coIdx, company) in industry.companyList.enumerated() {
                    
                    if coIdx == 0 {
                        //오픈된 기업 리스트 셋팅
                        self.openedCompanyList.append(Company(name: company.name,
                                                             id: company.id,
                                                             logoURL: company.logoURL,
                                                             abbreviation: "",
                                                             description: "",
                                                             industry: "",
                                                             likeState: false,
                                                             industryIndex: inIdx))
                    } else {
                        //숨겨진 기업 리스트 셋팅
                        self.unopenedCompanyList.append(Company(name: company.name,
                                                             id: company.id,
                                                             logoURL: company.logoURL,
                                                             abbreviation: "",
                                                             description: "",
                                                             industry: "",
                                                             likeState: false,
                                                             industryIndex: inIdx))
                    }
                }
            }
            
            LoadingManager.hide()
            
            self.companyListCollectionView.reloadData()
            self.industryListCollectionView.reloadData()
        }
    }
    
    private func signUpAPI() {
        LoadingManager.show()
    
        SignAPI.signUpAPI(user: user, error: {(error) in
            LoadingManager.hide()
            self.present(ErrorManager.errorToAlert(error: error), animated: false)
        }) { () in
            LoadingManager.hide()
            
            let joinVC = JoinViewController()
            joinVC.modalPresentationStyle = .overFullScreen
            self.present(joinVC, animated: false)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapCompany() {

        //스크롤 맨 위로
        let i = IndexPath(item: 0, section: 0)
        companyListCollectionView.scrollToItem(at: i, at: .top, animated: false)
        
        titleLabel.alpha = 1
        subtitleLabel.alpha = 1
        infoView.snp.updateConstraints { make in
            make.height.equalTo(90)
        }
        
        companyButton.backgroundColor = .newdioMain
        companyButton.setTitleColor(.newdioWhite, for: .normal)

        industryButton.backgroundColor = .newdioGray6
        industryButton.setTitleColor(.newdioGray1, for: .normal)

        titleLabel.text =  "social_login_interested_company".localized()
        subtitleLabel.text = "social_login_three_more_company".localized()

        companyListCollectionView.isHidden = false
        industryListCollectionView.isHidden = true
        
        companyListCollectionView.reloadData()
    }

    @objc func didTapIndustry() {
        
        //스크롤 맨 위로
        let i = IndexPath(item: 0, section: 0)
        industryListCollectionView.scrollToItem(at: i, at: .top, animated: false)
        
        titleLabel.alpha = 1
        subtitleLabel.alpha = 1
        infoView.snp.updateConstraints { make in
            make.height.equalTo(90)
        }

        industryButton.backgroundColor = .newdioMain
        industryButton.setTitleColor(.newdioWhite, for: .normal)

        companyButton.backgroundColor = .newdioGray6
        companyButton.setTitleColor(.newdioGray1, for: .normal)

        titleLabel.text = "social_login_interested_industry".localized()
        subtitleLabel.text = "social_login_one_more_company".localized()

        companyListCollectionView.isHidden = true
        industryListCollectionView.isHidden = false
        
        industryListCollectionView.reloadData()
    }

    @objc func didTapAdd() {
        // 유효성 검사
        if self.likeCompanyList.count < 3 {
            setAlert(content: "social_login_three_more_company".localized())
        } else if self.likeIndustryList.count < 1 {
            setAlert(content: "social_login_one_more_company".localized())
        } else {
            user.companyList = self.likeCompanyList
            user.industryList = self.likeIndustryList
            
            let alert =  UIAlertController(title: "popup_notification".localized(), message: "social_login_notification".localized(), style:  UIAlertController.Style.alert)
            let yes =  UIAlertAction(title: "popup_confirm".localized(), style: .default, handler: { (action) in
                self.signUpAPI()
            })
            let cancel = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
            
            yes.setValue(UIColor.newdioMain, forKey: "titleTextColor")
            alert.addAction(cancel)
            alert.addAction(yes)
            alert.view.tintColor = .newdioWhite
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func searchedCompany(_ notification: NSNotification) {

        didTapCompany()
        
        let userInfo = notification.userInfo

        if let id = userInfo?["id"] as? String {

            // 이미 오픈된 기업인지 체크
            for (idx,company) in openedCompanyList.enumerated() {
                if company.id == id {
                    let i = IndexPath(item: idx, section: 0)
                    companyListCollectionView.scrollToItem(at: i, at: .top, animated: true)
                    
                    if !likeCompanyList.contains(id) {
                        // 하트를 누르지 않은 기업인 경우에만 좋아요 진행
                        self.openedCompanyList[idx].likeState = true
                        self.likeCompanyList.append(openedCompanyList[idx].id)
                    }
                    
                    return
                }
            }
            
            //아직 숨겨진 기업인 경우
            for (coIdx, company) in unopenedCompanyList.enumerated() {
                if company.id == id {
                    
                    //openedCompanyList에 해당 기업 추가
                    self.openedCompanyList.insert(Company(name: self.unopenedCompanyList[coIdx].name,
                                                          id: self.unopenedCompanyList[coIdx].id,
                                                          logoURL: self.unopenedCompanyList[coIdx].logoURL,
                                                          abbreviation: "",
                                                          description: "",
                                                          industry: "",
                                                          likeState: false,
                                                          industryIndex: company.industryIndex),
                                                    at: 0)
                    
                    //unopenedIndustry에서 해당 기업 제거
                    self.unopenedCompanyList.remove(at: coIdx)
                    
                    openedCompanyList[0].likeState = true
                    self.likeCompanyList.append(openedCompanyList[0].id)
                    
                    //스크롤 맨 위로
                    let i = IndexPath(item: 0, section: 0)
                    companyListCollectionView.scrollToItem(at: i, at: .top, animated: true)
                    
                    return
                }
            }
        }
    }
    
    @objc func didTapSearch() {
        let vc = CompanySearchViewController(type: .sign)
        vc.industryList = industryList
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    /// 추가 팝업 셋팅
    private func setAlert(content: String) {
        let alert = UIAlertController(title: "popup_notification".localized(), message: content, style: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "popup_confirm".localized(), style: .default, handler: nil)
        ok.setValue(UIColor.newdioMain, forKey: "titleTextColor")
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    /// 기업 클릭시
    private func selectCompany(index: Int) {
        let selectedCompany = self.openedCompanyList[index] //클릭한 기업

        if selectedCompany.likeState == true {
            //좋아요된 상태에서 클릭시
            self.openedCompanyList[index].likeState = false

            //좋아요 기업 리스트에서 제거
            let cancleIndex = Int(self.likeCompanyList.firstIndex(of: selectedCompany.id) ?? 0)
            self.likeCompanyList.remove(at: cancleIndex)

        } else {
            //좋아요 안된 상태에서 클릭시
            self.openedCompanyList[index].likeState = true
            
            //좋아요 기업 리스트에 추가
            self.likeCompanyList.append(selectedCompany.id)
            
            //해당 기업의 산업에서 추가 오픈
            let industryIndex = selectedCompany.industryIndex
            
            //최대 3개까지 오픈
            for x in 1...3 {
                for (idx, company) in unopenedCompanyList.enumerated() {
                    
                    //오픈할 기업이 있으면
                    if company.industryIndex == industryIndex {
                        
                        //추가된 기업 리스트에 해당 기업 추가
                        addCompanyIndexList.append(index + x)
                        
                        //오픈된 기업 리스트에 해당 기업 추가
                        self.openedCompanyList.insert(Company(name: self.unopenedCompanyList[idx].name,
                                                              id: self.unopenedCompanyList[idx].id,
                                                              logoURL: self.unopenedCompanyList[idx].logoURL,
                                                              abbreviation: "",
                                                              description: "",
                                                              industry: "",
                                                              likeState: false,
                                                              industryIndex: industryIndex),
                                                        at: index + x)
                        
                        //오픈되지 않은 기업 리스트에서 해당 기업 제거
                        self.unopenedCompanyList.remove(at: idx)
                        
                        break
                    }
                }
            }
        }

        self.companyListCollectionView.reloadData()
    }
    
    // 산업 클릭시
    private func selectIndustry(index: Int) {
        let selectedIndustry = self.industryList[index]
        
        if selectedIndustry.likeState == true {
            //좋아요된 상태에서 클릭 시
            self.industryList[index].likeState = false

            //좋아요 산업 리스트에서 제거
            let cancleIndex = Int(self.likeIndustryList.firstIndex(of: selectedIndustry.id) ?? 0)
            self.likeIndustryList.remove(at: cancleIndex)
        } else {
            //좋아요 안된 상태에서 클릭 시
            self.industryList[index].likeState = true
            
            //좋아요 산업 리스트에 추가
            self.likeIndustryList.append(selectedIndustry.id)
        }
        
        self.industryListCollectionView.reloadData()
    }
}

//MARK: - Collection Extension

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == companyListCollectionView {
            // 오픈된 기업 리스트만 셋팅
            return self.openedCompanyList.count
        } else {
            // 전체 산업 리스트만 셋팅
            return self.industryList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as! FavoriteCollectionViewCell
        
        if collectionView == companyListCollectionView {
            // 추가된 기업이면 효과 나타내기
            if addCompanyIndexList.contains(indexPath.row) {
                if let index = addCompanyIndexList.firstIndex(of: indexPath.row) {
                    addCompanyIndexList.remove(at: index)
                }
                
                // 커지면서 나타나는 효과
                cell.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.3, animations: {
                    cell.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
                
            // 기업 이름 셋팅
            cell.nameLabel.text = self.openedCompanyList[indexPath.row].name
            cell.nameLabel.backgroundColor = .newdioBlack
            
            // 기업 로고 이미지 셋팅
            let url = URL(string: self.openedCompanyList[indexPath.row].logoURL)
            cell.imageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
            
            // 기업 좋아요 상태 셋팅
            if self.openedCompanyList[indexPath.row].likeState {
                cell.heartButton.isHidden = false
            } else {
                cell.heartButton.isHidden = true
            }

            return cell
        } else {
            // 산업 이름 셋팅
            cell.nameLabel.text = self.industryList[indexPath.row].name
            cell.nameLabel.backgroundColor = .newdioBlack
            
            //산업 로고 이미지 셋팅
            let url = URL(string: self.industryList[indexPath.row].logoURL)
            cell.imageView.kf.setImage(with: url, options: [.cacheMemoryOnly])

            // 산업 좋아요 상태 셋팅
            if self.industryList[indexPath.row].likeState {
                cell.heartButton.isHidden = false
            } else {
                cell.heartButton.isHidden = true
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        addCompanyIndexList = []
        
        if collectionView == companyListCollectionView {
            selectCompany(index: indexPath.row)
        } else {
            selectIndustry(index: indexPath.row)
        }

        // 추가 버튼 개수 셋팅
        self.addButton.setTitle("\(self.likeCompanyList.count + self.likeIndustryList.count)개 추가", for: .normal)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = self.lastContentOffset - scrollView.contentOffset.y
        let diff = infoView.frame.height + offset
        let percentage = min(diff / 90, 1)
        
        // 투명도 셋팅
        titleLabel.alpha = percentage
        subtitleLabel.alpha = percentage
        
        // 스크롤 시 헤더 보이게, 안보이게 변경
        if offset > 0 {
            //위로 스크롤 시
            infoView.snp.updateConstraints { make in
                make.height.equalTo(min(diff,90))
            }
        } else if offset < 0 {
            //아래로 스크롤 시
            infoView.snp.updateConstraints { make in
                make.height.equalTo(max(diff,0))
            }
        } else {
            // 투명도 셋팅
            titleLabel.alpha = 1
            subtitleLabel.alpha = 1
        }
        
        // 스크롤 위치 저장
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

//MARK: - Error Delegate

extension FavoriteViewController: ErrorViewDelegate {
    func didTapRetry() {
        LoadingManager.show()
        
        if let error = errorView {
            error.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.loadListData()
        }
    }
}
