//
//  LevelView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/29/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

class LevelView: UILabel {

    var level = 0 {
        didSet {
            text = Strings.level + " \(level)"
            if let superview = superview {
                frame.origin.x = superview.frame.width / 2 - frame.width / 2
                frame.origin.y = superview.frame.height / 2 - frame.height / 2
            }
            
            showTask?.cancel()
            showTask = Task { [weak self] in
                try? await Task.sleep(for: .milliseconds(500))
                guard !Task.isCancelled else { return }
                self?.onTimerShow()
            }
        }
    }
    
    fileprivate var showTask: Task<Void, Never>?

    override required init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .extraDark
        layer.borderWidth = 1
        layer.borderColor = UIColor.light.cgColor
        layer.cornerRadius = 5
        textColor = .text
        textAlignment = .center
        font = .level
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func onTimerShow() {
        show { [weak self] success in
            self?.showTask = Task { [weak self] in
                try? await Task.sleep(for: .milliseconds(750))
                guard !Task.isCancelled else { return }
                self?.onTimerHide()
            }
        }
    }
    
    internal func onTimerHide() {
        showTask?.cancel()
        hide()
    }
}
