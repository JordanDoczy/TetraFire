//
//  GridModelTests.swift
//  TetraFireTests
//

import Testing
@testable import TetraFire

struct GridModelTests {

    private func makeGrid() -> GridModel {
        GridModel(rows: Constants.rows, columns: Constants.columns)
    }

    private func fill(row: Row, in grid: GridModel, except skipped: Set<Column> = []) {
        for column in 0 ..< grid.columns where !skipped.contains(column) {
            grid.setValue(.inactive(color: .red), at: (row: row, column: column))
        }
    }

    // MARK: - Basics

    @Test func newGridIsEmpty() {
        let grid = makeGrid()
        #expect(grid.count == Constants.rows * Constants.columns)
        #expect(grid.isEmpty())
        #expect(grid.getFirstNonEmptyIndex() == nil)
    }

    @Test func indexAndRowMapping() {
        let grid = makeGrid()
        #expect(grid.getIndex(at: (row: 0, column: 0)) == 0)
        #expect(grid.getIndex(at: (row: 1, column: 0)) == Constants.columns)
        #expect(grid.getIndex(at: (row: 19, column: 9)) == grid.count - 1)
        #expect(grid.getRow(index: Constants.columns * 3 + 4) == 3)
    }

    @Test func setValueOutOfBoundsIsIgnored() {
        let grid = makeGrid()
        grid.setValue(.inactive(color: .red), at: -1)
        grid.setValue(.inactive(color: .red), at: grid.count)
        #expect(grid.isEmpty())
        #expect(grid.value(at: (row: Constants.rows, column: 0)) == nil)
    }

    // MARK: - Empty vs. occupied

    @Test(arguments: [
        BlockType.active(color: .red),
        BlockType.ghost(color: .red),
        BlockType.effect(effect: .smoke),
    ])
    func blocksThatDoNotOccupyACell(block: BlockType) {
        let grid = makeGrid()
        #expect(grid.isEmptyElement(block))
        #expect(!grid.isValidElement(block))
    }

    @Test func inactiveAndFireBlocksOccupyACell() {
        let grid = makeGrid()
        #expect(!grid.isEmptyElement(.inactive(color: .red)))
        #expect(!grid.isEmptyElement(.effect(effect: .fire)))
        // Fire blocks moves but does not count toward completing a row.
        #expect(grid.isValidElement(.inactive(color: .red)))
        #expect(!grid.isValidElement(.effect(effect: .fire)))
    }

    // MARK: - Moves

    @Test func validMoveOnEmptyGrid() {
        let grid = makeGrid()
        #expect(grid.isValidMove(gridPositions: [(row: 0, column: 0), (row: 0, column: 1)]))
    }

    @Test func moveWithNoPositionsIsInvalid() {
        #expect(!makeGrid().isValidMove(gridPositions: []))
    }

    @Test func moveOffTheGridIsInvalid() {
        let grid = makeGrid()
        #expect(!grid.isValidMove(gridPositions: [(row: -1, column: 0)]))
        #expect(!grid.isValidMove(gridPositions: [(row: Constants.rows, column: 0)]))
    }

    @Test func moveThatWrapsToAnotherRowIsInvalid() {
        let grid = makeGrid()
        #expect(!grid.isValidMove(gridPositions: [(row: 5, column: Constants.columns)]))
        #expect(!grid.isValidMove(gridPositions: [(row: 5, column: -1)]))
    }

    @Test func moveIntoOccupiedCellIsInvalid() {
        let grid = makeGrid()
        grid.setValue(.inactive(color: .blue), at: (row: 10, column: 3))
        #expect(!grid.isValidMove(gridPositions: [(row: 10, column: 3)]))

        grid.setValue(.effect(effect: .fire), at: (row: 11, column: 3))
        #expect(!grid.isValidMove(gridPositions: [(row: 11, column: 3)]))
    }

