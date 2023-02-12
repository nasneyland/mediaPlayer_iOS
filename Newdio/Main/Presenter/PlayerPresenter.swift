//
//  PlayerPresenter.swift
//  Newdio
//
//  Created by najin on 2021/10/24.
//

import Foundation
import UIKit
import AVFoundation

class PlayerPresenter {
    
    static let shared = PlayerPresenter()
    
    var trackList: [NewsThumb] = []
    var currentTrack = 0
    
    var player: AVPlayer?
    
//    var currentItem: AVPlayerItem? {
//        return player?.currentItem
//    }
    
    static func newsPlayer(newsId: Int) {
        let playerVC = PlayerViewController(newsId: newsId)
        
        self.goPlayer(id: newsId, vc: playerVC)
    }
    
    static func newsListPlayer(news: [NewsThumb]) {
        let playerVC = PlayerViewController(news: news)
        
        self.goPlayer(id: news[0].id, vc: playerVC)
    }
    
    static func goPlayer(id: Int, vc: UIViewController) {
        shared.currentTrack = 0
        
        PlayListViewController.reset()
        
        vc.modalPresentationStyle = .overFullScreen
        MainTabBarController.shared.present(vc, animated: true)
    }
    
}
