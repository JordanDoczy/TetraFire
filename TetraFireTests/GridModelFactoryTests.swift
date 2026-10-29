//
//  GridModelFactoryTests.swift
//  TetraFireTests
//

import Testing
@testable import TetraFire

struct GridModelFactoryTests {

    @Test(arguments: 1 ... Constants.maxLevelFireMode)
    func everyFireLevelHasFire(level: Int) {
        let grid = GridModelFactory.modelForLevel(level)
        #expect(grid.rows == Constants.rows)
        #expect(grid.columns == Constants.columns)
        #expect(grid.hasFire())
    }

    // Levels 11 and 12 intentionally start with a full row; every other level starts with none.
    @Test(arguments: 1 ... Constants.maxLevelFireMode)
    func startingCompletedRows(level: Int) {
        let expected: [Row] = switch level {
        case 11: [13]
        case 12: [16]
        default: []
        }
        #expect(GridModelFactory.modelForLevel(level).getCompletedRows() == expected)
    }

    @Test func levelsOutsideTheRangeAreEmpty() {
        #expect(GridModelFactory.modelForLevel(0).isEmpty())
        #expect(GridModelFactory.modelForLevel(Constants.maxLevelFireMode + 1).isEmpty())
    }

    @Test func emptyModelIsEmpty() {
        #expect(GridModelFactory.emptyModel.isEmpty())
    }

    @Test func explodeAnimationVisitsEveryCellOnce() {
        let indexes = GridModelFactory.indexesForExplodeAnimation
        #expect(indexes.count == Constants.rows * Constants.columns)
        #expect(Set(indexes).count == indexes.count)
    }
}
