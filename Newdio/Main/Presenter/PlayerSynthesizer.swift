//
//  PlayerSynthesizer.swift
//  Newdio
//
//  Created by najin on 2022/01/06.
//

import Foundation
import AVFAudio

///내장 TTS 이용한 음성 컨트롤 클래스
class PlayerSynthesizer: AVSpeechSynthesizer {
    
    static let shared = PlayerSynthesizer()
    
    override init() {
    }
    
    func playVoice(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        
        if "ko" == UserDefaults.standard.string(forKey: "language") {
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "eb-US")
        }
        
        speak(utterance)
    }
    
    func pauseVoice() {
        if self.isSpeaking {
            self.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
}
