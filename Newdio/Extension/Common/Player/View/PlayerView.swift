//
//  NewsPlayerView.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import UIKit

protocol PlayerViewDelegate: AnyObject {
    func didTapPlay()
    func didTapForward()
    func didTapBackward()
}

class PlayerView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PlayerViewDelegate?
    
    // 인스타 업로드용 id 라벨
    var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    var siteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .newdioGray1
        label.textAlignment = .left
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .newdioGray1
        label.textAlignment = .right
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .newdioWhite
        label.textAlignment = .center
        label.numberOfLines = 4
        label.sizeToFit()
        return label
    }()
    
    var newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .newdioBlack
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var gradientView: UIView = {
        let gradientView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.newdioBlack.withAlphaComponent(1).cgColor, UIColor.newdioBlack.withAlphaComponent(0.2).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 370)
        gradientView.layer.addSublayer(gradientLayer)
        return gradientView
    }()
    
    var contentTextView: UITextView = {
        let tv = UITextView()
        let attr = NSMutableAttributedString(string: " ")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        tv.attributedText = attr
        tv.font = UIFont.customFont(size: 16, weight: .regular)
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tv.textColor = .newdioWhite
        tv.backgroundColor = .none
        tv.sizeToFit()
        tv.isUserInteractionEnabled = true
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.isSelectable = true
        tv.showsVerticalScrollIndicator = false
        tv.bounces = false
        return tv
    }()
    
    var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .newdioGray1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var lineLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.textColor = .newdioGray1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .newdioGray1
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var BackwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_playleft"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
        return button
    }()
    
    var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_player_stop"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        button.backgroundColor = .newdioMain.withAlphaComponent(0.7)
        button.layer.cornerRadius = 30
        return button
    }()
    
    var ForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_playright"), for: .normal)
        button.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .newdioBlack
        
        addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(400)
            make.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
        }
        
        addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(370)
        }
        
        newsImageView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(370)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(contentTextView.snp.top).offset(-150)
        }
        
        addSubview(siteLabel)
        siteLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-17)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(30)
        }

        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-17)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }

        bringSubviewToFront(contentTextView)
        
        addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentTextView.snp.top).offset(-32)
        }

        addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.right.equalTo(lineLabel.snp.left).offset(-5)
            make.bottom.equalTo(contentTextView.snp.top).offset(-32)
        }

        addSubview(totalTimeLabel)
        totalTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(lineLabel.snp.right).offset(5)
            make.bottom.equalTo(contentTextView.snp.top).offset(-32)
        }
        
        addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentTextView.snp.top).offset(-65)
            make.centerX.equalToSuperview()
            make.height.equalTo(playPauseButton.snp.width)
        }

        addSubview(BackwardButton)
        BackwardButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentTextView.snp.top).offset(-70)
            make.centerY.equalTo(playPauseButton.snp.centerY)
            make.right.equalTo(playPauseButton.snp.left).offset(-25)
            make.height.width.equalTo(50)
        }

        addSubview(ForwardButton)
        ForwardButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentTextView.snp.top).offset(-70)
            make.centerY.equalTo(playPauseButton.snp.centerY)
            make.left.equalTo(playPauseButton.snp.right).offset(25)
            make.height.width.equalTo(50)
        }
        
        addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    
    @objc private func didTapBackward() {
        delegate?.didTapBackward()
    }
    
    @objc private func didTapForward() {
        delegate?.didTapForward()
    }
    
    @objc private func didTapPlay() {
        delegate?.didTapPlay()
    }
}
