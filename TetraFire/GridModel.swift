//
//  GridViewModel.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/24/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

class GridModel: NSObject, NSCoding, GridViewDataSource {
    
    struct Constants{
        struct EncodeKeys{
            static let blocks = "blocks"
            static let columns = "columns"
            static let rows = "rows"
        }
    }
    
    fileprivate(set) var blocks = [BlockType?]()
    fileprivate(set) var columns = 0
    fileprivate(set) var rows = 0
    
    var count: Int { return blocks.count }
    
    subscript(index: Int) -> BlockType? {
        get {
            return blocks[index]
        }
        set(newValue) {
            setValue(newValue, at: index)
        }
    }
    
    required init(rows: Int, columns: Int) {
        super.init()

        self.columns = columns
        self.rows = rows
        reset(with: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()

        columns = aDecoder.decodeInteger(forKey: Constants.EncodeKeys.columns)
        rows = aDecoder.decodeInteger(forKey: Constants.EncodeKeys.rows)
        
        reset(with: nil)
        
        if let blocks = aDecoder.decodeObject(forKey: Constants.EncodeKeys.blocks) as? [[Int]?] {
            decodeBlocks(array: blocks)
        }
        
    }
    
    func clear(at index: Int) {
        setValue(nil, at: index)
    }
    
    func clear(at position: GridPosition) {
        let index = getIndex(at: position)
        clear(at: index)
    }
    
    func clearRow(row: Int) {
        for column in 0 ..< columns {
            clear(at: (row: row, column: column))
        }
    }
    
    fileprivate func decodeBlocks(array: [[Int]?]) {
        for (index, rawValue) in array.enumerated() {
            if let rawValue = rawValue {
                let pieceType = BlockType(rawValue: rawValue)
                setValue(pieceType, at: index)
            } else {
                setValue(nil, at: index)
            }
        }
    }
    
    func dropRows(rows: [Int]) {
        let fireIndexes = blocks.indexesOf(BlockType.effect(effect: .fire))
        
        rows.forEach { row in
            dropRowsAboveRow(completedRow: row)
        }
        
        fireIndexes.forEach { index in
            setValue(.effect(effect: .fire), at: index)
        }
    }
    
    func dropRowsAboveRow(completedRow: Int) {
        var row = completedRow - 1
        while row >= 0 {
            let values = getValues(fromRow: row)
            for column in 0 ..< values.count {
                if values[column] != .effect(effect: .fire) {
                    clear(at: (row: row, column: column))
                    setValue(values[column], at: (row: row + 1, column: column))
                } else {
                    setValue(nil, at: (row: row + 1, column: column))
                }
            }
            row -= 1
        }
    }
    
    fileprivate func encodeBlocks() -> [[Int]?] {
        var values = [[Int]?]()
        blocks.forEach {
            values += [$0?.rawValue]
        }
        return values
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(columns, forKey: Constants.EncodeKeys.columns)
        aCoder.encode(rows, forKey: Constants.EncodeKeys.rows)
        aCoder.encode(encodeBlocks(), forKey: Constants.EncodeKeys.blocks)
    }
    
    func getCompletedRows() ->[Row] {
        var completedRows = [Row]()
        for row in 0 ..< rows {
            let emptyValues = getValues(fromRow: row).filter{ !isValidElement($0) }
            if emptyValues.count == 0 {
                completedRows.append(row)
            }
        }
        
        return completedRows
    }
    
    func getEmptyIndicies(fromRow startingRow: Int) -> [Int] {
        guard 0 ..< rows - 1 ~= startingRow else { return [Int]() }
        
        var emptyIndicies = [Int]()
        for row in stride(from: rows - 1, to: startingRow + 1, by: -1) {
            for column in 0 ..< columns {
                let position = (row: row, column: column)
                
                if isEmpty(at: position) {
                    let index = getIndex(at: position)
                    emptyIndicies.append(index)
                }
            }
        }
        
        return emptyIndicies
    }
    
    func getFirstNonEmptyIndex() -> Int? {
        return blocks.index { !isEmptyElement($0) }
    }
    
    func getHighestOpenPosition(positions: [GridPosition]) -> [GridPosition] {
        var positions = positions
        
        while isValidMove(gridPositions: positions) {
            positions = positions.map { (row: $0.row + 1, column: $0.column) }
        }
        positions = positions.map { (row: $0.row - 1, column: $0.column) }
        
        return positions
    }
    
    func getIndex(at position: GridPosition) ->Int {
        return (position.row * columns) + position.column
    }
    
    func getRow(index: Int) -> Int {
        return index / columns
    }
    
    func getValues(fromRow row: Row) -> [BlockType?] {
        var values = [BlockType?]()
        for column in 0 ..< columns {
            values.append(value(at: (row: row, column: column)))
        }
        return values
    }
    
    func hasFire() -> Bool {
        return blocks.contains {
            $0 == BlockType.effect(effect: .fire)
        }
    }
    
    func hasFire(atRow row: Row) -> Bool {
        return getValues(fromRow: row).contains {
            $0 == .effect(effect: .fire)
        }
    }
    
    func isEmpty() -> Bool {
        return blocks.filter { $0 != nil }.count == 0
    }
    
    func isEmpty(at index: Int) -> Bool {
        return isEmptyElement(blocks[index])
    }
    
    func isEmpty(at position: GridPosition) -> Bool {
        let index = getIndex(at: position)
        return isEmpty(at: index)
    }
    
    func isEmptyElement(_ element: BlockType?) -> Bool {
        guard let element = element else { return true }
        
        switch element {
        case .active(_), .ghost(_): return true
        case .effect(let effect): return effect != .fire
        case .inactive(_): return false
        }
    }
    
    func isValidElement(_ element: BlockType?) -> Bool {
        guard let element = element, case .inactive(_) = element else {
            return false
        }
        return true
    }
    
    func isValidMove(gridPositions: [GridPosition]) -> Bool {
        
        let indiciesOfPositions = gridPositions.map { getIndex(at: $0) }
        
        let max = indiciesOfPositions.max() ?? blocks.count
        let min = indiciesOfPositions.min() ?? 0

        // check indicies are in bounds
        guard indiciesOfPositions.count > 0 && (min > 0 && max < blocks.count) else {
            return false
        }
                
        // check row for each block matches expected value (prevents wrapping to next line)
        for (index, position) in gridPositions.enumerated() {
            if position.row != getRow(index: indiciesOfPositions[index]) {
                return false
            }
        }
        
        // check to see if block current occupied
        for index in indiciesOfPositions {
            if !isEmpty(at: index) {
                return false
            }
        }
        
        return true
    }
    
    func removeActiveAndGhostBlocks() {
        for (index, element) in blocks.enumerated() {
            guard let element = element else { continue }
            
            switch element {
            case .active(_), .ghost(_):
                blocks[index] = nil
            default: break
            }
        }
    }
    
    func removeFire(fromRows rows: [Row]) -> [Row] {
        var rowsOfFire = [Int]()
        for row in rows {
            if row < self.rows - 1 {
                for column in 0 ..< columns {
                    let position = (row: row + 1, column: column)
                    
                    if let blockType = value(at: position),
                        blockType == .effect(effect: .fire) {
                        setValue(nil, at: position)
                        rowsOfFire.append(row + 1)
                    }
                }
            }
        }
        
        return rowsOfFire
    }
    
    func reset(with value: BlockType?) {
        blocks = [BlockType?](repeating: value, count: rows * columns)
    }
    
    func setColumns(_ values: [Column : BlockType?], at row: Row) {
        setRow(row, with: values)
    }
    
    func setRow(_ row: Row, with values: [BlockType?]) {
        for column in 0 ..< values.count {
            setValue(values[column], at: (row: row, column: column))
        }
    }
    
    func setRow(_ row: Row, with values: [Column : BlockType?]) {
        for column in values.keys {
            if let value = values[column] {
                setValue(value, at: (row: row, column: column))
            }
        }
    }
    
    func setValue(_ value: BlockType?, at index: Int) {
        guard 0 ..< blocks.count ~= index else { return }
        
        blocks[index] = value
    }
    
    func setValue(_ value: BlockType?, at position: GridPosition) {
        let index = getIndex(at: position)
        setValue(value, at: index)
    }
    
    func setValues(_ values: [BlockType?], at row: Row) {
        setRow(row, with: values)
    }

    func setValues(_ value: BlockType?, at positions: [GridPosition]) {
        positions.forEach { position in
            let index = getIndex(at: position)
            setValue(value, at: index)
        }
    }
    
    func value(at position: GridPosition) -> BlockType? {
        let index = getIndex(at: position)
        guard 0 ..< blocks.count ~= index else { return nil }
        
        return blocks[index]
    }
    
    
}
