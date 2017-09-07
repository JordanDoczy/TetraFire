//
//  HoldView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/6/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

protocol HoldViewDataSource: class {
    func getPieceModel() -> PieceModel?
}

class HoldView: UIView {
    
    weak var dataSource: HoldViewDataSource?
    
    var blockSize = CGSize.zero {
        didSet {
            pieceView.blockSize = blockSize
        }
    }
    
    fileprivate var pieceModel: PieceModel? {
        get {
            return pieceView.pieceModel
        }
        set {
            guard let pieceModel = newValue else {
                label.isHidden = false
                pieceView.isHidden = true
                pieceView.pieceModel = nil
                return
            }
            pieceView.pieceModel = pieceModel
            pieceView.frame.origin.y = (frame.height - pieceView.height) / 2
            pieceView.frame.origin.x = (frame.width - pieceView.width) / 2
            pieceView.isHidden = false
            label.isHidden = true
        }
    }
    
    fileprivate lazy var label: UILabel = { [unowned self] in
        let label = UILabel(frame: self.frame)
        label.font = .modal
        label.textAlignment = .center
        label.textColor = .extraLight
        label.text = Strings.hold
        label.sizeToFit()
        label.frame.origin.x = (self.frame.width - label.frame.width) / 2
        label.frame.origin.y = (self.frame.height - label.frame.height) / 2
        return label
        }()

    fileprivate lazy var pieceView: PieceView = { [unowned self] in
        let pieceView = PieceView(frame: self.frame)
        pieceView.blockSize = self.blockSize
        pieceView.isHidden = true
        return pieceView
        }()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .dark
        layer.borderColor = UIColor.extraLight.cgColor
        layer.borderWidth = 1
        
        addSubview(label)
        addSubview(pieceView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update() {
        pieceModel = dataSource?.getPieceModel()
    }
}
