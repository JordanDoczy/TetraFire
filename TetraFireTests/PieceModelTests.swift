//
//  PieceModelTests.swift
//  TetraFireTests
//

import Testing
@testable import TetraFire

struct PieceModelTests {

    nonisolated static let allPieces: [@MainActor @Sendable () -> PieceModel] = [
        { JPiece() }, { LPiece() }, { LinePiece() }, { SPiece() },
        { SquarePiece() }, { TPiece() }, { ZPiece() },
    ]

    @Test(arguments: 0 ..< allPieces.count)
    func everyOrientationHasFourBlocks(pieceIndex: Int) {
        let piece = Self.allPieces[pieceIndex]()
        for orientation in [Orientation.up, .down, .left, .right] {
            #expect(piece.getGridPositions(at: (row: 0, column: 0), for: orientation).count == 4)
        }
    }

    @Test func everyPieceHasADifferentColor() {
        let colors = Set(Self.allPieces.map { $0().color })
        #expect(colors.count == Self.allPieces.count)
    }

    @Test func newPieceStartsFacingLeftAtTheOrigin() {
        let piece = TPiece()
        #expect(piece.orientation == .left)
        #expect(piece.gridPosition == (row: 0, column: 0))
    }

    @Test func gridPositionsAreOffsetByThePiecePosition() {
        let piece = SquarePiece()
        piece.gridPosition = (row: 5, column: 3)
        let rows = piece.gridPositions.map(\.row).sorted()
        let columns = piece.gridPositions.map(\.column).sorted()
        #expect(rows == [5, 5, 6, 6])
        #expect(columns == [3, 3, 4, 4])
    }

    @Test func rotatingForwardCyclesThroughAllOrientations() {
        let piece = LPiece()
        var seen = [piece.orientation]
        for _ in 0 ..< 4 {
            piece.rotate()
            seen.append(piece.orientation)
        }
        #expect(seen == [.left, .up, .right, .down, .left])
    }

    @Test(arguments: [Orientation.up, .down, .left, .right])
    func rotatingBackwardUndoesRotatingForward(start: Orientation) {
        let piece = JPiece()
        piece.orientation = start
        piece.rotate(direction: .forward)
        piece.rotate(direction: .backward)
        #expect(piece.orientation == start)
    }

    @Test func randomPieceIsAlwaysAValidPiece() {
        let validColors = Set(Self.allPieces.map { $0().color })
        for _ in 0 ..< 200 {
            #expect(validColors.contains(PieceModel.random().color))
        }
    }
}
