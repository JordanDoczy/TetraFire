//
//  TetraFireGridView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/14/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit
import SpriteKit

@IBDesignable
class TetraFireGridView: GridView, UIGridDataSource {

    fileprivate var blocks = [BlockView]()
    fileprivate lazy var grid: UIGridView = { [unowned self] in
        let grid = UIGridView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        grid.dataSource = self
        grid.isOpaque = false
        return grid
        }()
    
    required init(columns: Int, rows: Int, frame: CGRect) {
        super.init(columns: columns, rows: rows, frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderColor = UIColor.light.cgColor
        layer.borderWidth = 1
        backgroundColor = .dark
        
        addSubview(grid)
        initializeBlocks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func clearRows(rows: [Int]) {
        removeCompletedRows(completedRows: rows)
    }

    fileprivate func getBlocks(fromRow row: Int) -> [BlockView] {
        var results = [BlockView]()
        for column in 0 ..< columns {
            let index = getIndex(row: row, column: column)
            results.append(blocks[index])
        }
        return results
    }
    
    fileprivate func getIndex(row:Int, column:Int) -> Int {
        return (row * columns) + column
    }
    
    fileprivate func initializeBlocks() {
        blocks.forEach { $0.removeFromSuperview() }
        blocks.removeAll()
        
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                let floatRow = CGFloat(row)
                let floatColumn = CGFloat(column)
                
                let block = BlockView(frame: CGRect(origin: CGPoint(x: floatColumn * boxWidth, y: floatRow * boxHeight),
                                                size: CGSize(width: boxWidth, height: boxHeight)))
                block.row = row
                block.column = column
                blocks.append(block)
                addSubview(block)
            }
        }
        
        bringSubview(toFront: grid)
    }
    
    internal func putOutFire(timer: Timer) {
        if let fireIndicies = timer.userInfo as? [Int] {
            for index in 0 ..< fireIndicies.count {
                blocks[fireIndicies[index]].dowseFire()
            }
        }
    }

    fileprivate func refreshGrid() {
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                let floatRow = CGFloat(row)
                let floatColumn = CGFloat(column)
                
                let block = blocks[getIndex(row: row, column: column)]
                block.frame = CGRect(origin: CGPoint(x: floatColumn * boxWidth, y: floatRow * boxHeight),
                                     size: CGSize(width: boxWidth, height: boxHeight))
                block.type = dataSource?.value(at: (row: row, column: column)) ?? nil
                block.alpha = 1
            }
        }
        delegate?.gridViewDidUpdate(gridView: self)
    }
    
    fileprivate func removeCompletedRows(completedRows: [Int]) {
        func drop(blocks:[BlockView], duration:Double, delay:Double) {
            
            func getRowDifference(block: BlockView) -> Int {
                var rowDifference = completedRows.count
                for completedRow in completedRows {
                    if block.row >= completedRow {
                        rowDifference -= 1
                    }
                }
                return rowDifference
            }
            
            var blocksToDrop = [BlockView]()
            blocks.forEach {
                let row = $0.row + getRowDifference(block: $0)
                if self.blocks[getIndex(row: row, column: $0.column)].type == .effect(effect: .fire) {
                    $0.smoke()
                    $0.alpha = 0
                } else {
                    blocksToDrop.append($0)
                }
            }
            
            UIView.animate(withDuration: duration,
                delay: delay,
                options: .curveEaseIn,
                animations: { [weak self] in
                    guard let strongSelf = self else { return }

                    blocksToDrop.forEach {
                        let rowDifference = getRowDifference(block: $0)
                        if rowDifference > 0 {
                            $0.frame.origin.y += strongSelf.boxHeight * CGFloat(rowDifference)
                        }
                    }
                },
                completion: { [weak self] success in
                    UIView.animate(withDuration: 0.1,
                        delay: 0,
                        options: [.curveEaseOut],
                        animations: {
                            blocksToDrop.forEach {
                                let rowDifference = getRowDifference(block: $0)
                                if rowDifference > 0 {
                                    $0.frame.origin.y -= 5
                                }
                            }
                        },
                        completion: { success in
                            UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseIn],
                                animations: {
                                    blocksToDrop.forEach {
                                        let rowDifference = getRowDifference(block: $0)
                                        if rowDifference > 0 {
                                            $0.frame.origin.y += 5
                                        }
                                    }
                                },
                                completion: { success in
                                    guard let strongSelf = self else { return }

                                    strongSelf.delegate?.gridViewDidUpdate(gridView: strongSelf)
                                }
                            )
                        }
                    )
                }
            )
        }

        
        func explode(blocks: [BlockView]) {
            blocks.forEach { $0.explode() }
        }
        
        func remove(blocks: [BlockView], duration: Double, delay: Double) {
            UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut,
                animations: { [weak self] in
                    for block in blocks{
                        block.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                        guard let boxHeight = self?.boxHeight else { return }
                        
                        block.frame.origin.y += boxHeight / 2
                    }
                },
                completion: { success in
                    blocks.forEach {
                        $0.isHidden = true
                        $0.transform = CGAffineTransform.identity
                    }
                }
            )
        }
        
        func dust(blocks: [BlockView]) {
            blocks.forEach {
                if let blockType = dataSource?.value(at: (row: $0.row, column: $0.column)),
                    case .block(_) = blockType {
                    $0.dust(delay: 0.3)
                }
            }
        }
        
        func dowseFire(blocksToRemove: [BlockView]) {
            blocksToRemove.forEach {
                if $0.row < rows - 1 {
                    let blockUnderneathRow = blocks[getIndex(row: $0.row + 1, column: $0.column)]
                    if blockUnderneathRow.type == .effect(effect: .fire) {
                        blockUnderneathRow.dowseFire()
                    }
                }
            }
        }
        
        var blocksToRemove = [BlockView]()
        completedRows.forEach {
            blocksToRemove += getBlocks(fromRow: $0)
        }
        blocksToRemove = blocksToRemove.filter { $0.type != nil }
        
        let nonEmptyBlocks = self.blocks.filter { $0.type != nil && $0.type != .effect(effect: .fire) }
        
        dowseFire(blocksToRemove: blocksToRemove)
        explode(blocks: blocksToRemove)
        remove(blocks: blocksToRemove, duration: 0.18, delay: 0.2)
        drop(blocks: nonEmptyBlocks, duration: 0.18, delay: 0.2)
        dust(blocks: getBlocks(fromRow: completedRows.max()!))
    }

    override func update() {
        refreshGrid()
    }
    
    func youWin() {
        initializeBlocks()
        
        func fillGrid() {
            let delay = 0.02
            let explodeIndicies = GridModelFactory.indexesForExplodeAnimation
            for index in 0 ..< explodeIndicies.count {
                let block = blocks[explodeIndicies[index]]
                block.type = .block(color: Color.getRandom())
                block.overlay.alpha = 0
                
                if index == explodeIndicies.count - 1 {
                    block.show(with: Delay(index) * delay) { [weak self] success in
                        guard let blocks = self?.blocks else { return }
                        
                        for index in 0 ..< explodeIndicies.count {
                            let block = blocks[explodeIndicies[index]]
                            block.hide()
                            block.explode()
                        }
                    }
                } else {
                    block.show(with: Delay(index) * delay)
                }
            }
        }

        fillGrid()
        let fireIndicies = GridModelFactory.indexesForYouWinAnimation
        
        for index in 0 ..< fireIndicies.count {
            blocks[fireIndicies[index]].fire(delay: (Double(index) * 0.08) + 6.0)
        }
    }
}
