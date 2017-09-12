//
//  LevelFactory.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/29/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import Foundation

class GridModelFactory {
    
    static var emptyModel: GridModel {
        return GridModel(rows: Constants.rows, columns: Constants.columns)
    }
    
    static var iconModel: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)

        model.setValue(.effect(effect: .fire), at: (row: 14, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 1))
        model.setValue(.inactive(color: .red),   at: (row: 15, column: 3)) //
        model.setValue(.inactive(color: .red),   at: (row: 15, column: 4)) //
        model.setValue(.inactive(color: .red),   at: (row: 15, column: 5)) //
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 1))
        model.setValue(.inactive(color: .red),   at: (row: 16, column: 4)) //
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 1))
        model.setValue(.inactive(color: .red),   at: (row: 17, column: 4)) //
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 7))

        return model
    }
    
    static func modelForLevel(_ level: Int) -> GridModel {
        switch(level) {
        case 1: return GridModelFactory.level1
        case 2: return GridModelFactory.level2
        case 3: return GridModelFactory.level3
        case 4: return GridModelFactory.level4
        case 5: return GridModelFactory.level5
        case 6: return GridModelFactory.level6
        case 7: return GridModelFactory.level7
        case 8: return GridModelFactory.level8
        case 9: return GridModelFactory.level9
        case 10: return GridModelFactory.level10
        case 11: return GridModelFactory.level11
        case 12: return GridModelFactory.level12
        case 13: return GridModelFactory.level13
        case 14: return GridModelFactory.level14
        case 15: return GridModelFactory.level15
        default: return GridModel(rows: Constants.rows, columns: Constants.columns)
        }
    }
    
    static var indexesForExplodeAnimation: [Int] {
        var indicies = [Int]()
        let model = GridModelFactory.emptyModel
        
        for index in 0 ..< model.count {
            indicies.append(model.count - 1 - index)
        }
        
        return indicies
    }
    
    static var indexesForExplodeAnimation2: [Int] {
        var indicies = [Int]()
        let model = GridModelFactory.emptyModel
        
        let startRow = 10
        let startColumn = 4

        var direction = true
        var loopCount = 1
        var column = startColumn
        var row = startRow
        var horizontalMove = true
        
        indicies.append(model.getIndex(at: (row: row, column: column)))
        
        var cycle = 0
        while indicies.count < 90 {
            
            if cycle.isOdd() {
                direction = !direction
            } else if cycle.isEven() {
                loopCount += 1
            }

            for _ in 0..<loopCount {
                if horizontalMove {
                    column = direction ? column + 1 : column - 1
                } else {
                    row = direction ? row + 1 : row - 1
                }
                indicies.append(model.getIndex(at: (row: row, column: column)))
            }
            horizontalMove = !horizontalMove
            cycle += 1
        }
        
        for index in 0 ..< 50 {
            indicies.append(59 - index)
            indicies.append(150 + index)
        }
        
        for index in 0 ... 9 {
            indicies.append(9 - index)
        }

        return indicies
    }
    
    static var indexesForYouWinAnimation: [Int] {
        var indicies = [Int]()
        let model = GridModelFactory.emptyModel
        
        // Y
        indicies.append(model.getIndex(at: (row: 5, column: 0)))
        
        indicies.append(model.getIndex(at: (row: 5, column: 0)))
        indicies.append(model.getIndex(at: (row: 6, column: 0)))
        indicies.append(model.getIndex(at: (row: 7, column: 1)))
        indicies.append(model.getIndex(at: (row: 8, column: 1)))
        indicies.append(model.getIndex(at: (row: 9, column: 1)))
        indicies.append(model.getIndex(at: (row: 5, column: 2)))
        indicies.append(model.getIndex(at: (row: 6, column: 2)))
        
        //O
        indicies.append(model.getIndex(at: (row: 6, column: 3)))
        indicies.append(model.getIndex(at: (row: 7, column: 3)))
        indicies.append(model.getIndex(at: (row: 6, column: 4)))
        indicies.append(model.getIndex(at: (row: 8, column: 3)))
        indicies.append(model.getIndex(at: (row: 6, column: 5)))
        indicies.append(model.getIndex(at: (row: 9, column: 3)))
        indicies.append(model.getIndex(at: (row: 7, column: 5)))
        indicies.append(model.getIndex(at: (row: 9, column: 4)))
        indicies.append(model.getIndex(at: (row: 8, column: 5)))
        indicies.append(model.getIndex(at: (row: 9, column: 5)))
        
        //U
        indicies.append(model.getIndex(at: (row: 6, column: 6)))
        indicies.append(model.getIndex(at: (row: 7, column: 6)))
        indicies.append(model.getIndex(at: (row: 8, column: 6)))
        indicies.append(model.getIndex(at: (row: 9, column: 6)))
        indicies.append(model.getIndex(at: (row: 9, column: 7)))
        indicies.append(model.getIndex(at: (row: 9, column: 8)))
        indicies.append(model.getIndex(at: (row: 8, column: 8)))
        indicies.append(model.getIndex(at: (row: 7, column: 8)))
        indicies.append(model.getIndex(at: (row: 6, column: 8)))
        indicies.append(model.getIndex(at: (row: 9, column: 9)))
        
        //W
        indicies.append(model.getIndex(at: (row: 11, column: 0)))
        indicies.append(model.getIndex(at: (row: 12, column: 0)))
        indicies.append(model.getIndex(at: (row: 13, column: 0)))
        indicies.append(model.getIndex(at: (row: 14, column: 0)))
        indicies.append(model.getIndex(at: (row: 15, column: 0)))
        indicies.append(model.getIndex(at: (row: 14, column: 1)))
        indicies.append(model.getIndex(at: (row: 15, column: 2)))
        indicies.append(model.getIndex(at: (row: 15, column: 3)))
        indicies.append(model.getIndex(at: (row: 14, column: 3)))
        indicies.append(model.getIndex(at: (row: 13, column: 3)))
        indicies.append(model.getIndex(at: (row: 12, column: 3)))
        indicies.append(model.getIndex(at: (row: 11, column: 3)))
        indicies.append(model.getIndex(at: (row: 13, column: 1)))
        
        //I
        indicies.append(model.getIndex(at: (row: 13, column: 5)))
        indicies.append(model.getIndex(at: (row: 14, column: 5)))
        indicies.append(model.getIndex(at: (row: 15, column: 5)))

        //N
        indicies.append(model.getIndex(at: (row: 12, column: 7)))
        indicies.append(model.getIndex(at: (row: 13, column: 7)))
        indicies.append(model.getIndex(at: (row: 12, column: 8)))
        indicies.append(model.getIndex(at: (row: 14, column: 7)))
        indicies.append(model.getIndex(at: (row: 12, column: 9)))
        indicies.append(model.getIndex(at: (row: 15, column: 7)))
        indicies.append(model.getIndex(at: (row: 13, column: 9)))
        indicies.append(model.getIndex(at: (row: 14, column: 9)))
        indicies.append(model.getIndex(at: (row: 15, column: 9)))

        //Dot the i
        indicies.append(model.getIndex(at: (row: 11, column: 5)))
        
        return indicies
    }
}

