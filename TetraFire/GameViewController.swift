//
//  GameViewController.swift
//  TetraFire
//
//  Created by Jordan Doczy on 9/5/17.
//  Copyright © 2017 Jordan Doczy. All rights reserved.
//

import AVFoundation
import SpriteKit
import UIKit

extension Constants {
    struct GameViewController {
        static let timerActionKey = "timerActionKey"
        static let showTutorialSegue = "showTutorialSegue"
    }
}

class GameViewController: UIViewController, HUDViewDataSource {

    let constants = Constants.GameViewController.self
    
    // MARK: - Models
    fileprivate var activePiece = UserData.shared.activePiece
    fileprivate var gameMode = UserData.shared.gameMode
    fileprivate var gridModel = UserData.shared.gridModel
    fileprivate var heldPiece = UserData.shared.heldPiece
    fileprivate(set) var level = UserData.shared.level
    fileprivate var previousLevel = 0
    fileprivate(set) var score = UserData.shared.score
    fileprivate var sidePanelModel = UserData.shared.sidePanelModel
    fileprivate var vibrate = UserData.shared.vibrate
    
    // MARK: - Member Vars
    fileprivate var didSwap: Bool = false
    fileprivate var gameState = GameState.gameOver
    fileprivate var longPressState: UIGestureRecognizerState = .ended
    fileprivate var panLocation: CGPoint?
    fileprivate var scoreOffset: Int = 0
    fileprivate var timerDropInterval = 0.015
    fileprivate var timerHoldInterval = 0.1
    fileprivate var timerState = TimerState.update

    // MARK: - Computed Vars
    var boxWidth: CGFloat {
        return gridView.boxWidth
    }

    fileprivate var columnWidth: CGFloat {
        return floor(view.frame.width / 17)
    }

    fileprivate var offset: CGFloat {
        return (view.frame.height <= 480) ? 10 : 30
    }
    
    fileprivate var particleScene: ParticleScene? {
        return (UIApplication.shared.delegate as? AppDelegate)?.particleScene
    }
    
    fileprivate var timerUpdateInterval: TimeInterval {
        switch gameMode {
        case .classic:
            return Constants.slowestSpeed - ((Constants.slowestSpeed - Constants.fastestSpeed) / Double(Constants.maxLevelClassicMode - 1) * Double(level - 1))
        case .fire:
            return Constants.slowestSpeed
        }
    }
    
    // MARK: - Views
    fileprivate lazy var backgroundView: BackgroundView = { [unowned self] in
        let backgroundView = BackgroundView(frame: self.view.frame)
        backgroundView.isUserInteractionEnabled = false
        return backgroundView
        }()
    
    fileprivate lazy var flashView: UIView = { [unowned self] in
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = .white
        view.alpha = 0
        view.isUserInteractionEnabled = false
        return view
        }()
    
    fileprivate lazy var gameOverView: GameOverView = { [unowned self] in
        let gameOverView = GameOverView(frame: CGRect(x: 0, y: 0,
                                                      width: self.view.frame.width * 0.7,
                                                      height: self.view.frame.width * 0.5))
        gameOverView.center = self.view.center
        gameOverView.isHidden = true
        gameOverView.delegate = self
        return gameOverView
        
        }()
    
    fileprivate lazy var gridView: TetraFireGridView = { [unowned self] in
        let width: CGFloat = self.columnWidth * CGFloat(Constants.columns)
        let height: CGFloat = width * CGFloat(Constants.rows) / CGFloat(Constants.columns)
        let x = self.offset
        let y = self.view.frame.height - height - self.offset
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let gridView = TetraFireGridView(columns: Constants.columns,
                                        rows: Constants.rows,
                                        frame: frame)
        gridView.dataSource = self
        gridView.delegate = self
        return gridView
        }()
    
    fileprivate lazy var holdView: HoldView = { [unowned self] in
        let width = self.columnWidth * 4
        let height = self.view.frame.height <= 480 ? self.columnWidth * 4 : self.columnWidth * 5
        var y = self.gridView.frame.origin.y - height - self.offset
        let holdView = HoldView(frame: CGRect(x: 0, y: y, width: width , height: height))
        holdView.center.x = self.view.center.x
        holdView.blockSize = CGSize(width: self.columnWidth, height: self.columnWidth)
        holdView.dataSource = self
        return holdView
        }()
    
