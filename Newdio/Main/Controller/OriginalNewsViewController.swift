//
//  OriginalNewsViewController.swift
//  Newdio
//
//  Created by najin on 2021/12/14.
//

import UIKit

class OriginalNewsViewController: UIViewController {

    //MARK: - Properties
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    var scrollMode = false
    
    private var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    private var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .newdioGray6
        return view
    }()
    
    private var contentTextView: UITextView = {
        let tv = UITextView()
        let attr = NSMutableAttributedString(string: " ")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        tv.attributedText = attr
        tv.font = UIFont.customFont(size: 15, weight: .regular)
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        tv.textColor = .white
        tv.backgroundColor = .none
        tv.sizeToFit()
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.isSelectable = true
        tv.showsVerticalScrollIndicator = false
        tv.bounces = false
        return tv
    }()
    
    //MARK: - Lifecycle
    
    init(title: String, content: String) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        contentTextView.text = content
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureGesture()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(150)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(mainView)
        mainView.backgroundColor = .newdioGray4
        mainView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.left.right.bottom.equalToSuperview()
        }
        
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        mainView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        mainView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(18)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func configureGesture() {
        self.modalPresentationStyle = .overFullScreen
        
        //바깥영역에 스와이프 추가
        let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap(_:)))
        backgroundView.addGestureRecognizer(viewTapGestureRecognizer)
        
        //원문보기에 스와이프 추가
        let viewSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleViewSwipes(_:)))
        mainView.addGestureRecognizer(viewSwipeGestureRecognizer)
        
        //텍스트뷰에 스와이프 추가
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeGestureRecognizer.delegate = self
        contentTextView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //MARK: - Helpers
    
    //뷰 스와이프
    @objc func handleViewTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    //뷰 스와이프
    @objc func handleViewSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view.window)
        if sender.state == .began {
            initialTouchPoint = touchPoint
        } else if sender.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    //텍스트뷰 스와이프
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view.window)

//        if sender.state == .began {
//            initialTouchPoint = touchPoint
//        }
//
//        if self.contentTextView.contentOffset.y == 0 {
//            //텍스트뷰 위치가 top인 경우
//            if touchPoint.y - initialTouchPoint.y > 0 {
//                //아래로 스와이프
//                contentTextView.isScrollEnabled = false
//            } else {
//                //위로 스와이프
//                contentTextView.isScrollEnabled = true
//            }
//        } else {
//            //텍스트뷰 위치가 아래인 경우
//            contentTextView.isScrollEnabled = true
//        }
        
        contentTextView.isScrollEnabled = true
        contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        if self.contentTextView.contentOffset.y == 0 {
          if sender.state == .began {
            scrollMode = false
            initialTouchPoint = touchPoint
          }
        }
        if scrollMode == false, sender.state != .began {
          //텍스트뷰 위치가 top인 경우
          if touchPoint.y - initialTouchPoint.y > 0 {
            //아래로 스와이프
            contentTextView.isScrollEnabled = false
            contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0)
            if sender.state == .changed {
              if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
              }
            } else if sender.state == .ended || sender.state == .cancelled {
              if touchPoint.y - initialTouchPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
              } else {
                UIView.animate(withDuration: 0.3) {
                  self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
              }
            }
          }
        }
        if sender.state == .ended || sender.state == .cancelled {
          scrollMode = true
        }
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Gesture Delegate

extension OriginalNewsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