extension GridModelFactory {
    static var level1: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 4))
        return model
    }
    
    static var level2: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 4))
        return model
    }
    
    static var level3: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 2))
        model.setValue(.inactive(color: .red), at: (row: 17, column: 1))
        model.setValue(.inactive(color: .orange), at: (row: 17, column: 2))
        model.setValue(.inactive(color: .orange), at: (row: 16, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 16, column: 2))
        
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 7))
        model.setValue(.inactive(color: .blue), at: (row: 17, column: 8))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 7))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 8))
        model.setValue(.inactive(color: .blue), at: (row: 16, column: 7))
        return model
    }
    
    static var level4: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 9))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 9))
        
        model.setValue(.inactive(color: .red), at: (row: 19, column: 6))
        model.setValue(.inactive(color: .red), at: (row: 18, column: 7))
        model.setValue(.inactive(color: .red), at: (row: 17, column: 8))
        model.setValue(.inactive(color: .red), at: (row: 16, column: 9))
        
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 0))
        
        model.setValue(.inactive(color: .red), at: (row: 19, column: 3))
        model.setValue(.inactive(color: .red), at: (row: 18, column: 2))
        model.setValue(.inactive(color: .red), at: (row: 17, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 16, column: 0))
        return model
    }

    static var level5: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.inactive(color: .blue), at: (row: 19, column: 6))
        model.setValue(.inactive(color: .blue), at: (row: 19, column: 7))
        model.setValue(.inactive(color: .blue), at: (row: 19, column: 8))
        model.setValue(.inactive(color: .blue), at: (row: 18, column: 6))
        model.setValue(.inactive(color: .blue), at: (row: 18, column: 8))
        model.setValue(.inactive(color: .blue), at: (row: 17, column: 6))
        model.setValue(.inactive(color: .blue), at: (row: 17, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 7))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 8))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 7))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 6))
        model.setValue(.inactive(color: .blue), at: (row: 16, column: 6))
        model.setValue(.inactive(color: .blue), at: (row: 16, column: 8))
        
        model.setValue(.inactive(color: .blue), at: (row: 19, column: 1))
        model.setValue(.inactive(color: .blue), at: (row: 19, column: 2))
        model.setValue(.inactive(color: .blue), at: (row: 19, column: 3))
        model.setValue(.inactive(color: .blue), at: (row: 18, column: 1))
        model.setValue(.inactive(color: .blue), at: (row: 18, column: 3))
        model.setValue(.inactive(color: .blue), at: (row: 17, column: 1))
        model.setValue(.inactive(color: .blue), at: (row: 17, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 2))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 3))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 2))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 1))
        model.setValue(.inactive(color: .blue), at: (row: 16, column: 1))
        model.setValue(.inactive(color: .blue), at: (row: 16, column: 3))
        return model
    }
    
    static var level6: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 9))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 9))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 9))
        
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 6))
        return model
    }

    static var level7: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.inactive(color: .red), at: (row: 19, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 19, column: 2))
        model.setValue(.inactive(color: .orange), at: (row: 18, column: 2))
        model.setValue(.inactive(color: .orange), at: (row: 18, column: 3))
        model.setValue(.inactive(color: .yellow), at: (row: 17, column: 3))
        model.setValue(.inactive(color: .yellow), at: (row: 17, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 5))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 5))
        model.setValue(.inactive(color: .blue), at: (row: 15, column: 6))
        model.setValue(.inactive(color: .purple), at: (row: 14, column: 6))
        model.setValue(.inactive(color: .purple), at: (row: 14, column: 7))
        model.setValue(.inactive(color: .pink), at: (row: 13, column: 7))
        model.setValue(.inactive(color: .pink), at: (row: 13, column: 8))
        
        model.setValue(.inactive(color: .red), at: (row: 13, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 2))
        model.setValue(.inactive(color: .orange), at: (row: 14, column: 2))
        model.setValue(.inactive(color: .orange), at: (row: 14, column: 3))
        model.setValue(.inactive(color: .yellow), at: (row: 15, column: 3))
        model.setValue(.inactive(color: .yellow), at: (row: 15, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 5))
        model.setValue(.inactive(color: .blue), at: (row: 17, column: 5))
        model.setValue(.inactive(color: .blue), at: (row: 17, column: 6))
        model.setValue(.inactive(color: .purple), at: (row: 18, column: 6))
        model.setValue(.inactive(color: .purple), at: (row: 18, column: 7))
        model.setValue(.inactive(color: .pink), at: (row: 19, column: 7))
        model.setValue(.inactive(color: .pink), at: (row: 19, column: 8))
        
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 6))
        return model
    }
    
    static var level8: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValues([BlockType](repeating: .effect(effect: .fire), count: 6), at: 5)
        model.setValue(.inactive(color: .red), at: (row: 8, column: 9))
        model.setValue(.inactive(color: .red), at: (row: 8, column: 8))
        model.setValue(.inactive(color: .red), at: (row: 8, column: 7))
        return model
    }
    
    static var level9: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.inactive(color: .green), at: (row: 14, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 15, column: 3))
        model.setValue(.inactive(color: .green), at: (row: 15, column: 5))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 6))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 3))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 5))
        model.setValue(.inactive(color: .green), at: (row: 18, column: 4))
        
        model.setValue(.inactive(color: .orange), at: (row: 12, column: 7))
        model.setValue(.inactive(color: .orange), at: (row: 13, column: 6))
        model.setValue(.inactive(color: .orange), at: (row: 13, column: 8))
        model.setValue(.inactive(color: .orange), at: (row: 14, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 7))
        model.setValue(.inactive(color: .orange), at: (row: 14, column: 9))
        model.setValue(.inactive(color: .orange), at: (row: 15, column: 6))
        model.setValue(.inactive(color: .orange), at: (row: 15, column: 8))
        model.setValue(.inactive(color: .orange), at: (row: 16, column: 7))
        
        model.setValue(.inactive(color: .red), at: (row: 11, column: 2))
        model.setValue(.inactive(color: .red), at: (row: 12, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 12, column: 3))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 2))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 4))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 3))
        model.setValue(.inactive(color: .red), at: (row: 15, column: 2))
        
        model.setValue(.inactive(color: .blue), at: (row: 10, column: 4))
        model.setValue(.inactive(color: .blue), at: (row: 11, column: 3))
        model.setValue(.inactive(color: .blue), at: (row: 12, column: 4))
        model.setValue(.inactive(color: .blue), at: (row: 13, column: 5))
        model.setValue(.inactive(color: .blue), at: (row: 12, column: 6))
        model.setValue(.inactive(color: .blue), at: (row: 11, column: 7))
        model.setValue(.inactive(color: .blue), at: (row: 10, column: 6))
        model.setValue(.inactive(color: .blue), at: (row: 9, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 11, column: 5))
        return model
    }
    
    static var level10: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 6))
        
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 8))
        return model
    }
    
    static var level11: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 9))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 17, column: 7))
        
        model.setValue(.inactive(color: .red), at: (row: 15, column: 2))
        model.setValue(.inactive(color: .red), at: (row: 15, column: 7))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 2))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 3))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 6))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 7))
        model.setValue(.inactive(color: .red), at: (row: 14, column: 8))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 0))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 1))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 2))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 3))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 4))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 5))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 6))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 7))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 8))
        model.setValue(.inactive(color: .red), at: (row: 13, column: 9))
        return model
    }

    static var level12: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.inactive(color: .green), at: (row: 18, column: 0))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 0))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 0))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 1))
        model.setValue(.inactive(color: .green), at: (row: 15, column: 1))
        model.setValue(.inactive(color: .green), at: (row: 18, column: 2))
        model.setValue(.inactive(color: .green), at: (row: 18, column: 2))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 2))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 2))
        model.setValue(.inactive(color: .green), at: (row: 15, column: 2))
        model.setValue(.inactive(color: .green), at: (row: 14, column: 2))
        
        model.setValue(.inactive(color: .green), at: (row: 14, column: 3))
        model.setValue(.inactive(color: .green), at: (row: 14, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 14, column: 5))
        model.setValue(.inactive(color: .green), at: (row: 14, column: 6))
        model.setValue(.inactive(color: .green), at: (row: 14, column: 7))
        model.setValue(.inactive(color: .green), at: (row: 15, column: 7))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 7))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 7))
        model.setValue(.inactive(color: .green), at: (row: 18, column: 7))
        
        model.setValue(.inactive(color: .green), at: (row: 15, column: 8))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 8))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 9))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 9))
        model.setValue(.inactive(color: .green), at: (row: 18, column: 9))
        
        model.setValue(.inactive(color: .green), at: (row: 19, column: 3))
        model.setValue(.inactive(color: .green), at: (row: 19, column: 6))
        
        model.setValue(.inactive(color: .green), at: (row: 17, column: 3))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 5))
        model.setValue(.inactive(color: .green), at: (row: 17, column: 6))
        
        model.setValue(.inactive(color: .green), at: (row: 16, column: 3))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 5))
        model.setValue(.inactive(color: .green), at: (row: 16, column: 6))
        
        model.setValue(.inactive(color: .green), at: (row: 15, column: 4))
        model.setValue(.inactive(color: .green), at: (row: 15, column: 5))
        
        model.setValue(.inactive(color: .green), at: (row: 12, column: 2))
        model.setValue(.inactive(color: .green), at: (row: 12, column: 7))
        
        model.setValue(.inactive(color: .green), at: (row: 13, column: 3))
        model.setValue(.inactive(color: .green), at: (row: 13, column: 6))
        
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 6))
        return model
    }
    
    static var level13: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 19, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 18, column: 7))
        
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 15, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 15, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 14, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 14, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 13, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 13, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 12, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 12, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 11, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 11, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 10, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 10, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 9, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 9, column: 5))
        
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 2))
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 7))
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 15, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 15, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 14, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 14, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 13, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 13, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 12, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 12, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 11, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 11, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 10, column: 3))
        model.setValue(.inactive(color: .pink), at: (row: 10, column: 6))
        model.setValue(.inactive(color: .pink), at: (row: 8, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 8, column: 5))
        model.setValue(.inactive(color: .pink), at: (row: 7, column: 4))
        model.setValue(.inactive(color: .pink), at: (row: 7, column: 5))
        
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 0))
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 1))
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 1))
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 2))
        model.setValue(.inactive(color: .pink), at: (row: 15, column: 2))
        model.setValue(.inactive(color: .pink), at: (row: 14, column: 2))
        
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 9))
        model.setValue(.inactive(color: .pink), at: (row: 17, column: 8))
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 8))
        model.setValue(.inactive(color: .pink), at: (row: 16, column: 7))
        model.setValue(.inactive(color: .pink), at: (row: 15, column: 7))
        model.setValue(.inactive(color: .pink), at: (row: 14, column: 7))
        return model
    }
    
    static var level14: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 11, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 10, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 10, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 10, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 10, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 10, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 11, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 11, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 10, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 9, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 8, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 9, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 10, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 11, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 2))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 4))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 6))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 7))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 9))
        return model
    }
    
    static var level15: GridModel {
        let model = GridModel(rows: Constants.rows, columns: Constants.columns)
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 9))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 1))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 1))
        
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 3))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 0))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 3))
        
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 5))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 6))
        
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 15, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 13, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 8))
        model.setValue(.effect(effect: .fire), at: (row: 12, column: 9))
        model.setValue(.effect(effect: .fire), at: (row: 14, column: 9))
        model.setValue(.effect(effect: .fire), at: (row: 16, column: 9))
        return model
    }
    
}

