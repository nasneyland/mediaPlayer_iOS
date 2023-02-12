//
//  TopTableViewCell.swift
//  Newdio
//
//  Created by najin on 2021/10/10.
//

import UIKit

protocol TopCollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: TopCollectionViewCell?, index: Int, didTappedInTableViewCell: TopTableViewCell)
}

class TopTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "topTableViewCell"
    
    var cellDelegate: TopCollectionViewCellDelegate?
    var category: Category?
    
    private var currentIndex: CGFloat = 0
    private var isOneStepPaging = true
    
    private var topCollectionView: UICollectionView!
    
    private var topPageControl: UIPageControl = {
        let control = UIPageControl()
        control.isEnabled = true
        control.pageIndicatorTintColor = .gray
        control.currentPageIndicatorTintColor = .newdioMain
        control.numberOfPages = 10
        control.isHidden = true
        control.addTarget(self, action: #selector(pageControlSelectionAction), for: .valueChanged)
        return control
    }()
    
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCollection()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureCollection() {
        // HOT 뉴스 페이징 처리 (캐로셀 느낌)
        let cellWidth = floor(UIScreen.main.bounds.width * 0.85)
        let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: 340)
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topCollectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        topCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.identifier)
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        
        topCollectionView.backgroundColor = .newdioBlack
        topCollectionView.showsHorizontalScrollIndicator = false
        topCollectionView.decelerationRate = .fast
    }
    
    private func configureUI() {
        self.selectionStyle = .none
        self.backgroundColor = .newdioBlack
        
        contentView.addSubview(topCollectionView)
        topCollectionView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        contentView.addSubview(topPageControl)
        topPageControl.snp.makeConstraints { make in
            make.top.equalTo(topCollectionView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
                          
    //MARK: - Helpers
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        let layout = self.topCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        currentIndex = CGFloat(sender.currentPage)
        self.topCollectionView.contentOffset.x = (currentIndex * cellWidthIncludingSpacing) - topCollectionView.contentInset.left
    }
}

//MARK: - Table View delegate

extension TopTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    //뉴스 데이터 셋팅
    func updateCellWith(row: Category) {
        self.category = row
        self.topCollectionView.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.topCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        topPageControl.currentPage = 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.category?.newsList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = topCollectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as! TopCollectionViewCell
        
        let news = self.category?.newsList[indexPath.item]
        cell.titleLabel.text = news?.title ?? ""

        let url = URL(string: news?.imageURL ?? "")
        cell.imageView.kf.setImage(with: url)
        
        topPageControl.isHidden = false
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? TopCollectionViewCell
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}

//MARK: - Scroll Delegate

extension TopTableViewCell : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.topCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        
        topPageControl.currentPage = Int(currentIndex)
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
