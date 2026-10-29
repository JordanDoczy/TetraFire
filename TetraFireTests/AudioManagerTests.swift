//
//  AudioManagerTests.swift
//  TetraFireTests
//

import AVFoundation
import Testing
@testable import TetraFire

struct AudioManagerTests {

    private func managerWithPlayer(volume: Float) throws -> (AudioManager, AVAudioPlayer) {
        let fileName = Assets.Sounds.click
        let url = try #require(Bundle.main.url(forResource: fileName, withExtension: nil))
        let player = try AVAudioPlayer(contentsOf: url)
        player.volume = volume
        let manager = AudioManager()
        manager.players[fileName] = player
        return (manager, player)
    }

    @Test func fadeInRaisesVolumeToFull() async throws {
        let (manager, player) = try managerWithPlayer(volume: 0)
        manager.fadeIn(fileName: Assets.Sounds.click)
        await manager.fadeTasks[Assets.Sounds.click]?.value
        #expect(player.volume >= 1)
    }

    @Test func fadeOutLowersVolumeToZero() async throws {
        let (manager, player) = try managerWithPlayer(volume: 1)
        manager.fadeOut(fileName: Assets.Sounds.click)
        await manager.fadeTasks[Assets.Sounds.click]?.value
        #expect(player.volume <= 0)
    }

    @Test func newFadeCancelsThePreviousOne() async throws {
        let (manager, player) = try managerWithPlayer(volume: 0.5)
        manager.fadeIn(fileName: Assets.Sounds.click)
        let first = try #require(manager.fadeTasks[Assets.Sounds.click])
        manager.fadeOut(fileName: Assets.Sounds.click)
        #expect(first.isCancelled)
        await manager.fadeTasks[Assets.Sounds.click]?.value
        #expect(player.volume <= 0)
    }

    @Test func stoppingBackgroundMusicCancelsTheTrackChanger() {
        let manager = AudioManager()
        manager.musicTask = Task {}
        let task = manager.musicTask
        manager.stopBackgroundMusic()
        #expect(task?.isCancelled == true)
        #expect(manager.musicTask == nil)
    }
}

struct BackgroundAudioTests {

    private func managerPlaying(_ fileName: String) throws -> (AudioManager, AVAudioPlayer) {
        let url = try #require(Bundle.main.url(forResource: fileName, withExtension: nil))
        let player = try AVAudioPlayer(contentsOf: url)
        player.volume = 0
        player.play()
        let manager = AudioManager()
        manager.players[fileName] = player
        return (manager, player)
    }

    @Test func pauseStopsMusicAndTheTrackChanger() throws {
        let fileName = Assets.Sounds.bgm[0]
        let (manager, player) = try managerPlaying(fileName)
        player.currentTime = 1
        manager.backgroundMusicIndex = 0
        manager.musicTask = Task {}
        let task = manager.musicTask
        manager.fadeIn(fileName: fileName)
        let fade = manager.fadeTasks[fileName]

        manager.pause()

        #expect(!player.isPlaying)
        #expect(player.currentTime >= 1, "music should pause, not rewind")
        #expect(task?.isCancelled == true)
        #expect(manager.musicTask == nil)
        #expect(fade?.isCancelled == true)
    }

    @Test func pauseRewindsSoundEffects() throws {
        let (manager, player) = try managerPlaying(Assets.Sounds.click)
        manager.pause()
        #expect(!player.isPlaying)
        #expect(player.currentTime == 0)
    }
}
