//
//  ScoreView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/25/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

protocol HUDViewDataSource: class {
    var score: Int { get }
    var level: Int { get }
}

protocol HUDViewDelegate: class {
    func showMenu()
}

class HUDView: UIView {
    
    weak var dataSource: HUDViewDataSource?
    weak var delegate: HUDViewDelegate?
    
    fileprivate var level: NumericLabel?
    fileprivate var score: NumericLabel?
    fileprivate var menuLabel: UILabel?
    
    internal var spacer: CGFloat {
        
        switch (Int(frame.height)) {
        case 0...480: return 10
        default: return 30
        }
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        isOpaque = false

        let score = NumericLabel(frame: CGRect(x: spacer, y: spacer*1.5, width: 0, height: 0))
        score.label = Strings.score
        self.score = score

        let level = NumericLabel(frame: CGRect(x: spacer, y: score.height + score.frame.minY + spacer/2, width: 0, height: 0))
        level.label = Strings.level
        self.level = level
        
        let menuLabel = UILabel(frame: CGRect(x: 0, y: level.frame.origin.y, width: level.width, height: level.height))
        menuLabel.textColor = .text
        menuLabel.textAlignment = .right
        menuLabel.font = .hud
        menuLabel.text = Strings.menu
        menuLabel.frame.origin.x = frame.width - spacer - menuLabel.frame.width
        self.menuLabel = menuLabel
        
        let clearButton = UIButton()
        clearButton.frame.size = CGSize(width: 100, height: 75)
        clearButton.frame.origin = CGPoint(x:frame.width - 100, y:0)
        clearButton.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        
        addSubview(menuLabel)
        addSubview(clearButton)
        addSubview(score)
        addSubview(level)
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let yMin: CGFloat = 25 + spacer
        let yMax: CGFloat = 50 + spacer*1.5
        
        let point0 = CGPoint.zero
        let point1 = CGPoint(x: 0, y: yMax)
        let point2 = CGPoint(x: (3 / 11)  * frame.width, y: yMax)
        let point3 = CGPoint(x: (4 / 11)  * frame.width, y: yMin)
        let point4 = CGPoint(x: (7 / 11)  * frame.width, y: yMin)
        let point5 = CGPoint(x: (8 / 11)  * frame.width, y: yMax)
        let point6 = CGPoint(x: (11 / 11) * frame.width, y: yMax)
        let point7 = CGPoint(x: (11 / 11) * frame.width, y: 0)

        let controlPoint1 = CGPoint(x: (3.5 / 11) * frame.width, y: yMax)
        let controlPoint2 = CGPoint(x: (3.5 / 11) * frame.width, y: yMin)
        let controlPoint3 = CGPoint(x: (7.5 / 11) * frame.width, y: yMin)
        let controlPoint4 = CGPoint(x: (7.5 / 11) * frame.width, y: yMax)
        
        
        path.move(to: .zero)
        path.addLine(to: point1)
        path.addLine(to: point2)
        path.addCurve(to: point3, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        path.addLine(to: point4)
        path.addCurve(to: point5, controlPoint1: controlPoint3, controlPoint2: controlPoint4)
        path.addLine(to: point6)
        path.addLine(to: point7)
        path.addLine(to: point0)
        
        UIColor.extraLight.setStroke()
        UIColor.dark.setFill()
        path.lineWidth = 1.0
        path.lineJoinStyle = CGLineJoin.round
        path.stroke()
        path.fill()
    }
    
    @objc func pauseGame() {
        delegate?.showMenu()
    }
    
    func update() {
        score?.value = dataSource?.score
        level?.value = dataSource?.level
    }
    
    class NumericLabel: UIView {
        
        var label: String? = "" {
            didSet {
                textLabel.text = label
                textLabel.sizeToFit()
                numericLabel.frame.origin = CGPoint(x: textLabel.frame.origin.x + textLabel.frame.width + spacer, y: 0)
            }
        }
        
        var value: Int? = 0 {
            didSet {
                guard let value = value else { return }
                
                isHidden = value < 0
                numericLabel.text = "\(value)"
                numericLabel.sizeToFit()
                if value != oldValue {
                    animate()
                }
            }
        }
        
        var height: CGFloat {
            return textLabel.frame.height
        }
        
        var width: CGFloat {
            return textLabel.frame.width + spacer + numericLabel.frame.width
        }
        
        fileprivate var textLabel = UILabel()
        fileprivate var numericLabel = UILabel()
        fileprivate let spacer: CGFloat = 10
        
        override required init(frame: CGRect) {
            super.init(frame: frame)
            
            textLabel.textColor = .text
            textLabel.font = .hud
            
            numericLabel.textColor = .text
            numericLabel.font = .hud
            
            addSubview(textLabel)
            addSubview(numericLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func animate(){
            UIView.transition(with: numericLabel, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}
