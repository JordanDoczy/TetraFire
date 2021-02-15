//
//  SidePanelModel.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/29/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import Foundation

extension Constants {
    struct SidePanelModel {
        struct EncodeKeys {
            static let pieces = "pieces"
        }
    }
}

class SidePanelModel: NSObject, NSCoding, NSSecureCoding {

    static var supportsSecureCoding: Bool {
        get{
            return true
        }
    }
    
    fileprivate(set) var pieces = [PieceModel]()
    
    override init() {
        super.init()
        reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let pieces = aDecoder.decodeObject(forKey: Constants.SidePanelModel.EncodeKeys.pieces) as? [PieceModel] {
            self.pieces = pieces
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pieces, forKey: Constants.SidePanelModel.EncodeKeys.pieces)
    }
    
    func add() {
        var newPiece = PieceModel.random()
        while (pieces.filter { $0.color == newPiece.color }).count > 1 {
            newPiece = PieceModel.random()
        }
        pieces.append(newPiece)
    }
    
    func next() -> PieceModel {
        let piece = pieces.removeFirst()
        add()
        return piece
    }
    
    func reset() {
        pieces.removeAll()
        var i = 0
        while i < 6 {
            add()
            i += 1
        }
    }

    func swapPiece(_ piece: PieceModel) -> PieceModel {
        let piece = pieces.removeFirst()
        pieces.insert(piece, at: 0)
        return piece
    }
}
