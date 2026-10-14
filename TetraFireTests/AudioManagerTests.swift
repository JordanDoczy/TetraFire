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
