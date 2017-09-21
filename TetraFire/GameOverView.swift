//
//  GameOverView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/8/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

protocol GameOverViewDelegate: class {
    func playAgain()
    func quit()
}

class GameOverView: UIView {
    
    weak var delegate: GameOverViewDelegate?
    
    fileprivate lazy var playAgainButton: UIButton = { [unowned self] in
        let button = UIButton(type: .system)
        button.setTitleColor(.text, for: .normal)
        button.setTitleColor(.textDisabled, for: .disabled)
        button.setTitle(Strings.playAgain, for: .normal)
        button.titleLabel?.font = .gameOverButton
        button.sizeToFit()
        button.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var quitButton: UIButton = { [unowned self] in
        let button = UIButton(type: .system)
        button.setTitleColor(.text, for: .normal)
        button.setTitleColor(.textDisabled, for: .disabled)
        button.setTitle(Strings.quit, for: .normal)
        button.titleLabel?.font = .gameOverButton
        button.sizeToFit()
        button.addTarget(self, action: #selector(quit), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var gameOverLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightFocused
        label.text = Strings.gameOver
        label.font = .gameOverTitle
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var topScoreLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.frame.size = self.frame.size
        label.numberOfLines = -1
        label.textColor = .lightFocused
        label.text = Strings.newTopScore
        label.font = .gameOverButton
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    fileprivate var spacer: CGFloat = 40.0
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        gameOverLabel.center.x = center.x
        topScoreLabel.center.x = center.x

        playAgainButton.frame.origin.x = (frame.width - playAgainButton.frame.width - spacer - quitButton.frame.width) / 2
        playAgainButton.frame.origin.y = gameOverLabel.frame.origin.y + gameOverLabel.frame.height + spacer
        
        quitButton.frame.origin.x = playAgainButton.frame.origin.x + playAgainButton.frame.width + spacer
        quitButton.frame.origin.y = playAgainButton.frame.origin.y
        
        addSubview(topScoreLabel)
        addSubview(gameOverLabel)
        addSubview(playAgainButton)
        addSubview(quitButton)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(sender:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc internal func playAgain() {
        delegate?.playAgain()
    }
    
    @objc internal func quit() {
        delegate?.quit()
    }
    
    @objc internal func onTap(sender: UITapGestureRecognizer) {
        guard topScoreLabel.isHidden == false else {
            return
        }
        
        topScoreLabel.hide()
        gameOverLabel.show()
        playAgainButton.show()
        quitButton.show()
    }
    
    func showWithTopScore(topScore:Int, delay: Delay = 0.0, completion:((Bool)->Void)? = nil) {
        super.show(with: delay, completion: completion)
        
        if topScore > 0 {
            topScoreLabel.isHidden = false
            gameOverLabel.isHidden = true
            playAgainButton.isHidden = true
            quitButton.isHidden = true
            topScoreLabel.text = Strings.newTopScore + "\(topScore)"
        } else {
            topScoreLabel.isHidden = true
            gameOverLabel.isHidden = false
            playAgainButton.isHidden = false
            quitButton.isHidden = false
        }
    }
}
