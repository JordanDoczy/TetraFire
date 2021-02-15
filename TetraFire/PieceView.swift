//
//  PieceView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/6/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

class PieceView: UIView {

    fileprivate var blocks = [BlockView]()
    
    var blockSize: CGSize = .zero {
        didSet {
            func createBlock(with size: CGSize) -> BlockView {
                let block = BlockView(frame: CGRect(origin: .zero, size: size))
                block.layer.borderColor = UIColor.light.cgColor
                block.layer.borderWidth = 0.5
                addSubview(block)
                return block
            }

            blocks.forEach { $0.removeFromSuperview() }
            blocks.removeAll()
            
            for _ in 0 ..< 4 {
                blocks.append(createBlock(with: blockSize))
            }
        }
    }
    
    var height: CGFloat {
        get {
            guard blocks.count > 0 else {
                return 0
            }
            
            return blocks.map(){ $0.frame.origin.y }.max()! + blocks.first!.frame.height
        }
    }
    
    var width: CGFloat {
        get {
            guard blocks.count > 0 else {
                return 0
            }
            
            return blocks.map(){ $0.frame.origin.x }.max()! + blocks.first!.frame.width
        }
    }
    
    var pieceModel: PieceModel? {
        didSet {
            guard let pieceModel = pieceModel, blockSize != .zero else {
                return
            }
            
            func positionBlock(_ block: UIView, at position: GridPosition){
                block.frame.origin.x = CGFloat(position.column) * blockSize.width
                block.frame.origin.y = CGFloat(position.row) * blockSize.height
            }
            
            pieceModel.orientation = .up
            let gridPositions = pieceModel.gridPositions
            
            for (index, block) in blocks.enumerated() {
                let position = gridPositions[index]
                block.type = .inactive(color: pieceModel.color)
                positionBlock(block, at: position)
            }
        }
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func glow() {
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.glow.cgColor
        layer.shadowOpacity = 1
    }
    
    func removeGlow() {
        layer.shadowOpacity = 0
    }
}
