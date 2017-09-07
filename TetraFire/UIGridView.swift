//
//  UIGridView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 9/4/17.
//  Copyright © 2017 Jordan Doczy. All rights reserved.
//

import UIKit

protocol UIGridDataSource: class {
    var rows: Int { get }
    var columns: Int { get }
    var boxWidth: CGFloat { get }
    var boxHeight: CGFloat { get }
}

class UIGridView: UIView {
    
    weak var dataSource: UIGridDataSource?
    
    func drawGrid() {
        
        let path = UIBezierPath()
        
        if let dataSource = dataSource {
            let boxHeight = dataSource.boxHeight
            let boxWidth = dataSource.boxWidth
            
            for row in 0 ..< dataSource.rows {
                for column in 0 ..< dataSource.columns {
                    
                    let floatRow = CGFloat(row)
                    let floatColumn = CGFloat(column)
                    
                    path.move(to: CGPoint(x: floatColumn * boxWidth, y: floatRow * boxHeight))
                    path.addLine(to: CGPoint(x: floatColumn * boxWidth + boxWidth, y:floatRow * boxHeight))
                    path.addLine(to: CGPoint(x: floatColumn * boxWidth + boxWidth, y:floatRow * boxHeight + boxHeight))
                    path.addLine(to: CGPoint(x: floatColumn * boxWidth, y: floatRow * boxHeight + boxHeight))
                    path.addLine(to: CGPoint(x: floatColumn * boxWidth, y: floatRow * boxHeight))
                }
            }
        }
        
        UIColor.light.setStroke()
        path.lineWidth = 1.0
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        drawGrid()
    }
}
