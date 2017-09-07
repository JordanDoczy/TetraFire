//
//  GridView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/14/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit
import SpriteKit

protocol GridViewDataSource: class {
    func value(at: GridPosition) -> BlockType?
}

protocol GridViewDelegate: class {
    func gridViewDidUpdate(gridView: GridView)
}

class GridView: UIView {
    
    var boxWidth: CGFloat {
        return bounds.size.width / CGFloat(columns)
    }
    
    var boxHeight: CGFloat {
        return bounds.size.height / CGFloat(rows)
    }
    
    weak var dataSource: GridViewDataSource?
    weak var delegate: GridViewDelegate?

    var columns: Int = 0
    var rows: Int = 0
    
    required init(columns: Int, rows: Int, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.columns = columns
        self.rows = rows
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearAllRows() {
        var rowsToClear = [Int]()
        for index in 0 ..< rows {
            rowsToClear.append(index)
        }
        clearRows(rows: rowsToClear)
    }
    
    func clearRows(rows:[Int]) { }
    
    func update() { }
}
