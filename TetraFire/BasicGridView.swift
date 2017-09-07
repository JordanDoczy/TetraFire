//
//  BasicGridView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/14/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

class BasicGridView: GridView {
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        UIColor.white.setStroke()

        for row in 0 ..< rows {
            for column in 0 ..< columns {

                let color = dataSource?.value(at: (row: row, column: column))?.color ?? .black
                color.setFill()
                
                let floatRow = CGFloat(row)
                let floatColumn = CGFloat(column)
                
                let path = UIBezierPath()
                path.lineWidth = 1.0
                path.move(to: CGPoint(x: floatColumn * boxWidth, y: floatRow * boxHeight))
                path.addLine(to: CGPoint(x: floatColumn * boxWidth + boxWidth, y: floatRow*boxHeight))
                path.addLine(to: CGPoint(x: floatColumn * boxWidth + boxWidth, y:floatRow * boxHeight + boxHeight))
                path.addLine(to: CGPoint(x: floatColumn * boxWidth, y:floatRow * boxHeight + boxHeight))
                path.addLine(to: CGPoint(x: floatColumn * boxWidth, y:floatRow * boxHeight))
                path.stroke()
                path.fill()
            }
        }
        
        delegate?.gridViewDidUpdate(gridView: self)
    }
    
    override func update() {
        setNeedsDisplay()
    }
}
