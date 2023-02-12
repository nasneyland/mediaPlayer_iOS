//
//  PlayerControlsView.swift
//  Newdio
//
//  Created by najin on 2021/10/24.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapListButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapHeartButton(_ playerControlsView: PlayerControlsView)
}

class PlayerControlsView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PlayerControlsViewDelegate?

    var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var progressView: UIProgressView = {
        let pv = UIProgressView()
        pv.progressTintColor = .white
        pv.trackTintColor = .gray
        pv.progress = 0.5
        return pv
    }()
    
    var timeSlider: UISlider = {
        let sl = UISlider()
        sl.setThumbImage(UIImage(named: "ic_player_circle"), for: .normal)
        sl.minimumTrackTintColor = .gray
        sl.isEnabled = false
        return sl
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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentTimeLabel, lineLabel,totalTimeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        return stackView
    }()
    
    var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_heart_off"), for: .normal)
        button.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
        return button
    }()
    
    var BackwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_playleft"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackwardButton), for: .touchUpInside)
        return button
    }()
    
    var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_player_stop"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        return button
    }()
    
    var ForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_playright"), for: .normal)
        button.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        return button
    }()
    
    var listButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_general_list"), for: .normal)
        button.addTarget(self, action: #selector(didTapListButton), for: .touchUpInside)
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
    
    // MARK: - Configure UI
    
    func configureUI() {
        
  
        
        addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
//        playerView.addSubview(timeSlider)
//        timeSlider.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(30)
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.height.equalTo(5)
//        }
//
//        playerView.addSubview(currentTimeLabel)
//        currentTimeLabel.snp.makeConstraints { make in
//            make.top.equalTo(timeSlider).offset(20)
//            make.left.equalToSuperview().offset(20)
//            make.height.equalTo(20)
//        }
//
//        playerView.addSubview(totalTimeLabel)
//        totalTimeLabel.snp.makeConstraints { make in
//            make.top.equalTo(timeSlider).offset(20)
//            make.left.equalTo(currentTimeLabel.snp.right)
//            make.right.equalToSuperview().offset(-20)
//            make.height.equalTo(20)
//        }

        playerView.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(56)
        }

        playerView.addSubview(BackwardButton)
        BackwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton.snp.centerY)
            make.right.equalTo(playPauseButton.snp.left).offset(-15)
            make.height.width.equalTo(50)
        }

        playerView.addSubview(ForwardButton)
        ForwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton.snp.centerY)
            make.left.equalTo(playPauseButton.snp.right).offset(15)
            make.height.width.equalTo(50)
        }
        
        playerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(playPauseButton.snp.bottom).offset(15)
        }
    }
    
    // MARK: - Helpers
    
    @objc private func didTapBackwardButton() {
//        delegate?.playerControlsViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapForwardButton() {
//        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc private func didTapPlayPauseButton() {
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
    }
    
    @objc private func didTapListButton() {
        delegate?.playerControlsViewDidTapListButton(self)
    }
    
    @objc private func didTapHeartButton() {
        delegate?.playerControlsViewDidTapHeartButton(self)
    }
}