    fileprivate lazy var hudView: HUDView = { [unowned self] in
        let hudView = HUDView(frame: self.view.frame)
        hudView.dataSource = self
        hudView.delegate = self
        hudView.isUserInteractionEnabled = true
        return hudView
        }()
    
    fileprivate lazy var levelView: LevelView = { [unowned self] in
        let levelView = LevelView(frame: CGRect(origin: .zero,
                                                size: CGSize(width: self.view.frame.width/2,
                                                             height: self.view.frame.width/6)))
        return levelView
        }()
    
    fileprivate lazy var menuView: MenuView = { [unowned self] in
        let menuView = MenuView(frame: self.view.frame,
                                classicLevelCount: Constants.maxLevelClassicMode,
                                fireLevelCount: Constants.maxLevelFireMode)
        menuView.delegate = self
        menuView.dataSource = self
        return menuView
        }()
    
    fileprivate lazy var overlayView: UIView = { [unowned self] in
        let ovelayView = UIView(frame: self.view.frame)
        ovelayView.backgroundColor = .darkDisabled
        ovelayView.isUserInteractionEnabled = false
        return ovelayView
        }()
    
    fileprivate lazy var particleView: SKView = { [unowned self] in
        let particleView = SKView()
        particleView.frame.origin = .zero
        particleView.isUserInteractionEnabled = false
        particleView.ignoresSiblingOrder = true
        particleView.allowsTransparency = true
        particleView.layer.zPosition = 1000
        particleView.frame.size = self.view.frame.size
        return particleView
        }()
    
    fileprivate lazy var sidePanelView:SidePanelView = { [unowned self] in
        let panelWidth: CGFloat = self.columnWidth * 3
        let panelHeight: CGFloat = self.columnWidth * CGFloat(Constants.rows)
        var xOffset: CGFloat = (self.view.frame.width - self.gridView.frame.origin.x - self.gridView.frame.width - panelWidth) / 2
        let sidePanelView = SidePanelView(frame: CGRect(x: self.view.frame.width - panelWidth - xOffset,
                                                        y: self.view.frame.height - panelHeight - self.offset,
                                                        width: panelWidth,
                                                        height: panelHeight))
        sidePanelView.blockSize = CGSize(width: self.columnWidth, height: self.columnWidth)
        sidePanelView.dataSource = self.sidePanelModel
        return sidePanelView
        }()

    // MARK: - Methods
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGestures()
        addSubviews()
     
        hudView.update()
        gridView.update()
        sidePanelView.update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.startAnimating()
        
        if UserData.shared.skipTutorial {
            menuView.show()
        } else {
            tutorial()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        backgroundView.stopAnimating()
    }
    
