//
//  SoundManager.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/8/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject{
    
    static var shared = AudioManager()
    var players = [String : AVAudioPlayer]()
    var fadeTasks = [String : Task<Void, Never>]()
    var musicTask: Task<Void, Never>?
    var interval: Duration = .seconds(120)
    var backgroundMusicIndex: Int = -1 {
        didSet {
            if backgroundMusicIndex == Assets.Sounds.bgm.count {
                backgroundMusicIndex = 0
            }
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
        fade(fileName: fileName, by: 0.05)
    }
    
    internal func fadeOut(fileName: String) {
        fade(fileName: fileName, by: -0.05)
    }

    // Steps the volume every 0.1s until it reaches 0 or 1. Starting a new fade cancels the old one.
    internal func fade(fileName: String, by adjustment: Float) {
        guard let player = players[fileName] else { return }
        fadeTasks[fileName]?.cancel()
        fadeTasks[fileName] = Task { [weak self] in
            while (try? await Task.sleep(for: .milliseconds(100))) != nil {
                player.volume += adjustment
                if player.volume >= 1 || player.volume <= 0 {
                    self?.volumeAdjustmentComplete(player: player)
                    return
                }
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
            
            if musicTask == nil {
                startTrackChanger()
                changeMusic()
            }
        } else {
            stopBackgroundMusic()
        }
    }

    internal func startTrackChanger() {
        musicTask = Task { [weak self, interval] in
            while (try? await Task.sleep(for: interval)) != nil {
                self?.changeMusic()
            }
        }
    }

    // Called when the app goes to the background. Music pauses so the track picks up
    // where it left off.
    func pause() {
        musicTask?.cancel()
        musicTask = nil
        for task in fadeTasks.values {
            task.cancel()
        }
        fadeTasks.removeAll()
        for (fileName, player) in players where player.isPlaying {
            // Sound effects stop so they don't resume mid-sound the next time they play.
            Assets.Sounds.bgm.contains(fileName) ? player.pause() : player.stop()
        }
    }

    func resume() {
        guard UserData.shared.backgroundMusic, !UserData.shared.needsSoundChoice, musicTask == nil else { return }
        guard 0 ..< Assets.Sounds.bgm.count ~= backgroundMusicIndex,
              let player = players[Assets.Sounds.bgm[backgroundMusicIndex]] else {
            playBackgroundMusic()
            return
        }
        // A fade may have been cut off by pause().
        player.volume = 1
        player.play()
        startTrackChanger()
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
        musicTask?.cancel()
        musicTask = nil
        
        if 0 ..< Assets.Sounds.bgm.count ~= backgroundMusicIndex {
            stopAudio(fileName: Assets.Sounds.bgm[backgroundMusicIndex])
        }
    }
    
    internal func volumeAdjustmentComplete(player: AVAudioPlayer) {
        if player.volume <= 0 {
            player.stop()
            if musicTask != nil {
                nextTrack()
            }
        }
    }
    
}
