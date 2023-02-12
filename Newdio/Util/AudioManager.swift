//
//  AudioManager.swift
//  Newdio
//
//  Created by najin on 2022/02/27.
//

import Foundation
import AVFoundation

class AudioManager {
    
    /// 오디오 병합 (얼마전 뉴스 오디오 + 뉴스 오디오)
    static func mergeAudioFiles(newsURL: URL, time: String, completion: @escaping () -> Void) {
        
        let dateURL = Bundle.main.url(forResource: time.toDate()?.getDateAgo(), withExtension: "mp3")!
        let audioFileUrls = [dateURL, newsURL]
        
        // 오디오를 잠시 저장해둘 AVMutableComposition을 선언한다.
        let composition = AVMutableComposition()

        // 병합할 오디오 파일 위치를 하나씩 조회
        for i in 0 ..< audioFileUrls.count {

            // 합칠 오디오 파일 준비
            let asset = AVURLAsset(url: audioFileUrls[i])
            let track = asset.tracks(withMediaType: AVMediaType.audio)[0]
            let timeRange = CMTimeRangeMake(start: CMTimeMake(value: 0, timescale: 600), duration: track.timeRange.duration)
            
            // composition에 파일 합치기
            let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!

            try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
        }
        
        // 사용자 기기에 저장할 url 선언
        let filemanager = FileManager.default
        let documentDirectoryURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let mergeAudioURL = documentDirectoryURL.appendingPathComponent("newdio.m4a")! as URL as NSURL
        
        // 경로에 파일이 이미 존재하면 파일 삭제
        if filemanager.fileExists(atPath: mergeAudioURL.path!) {
            do {
                try filemanager.removeItem(at: mergeAudioURL as URL)
            } catch let error as NSError {
                NSLog("Error: \(error)")
            }
        }
        
        // 사용자 기기에 병합된 오디오파일 저장
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = mergeAudioURL as URL
        assetExport?.exportAsynchronously(completionHandler: {
    //            switch assetExport!.status{
    //            case AVAssetExportSession.Status.failed:
    //                print("failed \(assetExport?.error)")
    //            case AVAssetExportSession.Status.cancelled:
    //                print("cancelled \(assetExport?.error)")
    //            case AVAssetExportSession.Status.unknown:
    //                print("unknown\(assetExport?.error)")
    //            case AVAssetExportSession.Status.waiting:
    //                print("waiting\(assetExport?.error)")
    //            case AVAssetExportSession.Status.exporting:
    //                print("exporting\(assetExport?.error)")
    //            default:
    //                print("Audio Concatenation Complete")
    //            }
            
            print("------------------")
            PlayerPresenter.shared.player = AVPlayer(url: mergeAudioURL as URL)
            
    //        do {
    //            PlayerPresenter.shared.player = AVPlayer(url: mergeAudioURL)
    //        } catch {
    //            fatalError()
    //        }
        })
    }
}
