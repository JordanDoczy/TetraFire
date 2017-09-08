//
//  MenuView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/22/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

protocol MenuViewDelegate: class {
    func newGame(gameMode: GameMode, level: Int)
    func resumeGame()
    func showTutorial()
    func menuDidShow(menuView: MenuView)
    func menuDidHide(menuView: MenuView)
    func menuWillShow(menuView: MenuView)
    func menuWillHide(menuView: MenuView)
}

protocol MenuViewDataSource: class {
    var canResumeGame: Bool { get }
    func maxLevelAchieved(for gameMode: GameMode) -> Int
}

class MenuView: UIView {
    
    weak var dataSource: MenuViewDataSource?
    weak var delegate: MenuViewDelegate?
    
    fileprivate var backButton: MenuButton?
    fileprivate var classicGameButton: MenuButton?
    fileprivate var creditsButton: MenuButton?
    fileprivate var fireGameButton: MenuButton?
    fileprivate var newGameButton: MenuButton?
    fileprivate var resumeGameButton: MenuButton?
    fileprivate var settingsButton: MenuButton?
    fileprivate var tutorialButton: MenuButton?
    fileprivate var creditsMenu: UIView?
    fileprivate var mainMenu: UIView?
    fileprivate var gameModeMenu: UIView?
    fileprivate var levelSelectMenu: UIView?
    fileprivate var settingsMenu: UIView?
    
    fileprivate var effectKey = "Menu:" + EffectType.fire.fileName
    fileprivate var gameMode = GameMode.classic
    fileprivate var particleScene: ParticleScene! {
        return (UIApplication.shared.delegate as? AppDelegate)?.particleScene
    }
    fileprivate let spacer: CGFloat = 20.0
    
    fileprivate var classicLevelCount = 0
    fileprivate var fireLevelCount = 0

