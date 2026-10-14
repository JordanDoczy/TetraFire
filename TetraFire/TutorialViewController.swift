//
//  TutorialViewController.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/5/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit
import SpriteKit

extension Constants {
    struct TutorialViewController {
        static let unwindToGameSegue = "unwindToGameSegue"
    }
}

class TutorialViewController: GameViewController {
    
    // MARK: - Models
    fileprivate var modalModel = [Strings.tutorialBegin,
                                  Strings.tutorial1,
                                  Strings.tutorial2,
                                  Strings.tutorial3,
                                  Strings.tutorial4,
                                  Strings.tutorial5,
                                  Strings.tutorialEnd]
    
    // MARK: - Member Vars
    fileprivate let spacer: CGFloat = 10
    fileprivate var tutorial = 0 {
        didSet {
            if tutorial < 0 {
                tutorial = 0
            }
            tutorial == 0 ? backButton.hide() : backButton.show()
            if tutorial == 0 && UserData.shared.needsSoundChoice {
                modalView.dismissesOnTap = false
                soundButtons.show()
            }
            if tutorial < modalModel.count {
                modalView.message = modalModel[tutorial]
                modalView.show()
                prepareTutorial()
            }
        }
    }

    // MARK: - Views
    fileprivate lazy var backButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setTitle(Strings.back, for: .normal)
        button.setTitleColor(.text, for: .normal)
        button.titleLabel?.font = .menuButton
        button.sizeToFit()
        button.isHidden = true
        button.frame.origin = CGPoint(x: self.spacer, y: self.safeFrame.minY + self.spacer)
        button.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        return button
        }()
    
    fileprivate lazy var closeButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setTitle(Strings.close, for: .normal)
        button.setTitleColor(.text, for: .normal)
        button.titleLabel?.font = .menuButton
        button.sizeToFit()
        button.frame.origin = CGPoint(x: self.view.frame.width - button.frame.width - self.spacer, y: self.safeFrame.minY + self.spacer)
        button.addTarget(self, action: #selector(self.close), for: UIControl.Event.touchUpInside)
        return button
        }()
    
    // Sound on / off choice, shown on the welcome screen the first time the app runs.
    fileprivate lazy var soundButtons: UIStackView = { [unowned self] in
        let on = UIButton()
        on.setTitle(Strings.soundOn, for: .normal)
        on.addTarget(self, action: #selector(self.chooseSoundOn), for: .touchUpInside)

        let off = UIButton()
        off.setTitle(Strings.soundOff, for: .normal)
        off.addTarget(self, action: #selector(self.chooseSoundOff), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [on, off])
        for button in [on, off] {
            button.setTitleColor(.text, for: .normal)
            button.titleLabel?.font = .menuButton
        }
        stack.axis = .horizontal
        stack.spacing = self.spacer * 4
        stack.frame.size = stack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        stack.center = CGPoint(x: self.view.bounds.midX, y: self.safeFrame.minY + self.safeFrame.height * 0.62)
        stack.isHidden = true
        return stack
    }()

    fileprivate lazy var modalView: ModalView = { [unowned self] in
        let modal = ModalView(frame: self.view.frame)
        modal.delegate = self
        return modal
        }()
    
    fileprivate lazy var modalOverlayView: UIView = { [unowned self] in
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = .dark
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var infoLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .text
        label.font = .modal
        return label
        }()
    
    fileprivate lazy var tutorialButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.frame.size = CGSize(width: 20, height: 20)
        button.setTitle(Strings.help, for: .normal)
        button.setTitleColor(.text, for: .normal)
        button.titleLabel?.font = .menuButton
        button.backgroundColor = .extraLight
        button.layer.cornerRadius = 10
        button.frame.origin = CGPoint(x: 10, y: self.safeFrame.maxY - button.frame.height - self.spacer)
        button.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        return button
        }()
    
    // MARK: - Methods
    override func addSubviews() {
        
        view.addSubview(backgroundView)
        view.addSubview(flashView)
        view.addSubview(overlayView)
        view.addSubview(gridView)
        view.addSubview(particleView)
        view.addSubview(sidePanelView)
        view.addSubview(holdView)
        view.addSubview(closeButton)
        view.addSubview(backButton)
        view.addSubview(tutorialButton)
        view.addSubview(modalOverlayView)
        view.addSubview(modalView)
        view.addSubview(soundButtons)
        view.addSubview(infoLabel)
        
        gridView.center = view.center
    }
    
    override func appeared() {
        gameMode = .classic
        gridModel = GridModelFactory.emptyModel
        level = 0
        score = 0
        sidePanelModel = SidePanelModel()
        
        tutorial = 0
        backgroundView.show()
    }
    
    @objc internal func back() {
        tutorial -= 1
        particleScene?.removeAllChildren()
    }
    
    @objc internal func chooseSoundOn() {
        chooseSound(true)
    }

    @objc internal func chooseSoundOff() {
        chooseSound(false)
    }

    internal func chooseSound(_ on: Bool) {
        UserData.shared.chooseSound(on)
        // hide() only fades out, which would leave the buttons visible to VoiceOver.
        soundButtons.hide { [weak self] _ in self?.soundButtons.removeFromSuperview() }
        modalView.dismissesOnTap = true
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        AudioManager.shared.playBackgroundMusic()
        modalView.hide()
    }

    @objc internal func close() {
        // Closing before picking keeps the default (sound on); music hasn't started yet.
        let startMusic = UserData.shared.needsSoundChoice
        UserData.shared.skipTutorial = true
        if startMusic {
            AudioManager.shared.playBackgroundMusic()
        }
        performSegue(withIdentifier: Constants.TutorialViewController.unwindToGameSegue, sender: nil)
    }
    
    override func gridViewDidUpdate(gridView: GridView) {
        switch tutorial {
        case 0: break
        case 1:
            if let column = activePiece?.gridPosition.column, column == 8 {
                tutorialComplete()
            }
        case 2:
            if let orientation = activePiece?.orientation, orientation == .down {
                tutorialComplete()
            }
        case 3:
            if gameState == .setPiece{
                tutorialComplete()
            }
        case 4:
            if heldPiece != nil {
                delayComplete(after: .milliseconds(1500))
            }
        case 5:
            if gameState == .setPiece {
                gameState = .inPlay
                gridView.update()
                delayComplete(after: .milliseconds(1200))
            }
        default:
            break
        }
        
    }
    
    internal func delayComplete(after delay: Duration) {
        Task { [weak self] in
            try? await Task.sleep(for: delay)
            self?.tutorialComplete()
        }
    }
    
    override func onPan(sender: UIPanGestureRecognizer) {
        guard tutorial == 1 || tutorial == 4 else {
            return
        }
        
        super.onPan(sender: sender)
    }
    
    override func onTap(sender: UITapGestureRecognizer) {
        guard tutorial == 2 else {
            return
        }
        
        super.onTap(sender: sender)
    }
    
    override func onLongPress(sender: UILongPressGestureRecognizer) {
        guard tutorial == 3 || tutorial == 5 else {
            return
        }
        
        super.onLongPress(sender: sender)
    }
    
    override func holdPiece() {
        guard tutorial == 4 else {
            return
        }
        
        super.holdPiece()
    }

    fileprivate func prepareTutorial() {
        switch(tutorial) {
        case 0:
            break
        case 1:
            gridModel = GridModelFactory.emptyModel
            let activePiece = SquarePiece()
            activePiece.gridPosition = (row: 2, column: 0)
            gridModel.setValues(.active(color: activePiece.color), at: activePiece.gridPositions)
            self.activePiece = activePiece
            
            infoLabel.text = Strings.swipeRight
            infoLabel.sizeToFit()
            infoLabel.center = gridView.center
            infoLabel.frame.origin.y = gridView.frame.origin.y - (spacer * 2)
        case 2:
            gridModel = GridModelFactory.emptyModel
            let activePiece = TPiece()
            activePiece.gridPosition = (row: 1, column: 3)
            gridModel.setValues(.active(color: activePiece.color), at: activePiece.gridPositions)
            self.activePiece = activePiece
            
            infoLabel.text = Strings.tap3Times
            infoLabel.sizeToFit()
            infoLabel.center = gridView.center
            infoLabel.frame.origin.y = gridView.frame.origin.y - (spacer * 2)

        case 3:
            gridModel = GridModelFactory.emptyModel
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 0))
            
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 1))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 2))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 3))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 5))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 6))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 7))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 8))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 9))

            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 0))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 1))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 2))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 3))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 5))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 6))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 7))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 8))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 9))

            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 0))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 1))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 2))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 3))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 5))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 6))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 7))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 8))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 9))

            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 0))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 1))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 2))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 3))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 5))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 6))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 7))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 8))
            gridModel.setValue(.inactive(color: .pink), at: (row: 16, column: 9))

            let activePiece = LinePiece()
            activePiece.orientation = .up
            activePiece.gridPosition = (row: 0, column: 4)
            gridModel.setValues(.active(color: activePiece.color), at: activePiece.gridPositions)
            self.activePiece = activePiece
            
            infoLabel.text = Strings.pressAndHold
            infoLabel.sizeToFit()
            infoLabel.center = gridView.center
            infoLabel.frame.origin.y = gridView.frame.origin.y - (spacer * 2)
            
        case 4:
            gridModel = GridModelFactory.emptyModel
            
            let activePiece = ZPiece()
            activePiece.gridPosition = (row: 2, column: 4)
            gridModel.setValues(.active(color: activePiece.color), at: activePiece.gridPositions)
            self.activePiece = activePiece

            gridView.frame.origin.x = offset
            
            let tutorialOffSet: CGFloat = -30 // to accomodate position of tutorialViewController (overlay)
            gridView.frame.origin.y = sidePanelView.frame.origin.y + tutorialOffSet
            sidePanelView.frame.origin.y = sidePanelView.frame.origin.y + tutorialOffSet
            holdView.frame.origin.y = holdView.frame.origin.y + tutorialOffSet

            sidePanelModel.reset()
            sidePanelView.update()
            
            infoLabel.text = Strings.swipeUp
            infoLabel.sizeToFit()
            infoLabel.center = gridView.center
            infoLabel.frame.origin.y = gridView.frame.origin.y - (spacer * 2)
        case 5:
            gridModel = GridModelFactory.emptyModel
            
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 0))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 1))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 2))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 3))
            gridModel.setValue(.effect(effect: .fire), at: (row: 19, column: 4))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 5))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 6))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 7))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 8))
            gridModel.setValue(.inactive(color: .purple), at: (row: 19, column: 9))
            
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 0))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 1))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 2))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 3))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 5))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 6))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 7))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 8))
            gridModel.setValue(.inactive(color: .blue), at: (row: 18, column: 9))
            
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 0))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 1))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 2))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 3))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 7))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 8))
            gridModel.setValue(.inactive(color: .yellow), at: (row: 17, column: 9))
            
            let activePiece = LPiece()
            activePiece.gridPosition = (row: 0, column: 4)
            gridModel.setValues(.active(color: activePiece.color), at: activePiece.gridPositions)
            self.activePiece = activePiece
            
            infoLabel.text = Strings.pressAndHold
            infoLabel.sizeToFit()
            infoLabel.center = gridView.center
            infoLabel.frame.origin.y = gridView.frame.origin.y - (spacer * 2)

        default:
            break
        }
    }
    
    internal override func didIncreaseLevel() -> Bool { return false }
    
    internal override func startTimer(with timerState: TimerState) {
        stopTimer()
        
        switch(timerState) {
        case .drop:
            let delay = SKAction.wait(forDuration: timerDropInterval)
            let step = SKAction.run { [weak self] in self?.incrementRow() }
            let sequenceAction = SKAction.sequence([delay, step])
            let repeatAction = SKAction.repeatForever(sequenceAction)
            particleScene?.run(repeatAction, withKey: constants.timerActionKey)
        case .hold:
            setPiece()
        default:
            break
        }
        
        self.timerState = timerState
    }

    @objc internal func showModal() {
        modalOverlayView.show()
        modalView.show()
    }
    
    internal func tutorialComplete() {
        gameState = .setPiece
        gridModel = GridModelFactory.emptyModel
        modalView.message = Strings.tutorialComplete
        modalView.show()
        heldPiece = nil
        holdView.update()
        AudioManager.shared.playSound(fileName: Assets.Sounds.ding)
    }
}

extension TutorialViewController: ModalViewDelegate {
    internal func modalViewDidHide(modalView: ModalView){
        switch modalView.message {
        case Strings.tutorialBegin:
            fallthrough
        case Strings.tutorialComplete:
            tutorial += 1
        case Strings.tutorialEnd:
            close()
        default:
            gameState = .inPlay
            gridView.update()
            gridView.show()
            infoLabel.show()
            if tutorial >= 4 {
                sidePanelView.show()
                holdView.show()
            }
        }
    }
    
    internal func modalViewDidShow(modalView: ModalView){ }
    
    internal func modalViewWillHide(modalView: ModalView) {
        switch(modalView.message) {
        case Strings.tutorialBegin: break
        case Strings.tutorialComplete: break
        default: modalOverlayView.hide()
        }
    }
    
    internal func modalViewWillShow(modalView: ModalView) {
        switch(modalView.message) {
        case Strings.tutorialBegin: modalOverlayView.show()
        case Strings.tutorialComplete: modalOverlayView.show()
        default: break
        }
        
        gameState = .tutorial
        gridView.hide()
        infoLabel.hide()
        sidePanelView.hide()
        holdView.hide()
    }
}
