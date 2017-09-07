//
//  PieceModel.swift
//  TetraFire
//
//  Created by Jordan Doczy on 9/6/17.
//  Copyright © 2017 Jordan Doczy. All rights reserved.
//

import Foundation

class PieceModel: NSObject, NSCoding {
    
    struct Constants {
        struct EncodeKeys {
            static let orientation = "orientation"
            static let gridPosition = "gridPosition"
            
            static let color = "color"
            static let up = "up"
            static let down = "down"
            static let left = "left"
            static let right = "right"
        }
    }
    
    let color: Color
    
    let up: [GridPosition]
    let down: [GridPosition]
    let left: [GridPosition]
    let right: [GridPosition]
    
    var gridPositions: [GridPosition] {
        return getGridPositions(at: gridPosition, for: orientation)
    }
    
    var orientation = Orientation.left
    var gridPosition = (row: 0, column: 0)
    
    init(color: Color,
         up: [GridPosition],
         down: [GridPosition],
         left: [GridPosition],
         right: [GridPosition]) {
        self.color = color
        self.up = up
        self.down = down
        self.left = left
        self.right = right
    }
    
    required init?(coder aDecoder: NSCoder) {
        let encodeKeys = Constants.EncodeKeys.self
        let colorRawValue = aDecoder.decodeInteger(forKey: encodeKeys.color)
        
        guard let color = Color(rawValue: colorRawValue),
            let upRawValue = aDecoder.decodeObject(forKey: encodeKeys.up) as? [[Int]],
            let downRawValue = aDecoder.decodeObject(forKey: encodeKeys.down) as? [[Int]],
            let leftRawValue = aDecoder.decodeObject(forKey: encodeKeys.left) as? [[Int]],
            let rightRawValue = aDecoder.decodeObject(forKey: encodeKeys.right) as? [[Int]] else {
                return nil
        }
        
        let up = upRawValue.flatMap( { Utility.decodeGridPosition(gridPosition: $0) })
        let down = downRawValue.flatMap( { Utility.decodeGridPosition(gridPosition: $0) })
        let left = leftRawValue.flatMap( { Utility.decodeGridPosition(gridPosition: $0) })
        let right = rightRawValue.flatMap( { Utility.decodeGridPosition(gridPosition: $0) })
        
        self.color = color
        self.up = up
        self.down = down
        self.left = left
        self.right = right
        
        if let orientationRawValue = aDecoder.decodeObject(forKey: encodeKeys.orientation) as? Int {
            orientation = Orientation(rawValue: orientationRawValue) ?? .left
        }

        if let gridPositionRawValue = aDecoder.decodeObject(forKey: encodeKeys.gridPosition) as? [Int] {
            gridPosition =
                Utility.decodeGridPosition(gridPosition: gridPositionRawValue) ?? (row: 0, column: 0)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        let encodeKeys = Constants.EncodeKeys.self
        
        let upEncoded = up.map{ Utility.encodeGridPosition(gridPosition: $0) }
        let downEncoded = down.map{ Utility.encodeGridPosition(gridPosition: $0) }
        let leftEncoded = left.map{ Utility.encodeGridPosition(gridPosition: $0) }
        let rightEncoded = right.map{ Utility.encodeGridPosition(gridPosition: $0) }
        let gridPositionEncoded = Utility.encodeGridPosition(gridPosition: gridPosition)
        
        aCoder.encode(color.rawValue, forKey: encodeKeys.color)
        aCoder.encode(upEncoded, forKey: encodeKeys.up)
        aCoder.encode(downEncoded, forKey: encodeKeys.down)
        aCoder.encode(leftEncoded, forKey: encodeKeys.left)
        aCoder.encode(rightEncoded, forKey: encodeKeys.right)
        
        aCoder.encode(orientation.rawValue, forKey: encodeKeys.orientation)
        aCoder.encode(gridPositionEncoded, forKey: encodeKeys.gridPosition)
    }
    
    func getGridPositions(at gridPosition: GridPosition, for orientation: Orientation? = nil) -> [GridPosition] {
        let orientation = orientation ?? self.orientation
        let positions: [GridPosition]
        
        switch orientation {
        case .up: positions = up
        case .down: positions = down
        case .left: positions = left
        case .right: positions = right
        }
        
        return positions.map { (row: $0.row + gridPosition.row,
                                column: $0.column + gridPosition.column) }
    }
    
    func rotate(direction: Direction = .forward) {
        switch direction {
        case .forward:
            switch(orientation){
            case .up: orientation = .right
            case .down: orientation = .left
            case .left: orientation = .up
            case .right: orientation = .down
            }
        case .backward:
            switch(orientation){
            case .up: orientation = .left
            case .down: orientation = .right
            case .left: orientation = .down
            case .right: orientation = .up
            }
        }
    }
    
    static func random() -> PieceModel {
        let random = arc4random() % 7 + 1
        switch random {
        case 1: return JPiece()
        case 2: return LPiece()
        case 3: return LinePiece()
        case 4: return SPiece()
        case 5: return SquarePiece()
        case 6: return TPiece()
        case 7: return ZPiece()
        default: return LPiece()
        }
    }
}

class JPiece: PieceModel {
    init() {
        super.init(color: .purple,
                   up:    [(row: 2, column: 0),
                           (row: 1, column: 0),
                           (row: 0, column: 0),
                           (row: 0, column: 1)],
                   down:  [(row: 0, column: 2),
                           (row: 1, column: 2),
                           (row: 2, column: 2),
                           (row: 2, column: 1)],
                   left:  [(row: 2, column: 2),
                           (row: 2, column: 1),
                           (row: 2, column: 0),
                           (row: 1, column: 0)],
                   right: [(row: 0, column: 0),
                           (row: 0, column: 1),
                           (row: 0, column: 2),
                           (row: 1, column: 2)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LPiece: PieceModel {
    init() {
        super.init(color: .pink,
                   up:    [(row: 2, column: 1),
                           (row: 1, column: 1),
                           (row: 0, column: 1),
                           (row: 0, column: 0)],
                   down:  [(row: 0, column: 0),
                           (row: 1, column: 0),
                           (row: 2, column: 0),
                           (row: 2, column: 1)],
                   left:  [(row: 0, column: 2),
                           (row: 0, column: 1),
                           (row: 0, column: 0),
                           (row: 1, column: 0)],
                   right: [(row: 2, column: 0),
                           (row: 2, column: 1),
                           (row: 2, column: 2),
                           (row: 1, column: 2)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LinePiece: PieceModel {
    init() {
        super.init(color: .red,
                   up:    [(row: 0, column: 0),
                           (row: 1, column: 0),
                           (row: 2, column: 0),
                           (row: 3, column: 0)],
                   down:  [(row: 0, column: 1),
                           (row: 1, column: 1),
                           (row: 2, column: 1),
                           (row: 3, column: 1)],
                   left:  [(row: 3, column: -1),
                           (row: 3, column: 0),
                           (row: 3, column: 1),
                           (row: 3, column: 2)],
                   right: [(row: 3, column: -1),
                           (row: 3, column: 0),
                           (row: 3, column: 1),
                           (row: 3, column: 2)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SPiece: PieceModel {
    init() {
        super.init(color: .green,
                   up:    [(row: 0, column: 0),
                           (row: 1, column: 0),
                           (row: 1, column: 1),
                           (row: 2, column: 1)],
                   down:  [(row: 0, column: 1),
                           (row: 1, column: 1),
                           (row: 1, column: 2),
                           (row: 2, column: 2)],
                   left:  [(row: 2, column: 0),
                           (row: 2, column: 1),
                           (row: 1, column: 1),
                           (row: 1, column: 2)],
                   right: [(row: 1, column: 0),
                           (row: 1, column: 1),
                           (row: 0, column: 1),
                           (row: 0, column: 2)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SquarePiece: PieceModel {
    init() {
        super.init(color: .orange,
                   up:    [(row: 0, column: 0),
                           (row: 0, column: 1),
                           (row: 1, column: 0),
                           (row: 1, column: 1)],
                   down:  [(row: 0, column: 0),
                           (row: 0, column: 1),
                           (row: 1, column: 0),
                           (row: 1, column: 1)],
                   left:  [(row: 0, column: 0),
                           (row: 0, column: 1),
                           (row: 1, column: 0),
                           (row: 1, column: 1)],
                   right: [(row: 0, column: 0),
                           (row: 0, column: 1),
                           (row: 1, column: 0),
                           (row: 1, column: 1)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TPiece: PieceModel {
    init() {
        super.init(color: .yellow,
                   up:    [(row: 0, column: 0),
                           (row: 1, column: 1),
                           (row: 1, column: 0),
                           (row: 2, column: 0)],
                   down:  [(row: 2, column: 2),
                           (row: 1, column: 1),
                           (row: 1, column: 2),
                           (row: 0, column: 2)],
                   left:  [(row: 2, column: 0),
                           (row: 1, column: 1),
                           (row: 2, column: 1),
                           (row: 2, column: 2)],
                   right: [(row: 0, column: 2),
                           (row: 1, column: 1),
                           (row: 0, column: 1),
                           (row: 0, column: 0)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZPiece: PieceModel {
    init() {
        super.init(color: .blue,
                   up:    [(row: 0, column: 1),
                           (row: 1, column: 1),
                           (row: 1, column: 0),
                           (row: 2, column: 0)],
                   down:  [(row: 0, column: 2),
                           (row: 1, column: 2),
                           (row: 1, column: 1),
                           (row: 2, column: 1)],
                   left:  [(row: 1, column: 0),
                           (row: 1, column: 1),
                           (row: 2, column: 1),
                           (row: 2, column: 2)],
                   right: [(row: 0, column: 0),
                           (row: 0, column: 1),
                           (row: 1, column: 1),
                           (row: 1, column: 2)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

