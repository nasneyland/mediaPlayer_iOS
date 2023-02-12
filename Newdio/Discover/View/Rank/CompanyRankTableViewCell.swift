//
//  RankTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/12.
//

import UIKit

enum CompanyRankType {
    case daily
    case realTime
}

class CompanyRankTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "companyRankTableViewCell"
    
    var rankType: CompanyRankType!
    var tableList: [UITableView] = []
    var companyList: [RankCompany] = []
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray4
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "".localized()
        label.textColor = .newdioWhite
        return label
    }()
    
    let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .newdioGray1
        label.text = String(format: "search_criteria".localized(), "00:00")
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_general_info_on_small"), for: .normal)
        btn.tintColor = .newdioGray1
        return btn
    }()
    
    lazy var rankScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: (UIScreen.main.bounds.size.width - 50) * 2, height: sv.frame.size.height)
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private var rankPageControl: UIPageControl = {
        let control = UIPageControl()
        control.isEnabled = false
        control.pageIndicatorTintColor = .gray
        control.currentPageIndicatorTintColor = .newdioMain
        control.numberOfPages = 2
        return control
    }()
    
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.selectionStyle = .none
        self.backgroundColor = .newdioBlack
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.right.equalTo(-20)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        containerView.addSubview(updateTimeLabel)
        updateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.right.equalTo(infoButton.snp.left)
            make.height.equalTo(30)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(25)
            make.right.equalTo(updateTimeLabel.snp.left).offset(-10)
            make.height.equalTo(30)
        }

        containerView.addSubview(rankScrollView)
        rankScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }

        containerView.addSubview(rankPageControl)
        rankPageControl.snp.makeConstraints { make in
            make.top.equalTo(rankScrollView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func configureScrollView() {
        rankScrollView.delegate = self
        
        for x in 0..<2 {
            let tableView = UITableView(frame: CGRect(x: CGFloat(x) * (UIScreen.main.bounds.size.width - 50), y: 0, width: UIScreen.main.bounds.size.width - 50, height: 300))
            
            tableView.register(CompanyRankListTableViewCell.self, forCellReuseIdentifier: CompanyRankListTableViewCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.backgroundColor = .none
            tableView.isScrollEnabled = false
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            
            tableList.append(tableView)
            rankScrollView.addSubview(tableView)
        }
    }
    
    //MARK: - Helpers
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - Extension, DataSource

extension CompanyRankTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        rankPageControl.currentPage = Int(floorf(Float(rankScrollView.contentOffset.x) / Float(rankScrollView.frame.size.width)))
    }
}

extension CompanyRankTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    //핫이슈 기업 리스트 셋팅
    func updateCompanyCellWith(company: [RankCompany]) {
        self.companyList = company
        for table in tableList {
            table.reloadData()
        }
        
        self.rankScrollView.setContentOffset(.zero, animated: false)
    }
    
    //일간 기업 리스트 셋팅
    func updateDailyCompanyCellWith(company: [RankCompany]) {
        self.companyList = company
        for table in tableList {
            table.reloadData()
        }
        
        self.rankScrollView.setContentOffset(.zero, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyRankListTableViewCell.identifier, for: indexPath) as! CompanyRankListTableViewCell
        
        if tableView == tableList[0] {
            if companyList.count > indexPath.row {
                cell.rankLabel.text = "\(indexPath.row + 1)"
                cell.nameLabel.text = companyList[indexPath.row].name
                cell.industryLabel.text = companyList[indexPath.row].industry

                let url = URL(string: companyList[indexPath.row].logoURL ?? "")
                cell.logoImageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
                
                let change = companyList[indexPath.row].change
                
                if change == "new" {
                    cell.changeLabel.text = "NEW"
                } else {
                    if let change = Int(change) {
                        if change == 0 {
                            cell.changeLabel.text = "⏤"
                        } else if change > 0 {
                            cell.changeLabel.text = "▲ \(abs(change))"
                        } else {
                            cell.changeLabel.text = "▼ \(abs(change))"
                        }
                    }
                }
            }
        } else {
            if companyList.count > indexPath.row + 5 {
                cell.rankLabel.text = "\(indexPath.row + 6)"
                cell.nameLabel.text = companyList[indexPath.row + 5].name
                cell.industryLabel.text = companyList[indexPath.row + 5].industry
                
                let url = URL(string: companyList[indexPath.row + 5].logoURL ?? "")
                cell.logoImageView.kf.setImage(with: url, options: [.cacheMemoryOnly])
                
                let change = companyList[indexPath.row + 5].change
                
                if change == "new" {
                    cell.changeLabel.text = "NEW"
                } else {
                    if let change = Int(change) {
                        if change == 0 {
                            cell.changeLabel.text = "⏤"
                        } else if change > 0 {
                            cell.changeLabel.text = "▲ \(abs(change))"
                        } else {
                            cell.changeLabel.text = "▼ \(abs(change))"
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = rankPageControl.currentPage == 0 ? indexPath.row : indexPath.row + 5
        let companyId = companyList[position].id ?? ""
        
        NotificationCenter.default.post(name: NotificationManager.Discover.company, object: nil, userInfo: ["id": companyId])
        
        if rankType == .realTime {
            // 랭킹 기업 클릭 로그 전송
            LogManager.sendLogData(screen: .discover, action: .click, params: ["type": "rank_co", "co_id": companyId, "position": position])
        } else {
            // 일간 기업 클릭 로그 전송
            LogManager.sendLogData(screen: .discover, action: .click, params: ["type": "daily_co", "co_id": companyId, "position": position])
        }
    }
}
