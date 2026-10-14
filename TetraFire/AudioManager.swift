//
//  SoundManager.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/8/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject{
    
    struct Constants {
        static let BGMTimerKey = "BGMTimerKey"
    }
    
    static var shared = AudioManager()
    var players = [String : AVAudioPlayer]()
    var timers = [String : Timer]()
    var interval: Double = 120
    var backgroundMusicIndex: Int = -1 {
        didSet {
            if backgroundMusicIndex == Assets.Sounds.bgm.count {
                backgroundMusicIndex = 0
            }
        }
    }

    internal func adjustVolume(player: AVAudioPlayer, by adjustment: Float, timer: Timer) {
        player.volume += adjustment
        if player.volume >= 1 || player.volume <= 0 {
            timer.invalidate()
            volumeAdjustmentComplete(player: player)
        }
    }
    
    internal func changeMusic() {
        if backgroundMusicIndex >= 0 && backgroundMusicIndex < Assets.Sounds.bgm.count {
            fadeOut(fileName: Assets.Sounds.bgm[backgroundMusicIndex])
        } else {
            nextTrack()
        }
    }
    
    internal func fadeIn(fileName: String) {
        if let player = players[fileName] {
            timers[fileName]?.invalidate()
            timers[fileName] = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                self?.adjustVolume(player: player, by: 0.05, timer: timer)
            }
        }
    }
    
    internal func fadeOut(fileName: String) {
        if let player = players[fileName]{
            timers[fileName]?.invalidate()
            timers[fileName] = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                self?.adjustVolume(player: player, by: -0.05, timer: timer)
            }
        }
    }
    
    internal func nextTrack() {
        backgroundMusicIndex += 1
        let fileName = Assets.Sounds.bgm[backgroundMusicIndex]
        playAudio(fileName: fileName, loop: -1, fadeIn: true)
    }

    internal func playAudio(fileName: String, loop: Int = 0, fadeIn: Bool = false) {
        if let player = players[fileName] {
            if !player.isPlaying {
                player.numberOfLoops = loop
                player.play()
                player.volume = fadeIn ? 0 : 1
                if fadeIn {
                    self.fadeIn(fileName: fileName)
                }
            }
        } else if let url = Bundle.main.url(forResource: fileName, withExtension: nil) {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: url.pathExtension)
                audioPlayer.prepareToPlay()
                players[fileName] = audioPlayer
                playAudio(fileName: fileName, loop: loop, fadeIn: fadeIn)
            } catch let error {
                print(error)
            }
        }
    }
    
    // Ambient follows the silent switch and mixes with audio from other apps instead of stopping it.
    func configureSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
        } catch {
            print(error)
        }
    }

    func playBackgroundMusic() {
        if UserData.shared.backgroundMusic {
            
            let isValid = timers[Constants.BGMTimerKey]?.isValid ?? false
            
            if !isValid {
                timers[Constants.BGMTimerKey] = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                    self?.changeMusic()
                }
                changeMusic()
            }
        } else {
            stopBackgroundMusic()
        }
    }
    
    func playSound(fileName: String){
        if UserData.shared.soundEffects {
            playAudio(fileName: fileName)
        }
    }

    func stopAudio(fileName: String){
        players[fileName]?.stop()
    }
    
    func stopBackgroundMusic() {
        timers[Constants.BGMTimerKey]?.invalidate()
        
        if 0 ..< Assets.Sounds.bgm.count ~= backgroundMusicIndex {
            stopAudio(fileName: Assets.Sounds.bgm[backgroundMusicIndex])
        }
    }
    
    internal func volumeAdjustmentComplete(player: AVAudioPlayer) {
        if player.volume <= 0 {
            player.stop()
            if let timer = timers[Constants.BGMTimerKey], timer.isValid {
                nextTrack()
            }
        }
    }
    
}