    @Test func highestOpenPositionDropsToTheFloor() {
        let grid = makeGrid()
        let dropped = grid.getHighestOpenPosition(positions: [(row: 0, column: 4), (row: 1, column: 4)])
        #expect(dropped.map(\.row) == [18, 19])
        #expect(dropped.map(\.column) == [4, 4])
    }

    @Test func highestOpenPositionStopsOnABlock() {
        let grid = makeGrid()
        grid.setValue(.inactive(color: .blue), at: (row: 15, column: 4))
        let dropped = grid.getHighestOpenPosition(positions: [(row: 0, column: 4)])
        #expect(dropped.map(\.row) == [14])
    }

    // MARK: - Line clears

    @Test func completedRowsIgnorePartialRows() {
        let grid = makeGrid()
        fill(row: 19, in: grid)
        fill(row: 18, in: grid, except: [0])
        #expect(grid.getCompletedRows() == [19])
    }

    @Test func rowWithFireIsNotComplete() {
        let grid = makeGrid()
        fill(row: 19, in: grid, except: [5])
        grid.setValue(.effect(effect: .fire), at: (row: 19, column: 5))
        #expect(grid.getCompletedRows().isEmpty)
    }

    @Test func clearRowEmptiesIt() {
        let grid = makeGrid()
        fill(row: 19, in: grid)
        grid.clearRow(row: 19)
        #expect(grid.isEmpty())
    }

    @Test func dropRowsMovesBlocksDown() {
        let grid = makeGrid()
        fill(row: 19, in: grid)
        grid.setValue(.inactive(color: .green), at: (row: 18, column: 2))

        grid.clearRow(row: 19)
        grid.dropRows(rows: [19])

        #expect(grid.value(at: (row: 19, column: 2)) == .inactive(color: .green))
        #expect(grid.value(at: (row: 18, column: 2)) == nil)
    }

    @Test func dropRowsLeavesFireInPlace() {
        let grid = makeGrid()
        fill(row: 19, in: grid)
        grid.setValue(.effect(effect: .fire), at: (row: 17, column: 6))

        grid.clearRow(row: 19)
        grid.dropRows(rows: [19])

        #expect(grid.value(at: (row: 17, column: 6)) == .effect(effect: .fire))
        #expect(grid.value(at: (row: 18, column: 6)) == nil)
    }

    // MARK: - Fire

    @Test func hasFire() {
        let grid = makeGrid()
        #expect(!grid.hasFire())
        grid.setValue(.effect(effect: .fire), at: (row: 12, column: 0))
        #expect(grid.hasFire())
        #expect(grid.hasFire(atRow: 12))
        #expect(!grid.hasFire(atRow: 11))
    }

    @Test func clearingARowPutsOutFireDirectlyBelowIt() {
        let grid = makeGrid()
        grid.setValue(.effect(effect: .fire), at: (row: 19, column: 3))
        grid.setValue(.effect(effect: .fire), at: (row: 19, column: 7))

        let rowsOfFire = grid.removeFire(fromRows: [18])

        #expect(rowsOfFire == [19, 19])
        #expect(!grid.hasFire())
    }

    @Test func clearingTheBottomRowPutsOutNoFire() {
        let grid = makeGrid()
        grid.setValue(.effect(effect: .fire), at: (row: 19, column: 3))
        #expect(grid.removeFire(fromRows: [19]).isEmpty)
        #expect(grid.hasFire())
    }

    @Test func removeActiveAndGhostBlocksKeepsSettledBlocks() {
        let grid = makeGrid()
        grid.setValue(.active(color: .red), at: 0)
        grid.setValue(.ghost(color: .red), at: 1)
        grid.setValue(.inactive(color: .red), at: 2)
        grid.setValue(.effect(effect: .fire), at: 3)

        grid.removeActiveAndGhostBlocks()

        #expect(grid[0] == nil)
        #expect(grid[1] == nil)
        #expect(grid[2] == .inactive(color: .red))
        #expect(grid[3] == .effect(effect: .fire))
    }
}
