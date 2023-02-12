//
//  PlayerPresenter.swift
//  Newdio
//
//  Created by najin on 2021/10/24.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class PlayerPresenter {
    
    static let shared = PlayerPresenter()
    
    var airPlayCenter = MPNowPlayingInfoCenter.default()
    var player: AVPlayer?
    
    var trackList: [NewsThumb] = [] // 뉴스 재생 목록
    var currentTrack = 0 // 현재 재생 지점
//    var isPlaying = false
    
    /// 플레이어 초기화
    static func reset() {
        // AirPlayCenter 종료
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        // time observer 초기화
        if let player = shared.player {
            player.removeTimeObserver(PlayerViewController.shared.timeObserver)
        }
        
        // 재생 정보 초기화
        shared.trackList = []
        shared.currentTrack = 0
        shared.player = nil
//        shared.isPlaying = false
    }
    
    //MARK: 플레이어 셋팅
    
    /// 라이브 뉴스 클릭한 경우 (start-modal)
    static func liveNewsPlayer(newsId: Int) {
        let playerVC = PlayerViewController.shared
        playerVC.initLivePlayer(newsId: newsId)

        self.startPlayer(vc: playerVC)
    }
    
    /// 특정 뉴스 클릭한 경우 (start-modal)
    static func playNewsPlayer(newsId: Int) {
        let playerVC = PlayerViewController.shared
        playerVC.initPlayer(newsId: newsId)
        
        self.startPlayer(vc: playerVC)
    }
    
    /// 특정 뉴스 클릭한 경우 (add-modal)
    static func playNewsPlayer(newsId: Int, vc: UIViewController) {
        let playerVC = PlayerViewController.shared
        playerVC.initPlayer(newsId: newsId)
        
        addPlayer(fromVC: vc, toVC: playerVC)
    }
    
    /// 뉴스 전체듣기 클릭한 경우 (start-modal)
    static func playListPlayer(newsList: [NewsThumb]) {
        let playerVC = PlayerViewController.shared
        
        // 뉴스 100개 까지만 리스트로
        if newsList.count > 100 {
            playerVC.initPlayer(newsList: Array(newsList[...99]))
        } else {
            playerVC.initPlayer(newsList: newsList)
        }
        
        self.startPlayer(vc: playerVC)
    }
    
    /// 뉴스 전체듣기 클릭한 경우 (add-modal)
    static func playListPlayer(newsList: [NewsThumb], vc: UIViewController) {
        let playerVC = PlayerViewController.shared
        
        // 뉴스 100개 까지만 리스트로
        if newsList.count > 100 {
            playerVC.initPlayer(newsList: Array(newsList[...99]))
        } else {
            playerVC.initPlayer(newsList: newsList)
        }
        
        self.addPlayer(fromVC: vc, toVC: playerVC)
    }
    
    //MARK: 플레이어 Present
    
    /// 플레이어 나타내기
    static func openPlayer() {
        let playerVC = PlayerViewController.shared
        
        playerVC.modalPresentationStyle = .overFullScreen
        MainTabBarController.shared.present(playerVC, animated: true)
    }
    
    /// 플레이어 시작하기
    static func startPlayer(vc: UIViewController) {
        // 플레이 리스트 초기화
        PlayListViewController.reset()
        shared.currentTrack = 0
        
        vc.modalPresentationStyle = .overFullScreen
        MainTabBarController.shared.present(vc, animated: true)
    }
    
    /// 플레이어 추가하기
    static func addPlayer(fromVC: UIViewController, toVC: UIViewController) {
        // 플레이 리스트 초기화
        PlayListViewController.reset()
        shared.currentTrack = 0
        
        toVC.modalPresentationStyle = .overFullScreen
        fromVC.present(toVC, animated: true)
    }
    
    //MARK: 플레이리스트 Present
    
    /// 플레이리스트 나타내기
    static func openPlayList() {
        let listVC = PlayListViewController.shared
        
        listVC.listMode = true
        
        listVC.modalPresentationStyle = .overFullScreen
        MainTabBarController.shared.present(listVC, animated: true)
    }
    
    /// 플레이리스트 추가하기
    static func addPlayList(vc: UIViewController) {
        let listVC = PlayListViewController.shared
        
        listVC.listMode = false
        
        listVC.modalPresentationStyle = .overFullScreen
        vc.present(listVC, animated: true)
    }
}
