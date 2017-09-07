//
//  SidePanel.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/19/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

protocol SidePanelDataSource: class {
    func getPieceQueue() -> [PieceModel]
}

class SidePanelView: UIView {
    
    var blockSize = CGSize()
    weak var dataSource: SidePanelDataSource?
    fileprivate var views = [PieceView]()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .dark
        layer.borderColor = UIColor.extraLight.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.masksToBounds = true
        views.forEach { addSubview($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update() {
        if let pieces = dataSource?.getPieceQueue() {
            if views.count != pieces.count {
                views.forEach { $0.removeFromSuperview() }
                views.removeAll()
                
                pieces.forEach { _ in 
                    let view = PieceView(frame: frame)
                    view.blockSize = blockSize
                    views.append(view)
                    addSubview(view)
                }
            }

            var y: CGFloat = 0.0
            let ySpacer: CGFloat = 10.0
            for (index, view) in views.enumerated() {
                let pieceModel = pieces[index]
                view.pieceModel = pieceModel
                view.frame.origin.x = (frame.width - view.width) / 2
                view.frame.origin.y = ySpacer + y
                y = view.frame.origin.y + view.height
            }

            views.first?.glow()
        }
    }
}