    required init(frame: CGRect, classicLevelCount: Int, fireLevelCount: Int) {
        super.init(frame: frame)
        isHidden = true
        self.classicLevelCount = classicLevelCount
        self.fireLevelCount = fireLevelCount
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func addFire() {
        guard var point = fireGameButton?.frame.origin else { return }
        point.x = frame.width - 50
        point.y += 25
        let emitterNode = particleScene.runEffect(forKey: effectKey,
                                                  effect: .fire,
                                                  position: particleScene.convertPoint(fromView: point),
                                                  duration: -1.0,
                                                  force: true)
        emitterNode?.particlePositionRange.dx = 65
    }
    
    fileprivate func addSubviews(_ subviews: [UIView], to view: UIView) {
        for index in 0 ..< subviews.count {
            subviews[index].frame.origin = CGPoint(x: 0,
                                                   y: spacer * CGFloat(index) + subviews[index].frame.height * CGFloat(index) + spacer * 2)
            view.addSubview(subviews[index])
        }
    }
    
    internal func backToMainMenu(sender: UIButton) {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        removeFire()
        
        if let screen1 = mainMenu, let screen2 = sender.superview {
            transitionWithAnimation(from: screen2, to: screen1)
        }
    }
    
    internal func backToSelectGameMode() {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        addFire()
        
        if let screen2 = gameModeMenu, let screen3 = levelSelectMenu {
            transitionWithFade(from: screen3, to: screen2)
        }
    }
    
    internal func classicMode(){
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        removeFire()
        createLevelSelectMenu(gameMode: .classic)

        if let screen2 = gameModeMenu, let screen3 = levelSelectMenu{
            transitionWithFade(from: screen2, to: screen3)
        }
    }
    
    fileprivate func createButton(title: String, selector: Selector) -> MenuButton {
        let button = MenuButton (type: .system)
        button.frame.size = CGSize(width: frame.width - spacer, height: 40)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .menuButton
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    fileprivate func createCreditsMenu() {
        creditsMenu?.removeFromSuperview()
        creditsMenu = UIView(frame: frame)
        addSubview(creditsMenu!)
        
        backButton = createButton(title: Strings.back, selector: #selector(backToMainMenu))
        backButton!.contentHorizontalAlignment = .left
        backButton!.frame.origin = CGPoint(x: spacer / 2, y: spacer / 4)
        creditsMenu!.addSubview(backButton!)

        var subviews = [UIView]()
        
        let label1 = UILabel()
        label1.font = .menuTitle
        label1.textColor = .textDisabled
        label1.textAlignment = .right
        label1.frame.size = CGSize(width: frame.width - spacer, height: 40)
        label1.text = Strings.credits
        subviews.append(label1)
        
        let button1 = createButton(title: Strings.creditsImages, selector: #selector(openURL(sender:)))
        subviews.append(button1)
        
        let button2 = createButton(title: Strings.creditsSounds, selector: #selector(openURL(sender:)))
        subviews.append(button2)
        
        let button3 = createButton(title: Strings.creditsDeveloper, selector: #selector(openURL(sender:)))
        subviews.append(button3)

        addSubviews(subviews, to: creditsMenu!)
    }

    fileprivate func createGameModeMenu() {
        gameModeMenu?.removeFromSuperview()
        gameModeMenu = UIView(frame: frame)
        gameModeMenu!.isHidden = true
        addSubview(gameModeMenu!)
        
        backButton = createButton(title: Strings.back, selector: #selector(backToMainMenu))
        backButton!.contentHorizontalAlignment = .left
        backButton!.frame.origin = CGPoint(x: spacer / 2, y: spacer / 4)
        gameModeMenu!.addSubview(backButton!)
        
        var subviews = [UIView]()
        
        let label = UILabel()
        label.font = .menuTitle
        label.textColor = .textDisabled
        label.textAlignment = .right
        label.frame.size = CGSize(width: frame.width - spacer, height: 40)
        label.text = Strings.selectMode
        subviews.append(label)
        
        fireGameButton = createButton(title: Strings.fireMode, selector: #selector(fireMode))
        subviews.append(fireGameButton!)
        
        classicGameButton = createButton(title: Strings.classicMode, selector: #selector(classicMode))
        subviews.append(classicGameButton!)
        
        addSubviews(subviews, to: gameModeMenu!)
    }
    
    fileprivate func createLevelSelectMenu(gameMode: GameMode) {
        self.gameMode = gameMode

        levelSelectMenu?.removeFromSuperview()
        levelSelectMenu = UIView(frame: frame)
        addSubview(levelSelectMenu!)
        
        
        backButton = createButton(title: Strings.back, selector: #selector(backToSelectGameMode))
        backButton!.contentHorizontalAlignment = .left
        backButton!.frame.origin = CGPoint(x: spacer / 2, y: spacer / 4)
        levelSelectMenu!.addSubview(backButton!)
        
        var subviews = [UIView]()
        let label = UILabel()
        label.font = .menuTitle
        label.textColor = .textDisabled
        label.textAlignment = .right
        label.frame.size = CGSize(width: frame.width - spacer, height: 40)
        label.text = gameMode.description() + Strings.gameModeLevel
        subviews.append(label)
        
        if gameMode == .classic && UserData.shared.topScore > 0 {
            let topScoreLabel = UILabel()
            topScoreLabel.font = .menuButton
            topScoreLabel.textColor = .text
            topScoreLabel.textAlignment = .right
            topScoreLabel.frame.size = CGSize(width: frame.width - spacer, height: 40)
            topScoreLabel.text = Strings.yourTopScore + "\(UserData.shared.topScore)"
            topScoreLabel.frame.origin.y = 400
            subviews.append(topScoreLabel)
        }
        
        addSubviews(subviews, to: levelSelectMenu!)
        
        let size = CGSize(width: 30, height: 30)
        let numberOfLevels = gameMode == .classic ? classicLevelCount : fireLevelCount
        let offset = CGPoint(x: 0, y: subviews.last!.frame.origin.y + subviews.last!.frame.height + spacer)
        let itemsPerRow = 5
        for index in 0 ..< numberOfLevels {
            let column = CGFloat(index % itemsPerRow)
            let row = CGFloat(index / itemsPerRow)
            let y = row * spacer + row * size.height
            let levelButton = LevelButton()
            levelButton.level = index + 1
            levelButton.frame.size = size
            levelButton.frame.origin = CGPoint(x: levelSelectMenu!.frame.width - ((CGFloat(itemsPerRow) - column) * (size.width+spacer)), y: y + offset.y)
            levelButton.titleLabel?.font = .menuButton
            levelButton.alpha = 0
            levelButton.transform = CGAffineTransform(translationX: size.width * 2, y: 0)
            levelButton.isEnabled = index + 1 <= (dataSource?.maxLevelAchieved(for: gameMode) ?? 1)
            levelButton.addTarget(self, action: #selector(selectLevel(button:)), for: .touchUpInside)
            UIView.animate(withDuration: 0.5,
                delay: 0.2 + Double(index) * 0.015,
                usingSpringWithDamping: 0.65,
                initialSpringVelocity: 1.5,
                options: UIViewAnimationOptions(),
                animations: {
                    levelButton.alpha = 1
                    levelButton.transform = .identity
                }, completion: nil)

            levelSelectMenu?.addSubview(levelButton)
        }

    }
    
    fileprivate func createMainMenu() {
        mainMenu?.removeFromSuperview()
        mainMenu = UIView(frame: frame)
        addSubview(mainMenu!)
        
        var subviews = [UIView]()
        
        let label = UILabel()
        label.font = .menuTitle
        label.textColor = .textDisabled
        label.textAlignment = .right
        label.frame.size = CGSize(width: frame.width - spacer, height: 40)
        label.text = Strings.menu
        subviews.append(label)
        
        if let dataSource = dataSource{
            if dataSource.canResumeGame {
                resumeGameButton = createButton(title: Strings.resumeGame, selector: #selector(resumeGame))
                subviews.append(resumeGameButton!)
            }
        }
        
        newGameButton = createButton(title: Strings.newGame, selector: #selector(newGame))
        subviews.append(newGameButton!)
        
        tutorialButton = createButton(title: Strings.tutorial, selector: #selector(tutorial))
        subviews.append(tutorialButton!)

        settingsButton = createButton(title: Strings.settings, selector: #selector(settings))
        subviews.append(settingsButton!)

        creditsButton = createButton(title: Strings.credits, selector: #selector(credits))
        subviews.append(creditsButton!)

        addSubviews(subviews, to: mainMenu!)
    }
    
    fileprivate func createSettingsMenu() {
        settingsMenu?.removeFromSuperview()
        settingsMenu = UIView(frame: frame)
        addSubview(settingsMenu!)
        
        backButton = createButton(title: Strings.back, selector: #selector(backToMainMenu(sender:)))
        backButton!.contentHorizontalAlignment = .left
        backButton!.frame.origin = CGPoint(x: spacer / 2, y: spacer / 4)
        settingsMenu!.addSubview(backButton!)
        
        var subviews = [UIView]()
        
        let label = UILabel()
        label.font = .menuTitle
        label.textColor = .textDisabled
        label.textAlignment = .right
        label.frame.size = CGSize(width: frame.width - spacer, height: 40)
        label.text = Strings.settings
        subviews.append(label)
        
        let backgroundMusicButton = BackgroundMusicButton(type: .system)
        backgroundMusicButton.frame.size = CGSize(width: frame.width - spacer, height: 40)
        backgroundMusicButton.addTarget(self, action:#selector(toggleButton(sender:)), for: .touchUpInside)
        backgroundMusicButton.active = UserData.shared.backgroundMusic
        subviews.append(backgroundMusicButton)

        let soundEffectsButton = SoundEffectsButton(type: .system)
        soundEffectsButton.frame.size = CGSize(width: frame.width - spacer, height: 40)
        soundEffectsButton.addTarget(self, action:#selector(toggleButton(sender:)), for: .touchUpInside)
        soundEffectsButton.active = UserData.shared.soundEffects
        subviews.append(soundEffectsButton)

        let vibrateButton = VibrateButton(type: .system)
        vibrateButton.frame.size = CGSize(width: frame.width - spacer, height: 40)
        vibrateButton.addTarget(self, action:#selector(toggleButton(sender:)), for: .touchUpInside)
        vibrateButton.active = UserData.shared.vibrate
        subviews.append(vibrateButton)

        addSubviews(subviews, to: settingsMenu!)
    }
    
    internal func credits() {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        createCreditsMenu()
        
        if let screen1 = mainMenu, let screen2 = creditsMenu {
            transitionWithAnimation(from: screen1, to: screen2)
        }
    }
    
    internal func fireMode() {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        removeFire()
        createLevelSelectMenu(gameMode: .fire)

        if let screen2 = gameModeMenu, let screen3 = levelSelectMenu {
            transitionWithFade(from: screen2, to: screen3)
        }
    }

    override func hide(with delay: Delay = 0.0, completion:((Bool)->Void)? = nil) {
        
        delegate?.menuWillHide(menuView: self)
        removeFire()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut,
            animations: { [weak self] in
                guard let strongSelf = self else { return }
                
                strongSelf.transform = strongSelf.transform.translatedBy(x: 0, y: -strongSelf.frame.height)
            },
            completion: { [weak self] success in
                guard let strongSelf = self else {
                    completion?(success)
                    return
                }
                
                strongSelf.isHidden = true
                strongSelf.reset()
                strongSelf.delegate?.menuDidHide(menuView: strongSelf)
                completion?(success)
            }
        )
        
    }
    
    internal func newGame() {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        createGameModeMenu()
        
        if let screen1 = mainMenu, let screen2 = gameModeMenu {
            transitionWithAnimation(from: screen1, to: screen2)
        }
        
        addFire()
    }
    
    internal func openURL(sender: UIButton) {
        
        if let label = sender.titleLabel?.text {
            var urlString = ""
            
            switch(label) {
            case Strings.creditsDeveloper: urlString = Strings.Links.JordanDoczy
            case Strings.creditsSounds: urlString = Strings.Links.DLSounds
            case Strings.creditsImages: urlString = Strings.Links.NASA
            default: urlString = Strings.Links.JordanDoczy
            }
            
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    fileprivate func removeFire() {
        particleScene?.removeEffect(forKey: effectKey)
    }

    fileprivate func reset() {
        transform = .identity
        
        mainMenu?.removeFromSuperview()
        mainMenu = nil

        gameModeMenu?.removeFromSuperview()
        gameModeMenu = nil

        levelSelectMenu?.removeFromSuperview()
        levelSelectMenu = nil

        settingsMenu?.removeFromSuperview()
        settingsMenu = nil
    }
    
    internal func resumeGame() {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        delegate?.resumeGame()
    }
    
    internal func selectLevel(button: LevelButton) {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        delegate?.newGame(gameMode: gameMode, level: button.level)
    }
    
    internal func settings() {
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
        createSettingsMenu()
        
        if let screen1 = mainMenu, let screen2 = settingsMenu {
            transitionWithAnimation(from: screen1, to: screen2)
        }
    }
    
    override func show(with delay: Delay = 0.0, completion: ((Bool)->Void)? = nil) {
        guard isHidden == true else {
            return
        }
        
        delegate?.menuWillShow(menuView: self)
        reset()
        createMainMenu()
        
        transform = transform.translatedBy(x: 0, y: -frame.height)
        isHidden = false
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.65,
                       initialSpringVelocity: 1.5,
                       options: UIViewAnimationOptions(),
            animations: { [weak self] in
                self?.transform = .identity
            }, completion: { [weak self] success in
                guard let strongSelf = self else {
                    completion?(success)
                    return
                }

                strongSelf.delegate?.menuDidShow(menuView: strongSelf)
                completion?(success)
            }
        )
    }
    
    internal func toggleButton(sender: ToggleButton) {
        sender.active = !sender.active
        AudioManager.shared.playSound(fileName: Assets.Sounds.click)
    }
    
    fileprivate func toggleState(button: UIButton, label: String) {
        if let title = button.titleLabel?.text {
            if title.hasSuffix(Strings.on) {
                button.setTitle(label + " " + Strings.off, for: .disabled)
                button.setTitleColor(.textDisabled, for: .disabled)
            } else {
                button.setTitleColor(.text, for: .normal)
                button.setTitle(label + " " + Strings.on, for: .normal)
            }
        }
    }
    
    fileprivate func transitionWithAnimation(from fromView:UIView, to toView: UIView) {
        toView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        toView.isHidden = false
        
        UIView.animate(withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 1.5,
            options: UIViewAnimationOptions(),
            animations: {
                toView.transform = .identity
                fromView.alpha = 0
            },
            completion: { success in
                fromView.isHidden = true
                fromView.alpha = 1
        })
    }
    
    fileprivate func transitionWithFade(from fromView: UIView, to toView: UIView) {
        toView.isHidden = false
        toView.alpha = 0
        UIView.animate(withDuration: 0.5,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                fromView.alpha = 0
                toView.alpha = 1
            },
            completion: { success in
                fromView.isHidden = true
                fromView.alpha = 1
        })
    }

    internal func tutorial() {
        delegate?.showTutorial()
    }
    
    class ToggleButton: MenuButton {
        var active: Bool = true {
            didSet {
                updateLabel()
            }
        }
        var title: String = ""
        
        func updateLabel() {
            if active {
                setTitleColor(.text, for: .normal)
                setTitle(title + " " + Strings.on, for: .normal)
                titleLabel?.font = .menuButton
            } else {
                setTitle(title + " " + Strings.off, for: .normal)
                setTitleColor(.textDisabled, for: .normal)
                titleLabel?.font = .menuButton
            }
        }
    }
    
    class BackgroundMusicButton: ToggleButton {
        fileprivate var particleScene:ParticleScene? {
            return (UIApplication.shared.delegate as? AppDelegate)?.particleScene
        }
        
        override var active: Bool {
            didSet {
                UserData.shared.backgroundMusic = active
                updateLabel()
                active ? AudioManager.shared.playBackgroundMusic() : AudioManager.shared.stopBackgroundMusic()
            }
        }
        
        required init(frame: CGRect) {
            super.init(frame: frame)
            title = Strings.backgroundMusic
            setTitle(title, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class SoundEffectsButton: ToggleButton {
        
        override var active: Bool {
            didSet {
                UserData.shared.soundEffects = active
                updateLabel()
            }
        }
        
        required init(frame: CGRect) {
            super.init(frame: frame)
            title = Strings.soundEffects
            setTitle(title, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class VibrateButton: ToggleButton {
        
        override var active: Bool {
            didSet {
                UserData.shared.vibrate = active
                updateLabel()
                if active && oldValue == false {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
        }
        
        required init(frame: CGRect) {
            super.init(frame: frame)
            title = Strings.vibrate
            setTitle(title, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class MenuButton: UIButton {
        override required init(frame: CGRect) {
            super.init(frame: frame)
            
            isEnabled = true
            setTitleColor(.text, for: .normal)
            setTitleColor(.textDisabled, for: .disabled)
            contentHorizontalAlignment = .right
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class LevelButton: MenuButton {
        var level = 0 {
            didSet {
                setTitle("\(level)", for: .normal)
            }
        }
        
        override var isEnabled: Bool {
            didSet {
                backgroundColor = isEnabled ? .light : .lightDisabled
            }
        }
        
        required init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .light
            layer.cornerRadius = 2
            contentHorizontalAlignment = .center
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}

