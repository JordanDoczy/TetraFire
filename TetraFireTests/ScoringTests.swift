//
//  ScoringTests.swift
//  TetraFireTests
//

import Testing
@testable import TetraFire

struct ScoringTests {

    @Test(arguments: [(0, 10), (1, 100), (2, 250), (3, 500), (4, 1000), (5, 0)])
    func pointsForCompletedRows(rows: Int, points: Int) {
        #expect(GameViewController.getPoints(numberOfCompletedRows: rows) == points)
    }

    @Test(arguments: [(1, 0), (2, 2000), (3, 5000), (4, 9000)])
    func pointsNeededForLevel(level: Int, points: Int) {
        #expect(GameViewController.pointsNeededForLevel(level: level) == points)
    }

    @Test func pointsNeededGrowWithEachLevel() {
        let thresholds = (1 ... Constants.maxLevelClassicMode).map {
            GameViewController.pointsNeededForLevel(level: $0)
        }
        #expect(thresholds == thresholds.sorted())
        #expect(Set(thresholds).count == thresholds.count)
    }
}