    // MARK: - Set Up Methods
    fileprivate func addGestures() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(sender:))))
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0.25
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    fileprivate func addSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(flashView)
        view.addSubview(overlayView)
        view.addSubview(gridView)
        view.addSubview(sidePanelView)
        view.addSubview(holdView)
        view.addSubview(hudView)
        view.addSubview(menuView)
        view.addSubview(gameOverView)
        view.addSubview(particleView)
        
        gridView.addSubview(levelView)
        
        particleView.presentScene(particleScene)
    }
    
    // MARK: - Animation Methods
    fileprivate func flash() {
        UIView.animate(withDuration: 0.15,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.flashView.alpha = 1
            },
                       completion: { [weak self] success in
                        
                        UIView.animate(withDuration: 0.15,
                                       delay: 0.0,
                                       options: .curveEaseOut,
                                       animations: { [weak self] in
                                        self?.flashView.alpha = 0
                            },
                                       completion: nil)
        })
    }

    fileprivate func fourLineAnimation() {
        
        if vibrate {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: gridView.center.x - 5, y: gridView.center.y - 5))
        animation.toValue = NSValue(cgPoint: CGPoint(x: gridView.center.x + 5, y: gridView.center.y + 5))
        gridView.layer.add(animation, forKey: "position")
        
        flash()
    }
    
    // MARK: - Game Methods
    fileprivate func didIncreaseLevel() -> Bool {
        guard gameState != .gameOver else {
            return false
        }
        
        var result = false
        
        if shouldIncreaseLevel() {
            switch gameMode {
            case .classic:
                if level < Constants.maxLevelClassicMode {
                    level += 1
                    levelView.level = level
                    result = true
                }
            case .fire:
                if level == Constants.maxLevelFireMode {
                    gameState = .youWin
                    gridView.youWin()
                } else {
                    level += 1
                    levelView.level = level
                    gridView.clearAllRows()
                    gridModel = GridModelFactory.modelForLevel(level)
                    heldPiece = nil
                    holdView.update()
                    result = true
                }
            }
        }
        
        return result
    }
    
    fileprivate func gameOver() {
        gameState = .gameOver
        previousLevel = level
        
        if score > UserData.shared.topScore {
            UserData.shared.topScore = score
            gameOverView.showWithTopScore(topScore: score)
        } else {
            gameOverView.show()
        }
        
        reset()
        particleScene?.removeAllChildren()
        holdView.update()
        stopTimer()
        
        gridView.hide()
        sidePanelView.hide()
        hudView.hide()
        holdView.hide()
    }
    
    fileprivate func holdPiece() {
        guard didSwap == false else { return }
        
        activePiece?.gridPosition = (row: 0, column: 0)
        let currentHeldPiece = heldPiece
        heldPiece = activePiece
        holdView.update()
        nextPiece(piece: currentHeldPiece)
        didSwap = true
    }
    
    func incrementRow() {
        guard gameState == .inPlay else{
            return
        }
        
        guard let activePiece = activePiece else { return }
        
        var gridPosition = activePiece.gridPosition
        gridPosition.row += 1
        
        let gridPositions = activePiece.getGridPositions(at: gridPosition)
        if gridModel.isValidMove(gridPositions: gridPositions) {
            activePiece.gridPosition = gridPosition
            updateGridModelWithActivePiece(activePiece: activePiece)
        } else {
            startTimer(with: .hold)
        }
    }
    
    fileprivate func nextPiece(piece: PieceModel? = nil) {
        gameState = .inPlay
        
        activePiece = piece ?? sidePanelModel.next()
        sidePanelView.update()
        
        guard let activePiece = activePiece else { return }
        activePiece.orientation = .left
        let minimumValue = activePiece.left.map { $0.row }.min() ?? 0
        let row = 0 - minimumValue
        let column = 4
        activePiece.gridPosition = (row: row, column: column)

        if gridModel.isValidMove(gridPositions: activePiece.gridPositions) {
            updateGridModelWithActivePiece(activePiece: activePiece)
        } else {
            gameOver()
        }
    }
    
    func pauseGame() {
        gameState = .paused
        
        stopTimer()
        saveState()
        menuView.show()
    }
    
    fileprivate static func pointsNeededForLevel(level: Int) -> Int {
        var points = 0
        var level = level
        while level > 1 {
            points += level * 1000
            level -= 1
        }
        return points
    }
    
    fileprivate func reset() {
        activePiece = nil
        gridModel = GridModelFactory.emptyModel
        heldPiece = nil
        level = 1
        score = 0
        sidePanelModel.reset()
    }
    
    fileprivate func saveState() {
        UserData.shared.activePiece = activePiece
        UserData.shared.gameMode = gameMode
        UserData.shared.gridModel = gridModel
        UserData.shared.heldPiece = heldPiece
        UserData.shared.level = level
        UserData.shared.score = score
        UserData.shared.sidePanelModel = sidePanelModel
    }
    
    fileprivate static func getPoints(numberOfCompletedRows: Int) -> Int {
        switch(numberOfCompletedRows) {
        case 0: return 10
        case 1: return 100
        case 2: return 250
        case 3: return 500
        case 4: return 1000
        default: return 0
        }
    }
    
    func setPiece() {
        guard let activePiece = activePiece else {
            return
        }

        gameState = .setPiece
        
        gridModel.removeActiveBlocks()
        gridModel.setValues(.block(color: activePiece.color), at: activePiece.gridPositions)
        
        AudioManager.shared.playSound(fileName: Assets.Sounds.thud)
        didSwap = false
        
        stopTimer()
        timerState = .update
        
        let completedRows = gridModel.getCompletedRows()
        score += GameViewController.getPoints(numberOfCompletedRows: completedRows.count)
        
        if completedRows.count > 0 {
            gridModel.dropRows(rows: completedRows)
            gridView.clearRows(rows: completedRows)
            
            if completedRows.count == 4 {
                fourLineAnimation()
                AudioManager.shared.playSound(fileName: Assets.Sounds.fourLine)
            } else {
                AudioManager.shared.playSound(fileName: Assets.Sounds.line)
            }
        } else {
            nextPiece()
            resumeTimer()
        }
        
        _ = didIncreaseLevel()
        hudView.update()
    }
    
    fileprivate func shouldIncreaseLevel() -> Bool {
        switch(gameMode) {
        case .classic:
            return score + scoreOffset >= GameViewController.pointsNeededForLevel(level: level + 1)
        case .fire:
            return !gridModel.hasFire()
        }
    }
    
    fileprivate func startGame() {
        startTimer(with: .update)
    }
    
    fileprivate func updateGridModelWithActivePiece(activePiece: PieceModel) {
        guard gameState == .inPlay else {
            return
        }
        
        if timerState == .hold {
            stopTimer()
            timerState = .update
        }
        
        self.activePiece = activePiece
        gridModel.removeActiveBlocks()
        gridModel.setValues(.activeBlock(color: activePiece.color), at: activePiece.gridPositions)
        gridView.update()
    }

    // MARK: - Timer Methods
    fileprivate func resumeTimer() {
        if particleScene?.action(forKey: constants.timerActionKey) == nil {
            startTimer(with: timerState)
        }
    }
    
    fileprivate func startTimer(with timerState: TimerState) {
        stopTimer()
        
        switch(timerState) {
        case .drop:
            let delay = SKAction.wait(forDuration: timerDropInterval)
            let selector = SKAction.perform(#selector(incrementRow), onTarget: self)
            let sequenceAction = SKAction.sequence([delay, selector])
            let repeatAction = SKAction.repeatForever(sequenceAction)
            particleScene?.run(repeatAction, withKey: constants.timerActionKey)
        case .hold:
            let delay = SKAction.wait(forDuration: timerHoldInterval)
            let selector = SKAction.perform(#selector(setPiece), onTarget: self)
            let sequenceAction = SKAction.sequence([delay, selector])
            particleScene?.run(sequenceAction, withKey: constants.timerActionKey)
        case .update:
            let delay = SKAction.wait(forDuration: timerUpdateInterval)
            let selector = SKAction.perform(#selector(incrementRow), onTarget: self)
            let sequenceAction = SKAction.sequence([delay, selector])
            let repeatAction = SKAction.repeatForever(sequenceAction)
            particleScene?.run(repeatAction, withKey: constants.timerActionKey)
        }
        
        self.timerState = timerState
    }
    
    fileprivate func stopTimer() {
        particleScene?.removeAction(forKey: constants.timerActionKey)
    }
    
    // MARK: - Gesture Recognizers
    func onLongPress(sender: UILongPressGestureRecognizer) {
        guard gameState == .inPlay else {
            return
        }

        switch(sender.state) {
        case .began:
            startTimer(with: .drop)
            longPressState = .began
        case .ended:
            startTimer(with: .update)
            longPressState = .ended
        default:
            longPressState = .ended
        }
    }
    
    func onPan(sender: UIPanGestureRecognizer) {
        guard gameState == .inPlay else{
            return
        }
        
        guard let activePiece = activePiece else { return }
        let currentGridPosition = activePiece.gridPosition
        
        
        if let y = panLocation?.y, y - sender.location(in: view).y > 50 {
            holdPiece()
        } else if let x = panLocation?.x {
            if abs(x - sender.location(in: view).x) >= boxWidth / 2 {
                if x - sender.location(in: view).x >= 0 {
                    activePiece.gridPosition.column -= 1
                } else {
                    activePiece.gridPosition.column += 1
                }
                
                if gridModel.isValidMove(gridPositions: activePiece.gridPositions) {
                    updateGridModelWithActivePiece(activePiece: activePiece)
                } else {
                    activePiece.gridPosition = currentGridPosition
                }
                
                panLocation = sender.location(in: view)
            }
        }
    }
    
    func onTap(sender: UITapGestureRecognizer) {
        guard gameState == .inPlay else {
            return
        }
        
        guard let activePiece = activePiece else { return }
        activePiece.rotate()
        
        var gridPositionsToTest = [activePiece.gridPosition,
                             (row: activePiece.gridPosition.row, column: activePiece.gridPosition.column - 1),
                             (row: activePiece.gridPosition.row, column: activePiece.gridPosition.column + 1),
                             (row: activePiece.gridPosition.row - 1, column: activePiece.gridPosition.column),
                             (row: activePiece.gridPosition.row - 1, column: activePiece.gridPosition.column - 1),
                             (row: activePiece.gridPosition.row - 1, column: activePiece.gridPosition.column + 1)]
        
        if activePiece.gridPosition.row < 0 {
            gridPositionsToTest.append((row: 0, column: activePiece.gridPosition.column))
        }
        
        for gridPosition in gridPositionsToTest {
            let gridPositions = activePiece.getGridPositions(at: gridPosition)
            
            if gridModel.isValidMove(gridPositions: gridPositions) {
                activePiece.gridPosition = gridPosition
                updateGridModelWithActivePiece(activePiece: activePiece)
                AudioManager.shared.playSound(fileName: Assets.Sounds.click)
                return
            }
        }

        // rotation unsuccessful
        activePiece.rotate(direction: .backward)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        panLocation = touches.first?.location(in: view)
    }
}

extension GameViewController: GameOverViewDelegate {
    func playAgain() {
        gameOverView.hide()
        newGame(gameMode: gameMode, level: previousLevel)
    }
    
    func quit() {
        gameOverView.hide()
        menuView.show()
    }
}

extension GameViewController: GridViewDataSource {
    func value(at position: GridPosition) -> BlockType? {
        return gridModel.value(at: position)
    }
}

extension GameViewController: GridViewDelegate {
    func gridViewDidUpdate(gridView: GridView) {
        resumeTimer()
        
        if gameState == .setPiece {
            nextPiece()
        }
    }
}

extension GameViewController: HoldViewDataSource {
    func getPieceModel() -> PieceModel? {
        return heldPiece
    }
}

extension GameViewController: HUDViewDelegate {
    func showMenu() {
        menuView.show()
    }
}

extension GameViewController: MenuViewDelegate {
    
    func menuDidHide(menuView: MenuView) {
        switch gameState {
        case .tutorial:
            break
            // performSegue(withIdentifier: constants.showTutorialSegue, sender: nil)
        default:
            gridView.update()
            gridView.show()
            sidePanelView.show()
            hudView.show()
            holdView.show()
        }
    }
    
    func menuDidShow(menuView: MenuView) {
        print("menuDidShow")
    }
    
    func menuWillHide(menuView: MenuView) {
        print("menuWillHide")
    }
    
    func menuWillShow(menuView: MenuView) {
        particleScene?.removeAllChildren()
        
        gridView.isHidden = true
        sidePanelView.isHidden = true
        hudView.isHidden = true
        holdView.isHidden = true
    }
    
    func newGame(gameMode: GameMode, level: Int = 1) {
        reset()
        
        self.gameMode = gameMode
        self.level = level
        score = gameMode == .classic ? 0 : -1
        scoreOffset = GameViewController.pointsNeededForLevel(level: level)
        
        switch gameMode {
        case .classic:
            gridModel = GridModelFactory.emptyModel
        case .fire:
            gridModel = GridModelFactory.modelForLevel(level)
        }
        
        menuView.hide()
        hudView.update()
        holdView.update()
        levelView.level = level
        
        nextPiece()
        startGame()
    }
    
    func resumeGame() {
         gameState = .inPlay
        
        menuView.hide()
        hudView.update()
        gridView.update()
        sidePanelView.update()
        
        startTimer(with: .update)
    }
    
    func tutorial() {
        gameState = .tutorial
        menuView.hide()
    }
}

extension GameViewController: MenuViewDataSource {
    var canResumeGame: Bool {
        return gridModel.isEmpty() == false
    }
    
    func maxLevelAchieved(for gameMode: GameMode) -> Int {
        switch gameMode {
        case .classic: return UserData.shared.highestLevelClassicMode
        case .fire: return UserData.shared.highestLevelFireMode
        }
    }
}
