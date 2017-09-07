//
//  GridPositionCoding.swift
//  TetraFire
//
//  Created by Jordan Doczy on 9/6/17.
//  Copyright © 2017 Jordan Doczy. All rights reserved.
//

import Foundation

struct Utility {
    static func encodeGridPosition(gridPosition: GridPosition) -> [Int] {
        return [gridPosition.row, gridPosition.column]
    }
    
    static func decodeGridPosition(gridPosition: [Int]) -> GridPosition? {
        guard gridPosition.count == 2 else { return nil }
        
        return (row: gridPosition[0], column: gridPosition[1])
    }
}
