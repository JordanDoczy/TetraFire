//
//  SaveDataTests.swift
//  TetraFireTests
//

import Foundation
import Testing
@testable import TetraFire

struct SaveDataTests {

    private let suiteName = "TetraFireTests.\(UUID().uuidString)"
    private let userData: UserData

    init() {
        userData = UserData(defaults: UserDefaults(suiteName: suiteName)!)
    }

    // MARK: - Round trips through UserData

    @Test func gridModelRoundTrip() {
        let grid = GridModelFactory.modelForLevel(3)
        grid.setValue(.active(color: .pink), at: (row: 0, column: 0))
        grid.setValue(.ghost(color: .pink), at: (row: 1, column: 0))

        userData.gridModel = grid
        let loaded = userData.gridModel

        #expect(loaded.rows == grid.rows)
        #expect(loaded.columns == grid.columns)
        #expect(loaded.blocks == grid.blocks)
    }

    @Test func activePieceRoundTrip() throws {
        let piece = TPiece()
        piece.gridPosition = (row: 7, column: 3)

        userData.activePiece = piece
        let loaded = try #require(userData.activePiece)

        #expect(loaded is TPiece)
        #expect(loaded.color == piece.color)
        #expect(loaded.gridPosition == (row: 7, column: 3))
    }

    @Test func activePieceOrientationRoundTrip() throws {
        let piece = TPiece()
        piece.orientation = .down

        userData.activePiece = piece
        let loaded = try #require(userData.activePiece)

        #expect(loaded.orientation == .down)
        #expect(loaded.gridPositions.map(\.row) == piece.gridPositions.map(\.row))
        #expect(loaded.gridPositions.map(\.column) == piece.gridPositions.map(\.column))
    }

    @Test func heldPieceRoundTrip() throws {
        userData.heldPiece = LinePiece()
        let loaded = try #require(userData.heldPiece)
        #expect(loaded is LinePiece)
    }

    @Test func clearingPiecesRemovesThem() {
        userData.activePiece = JPiece()
        userData.heldPiece = ZPiece()
        userData.activePiece = nil
        userData.heldPiece = nil
        #expect(userData.activePiece == nil)
        #expect(userData.heldPiece == nil)
    }

    @Test func sidePanelRoundTrip() {
        let panel = SidePanelModel()
        userData.sidePanelModel = panel
        let loaded = userData.sidePanelModel

        #expect(loaded.pieces.map(\.color) == panel.pieces.map(\.color))
    }

    @Test func settingsDefaultToOn() {
        #expect(userData.backgroundMusic)
        #expect(userData.soundEffects)
        #expect(userData.vibrate)
        #expect(userData.level == 1)
        #expect(userData.gameMode == .classic)
    }

    @Test func highestLevelOnlyGoesUp() {
        userData.gameMode = .fire
        userData.level = 5
        userData.level = 2
        #expect(userData.highestLevelFireMode == 5)
        #expect(userData.highestLevelClassicMode == 1)
    }

    // MARK: - Saves written by version 1.5
    //
    // Fixtures/*.archive were written by the 1.5 encoder (the format already on players' devices).
    // Any change to the save format must keep these loading.

    private func loadFixture(_ name: String, into key: String) throws {
        let url = try #require(Bundle(for: FixtureBundleToken.self).url(forResource: name, withExtension: "archive"))
        userData.defaults.set(try Data(contentsOf: url), forKey: key)
    }

    @Test func loadsVersion15Grid() throws {
        try loadFixture("GridModel", into: Constants.UserData.GridModel)
        let grid = userData.gridModel

        let expected = GridModelFactory.modelForLevel(3)
        expected.setValue(.active(color: .pink), at: (row: 0, column: 4))
        expected.setValue(.ghost(color: .pink), at: (row: 15, column: 4))
        #expect(grid.blocks == expected.blocks)
    }

    @Test func loadsVersion15ActivePiece() throws {
        try loadFixture("ActivePiece", into: Constants.UserData.ActivePiece)
        let piece = try #require(userData.activePiece)

        #expect(piece is TPiece)
        #expect(piece.color == .yellow)
        #expect(piece.gridPosition == (row: 7, column: 3))
        #expect(piece.orientation == .down)
    }

    @Test func loadsVersion15HeldPiece() throws {
        try loadFixture("HeldPiece", into: Constants.UserData.HeldPiece)
        let piece = try #require(userData.heldPiece)
        #expect(piece is LinePiece)
    }

    @Test func loadsVersion15SidePanel() throws {
        try loadFixture("SidePanelModel", into: Constants.UserData.SidePanelModel)
        let panel = userData.sidePanelModel

        #expect(panel.pieces.count == 6)
        #expect(panel.pieces.map(\.color) == [.purple, .green, .red, .red, .green, .blue])
    }
}

private final class FixtureBundleToken {}

struct SoundChoiceTests {
    private let userData: UserData

    init() {
        let suiteName = "SoundChoiceTests-\(UUID().uuidString)"
        userData = UserData(defaults: UserDefaults(suiteName: suiteName)!)
    }

    @Test func newPlayersAreAsked() {
        #expect(userData.needsSoundChoice)
    }

    @Test func playersWhoSkippedTheTutorialAreNotAsked() {
        userData.skipTutorial = true
        #expect(!userData.needsSoundChoice)
    }

    @Test(arguments: [true, false])
    func choosingSetsMusicAndEffects(on: Bool) {
        userData.chooseSound(on)
        #expect(userData.backgroundMusic == on)
        #expect(userData.soundEffects == on)
        #expect(!userData.needsSoundChoice)
    }
}
