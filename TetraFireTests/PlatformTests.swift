//
//  PlatformTests.swift
//  TetraFireTests
//

import AVFoundation
import Testing
import UIKit
@testable import TetraFire

@MainActor
struct PlatformTests {

    private func gameViewController() async throws -> GameViewController {
        let windowScene = try #require(UIApplication.shared.connectedScenes.first as? UIWindowScene)
        let controller = try #require(windowScene.keyWindow?.rootViewController as? GameViewController)
        // Subviews are added in viewIsAppearing, which may not have run yet when tests start.
        for _ in 0 ..< 50 where !controller.didAddSubviews {
            try await Task.sleep(for: .milliseconds(100))
        }
        try #require(controller.didAddSubviews)
        return controller
    }

    @Test func gameViewsStayInsideTheSafeArea() async throws {
        let controller = try await gameViewController()
        let safeFrame = controller.safeFrame
        #expect(safeFrame.contains(controller.gridView.frame))
        #expect(safeFrame.contains(controller.sidePanelView.frame))
        #expect(safeFrame.contains(controller.holdView.frame))
        #expect(safeFrame.contains(controller.menuView.frame))
    }

    @Test func gridDoesNotOverlapTheHoldViewOrSidePanel() async throws {
        let controller = try await gameViewController()
        #expect(!controller.gridView.frame.intersects(controller.holdView.frame))
        #expect(!controller.gridView.frame.intersects(controller.sidePanelView.frame))
    }

    @Test func audioSessionFollowsTheSilentSwitch() {
        AudioManager.shared.configureSession()
        #expect(AVAudioSession.sharedInstance().category == .ambient)
    }
}
