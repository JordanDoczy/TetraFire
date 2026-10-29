//
//  UserData.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/29/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import Foundation

extension Constants {
    struct UserData {
        static let ActivePiece             = "ActivePiece"
        static let BackgroundMusicOff      = "BackgroundMusicOff"
        static let GameMode                = "GameMode"
        static let GridModel               = "GridModel"
        static let HeldPiece               = "HeldPiece"
        static let HighestLevelClassicMode = "HighestLevelClassicMode"
        static let HighestLevelFireMode    = "HighestLevelFireMode"
        static let Level                   = "Level"
        static let Score                   = "Score"
        static let SidePanelModel          = "SidePanelModel"
        static let SoundChoiceMade         = "SoundChoiceMade"
        static let SoundEffectsOff         = "SoundEffectsOff"
        static let SkipTutorial            = "SkipTutorial"
        static let TopScore                = "TopScore"
        static let VersionNumber           = "VersionNumber"
        static let VibrateOff              = "VibrateOff"
    }
}

class UserData {
    let constants = Constants.UserData.self
    
    static var shared = UserData()

    // Injectable so tests can save and load without touching the player's real data.
    let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var activePiece: PieceModel? {
        get { return loadArchive(forKey: constants.ActivePiece, allowing: [PieceModel.self]) }
        set { saveArchive(newValue, forKey: constants.ActivePiece) }
    }
    
    // store the inverse so it defaults to true
    var backgroundMusic: Bool {
        get {
            return !defaults.bool(forKey: constants.BackgroundMusicOff)
        }
        set {
            defaults.set(!newValue, forKey: constants.BackgroundMusicOff)
        }
    }
    
    var gameMode: GameMode {
        get {
            return GameMode(rawValue:defaults.integer(forKey: constants.GameMode)) ?? .classic
        }
        set {
            defaults.set(newValue.rawValue, forKey: constants.GameMode)
        }
    }
    
    var gridModel: GridModel {
        get {
            guard defaults.data(forKey: constants.GridModel) != nil else {
                clearData()
                return GridModelFactory.emptyModel
            }
            return loadArchive(forKey: constants.GridModel, allowing: [GridModel.self]) ?? GridModelFactory.emptyModel
        }
        set { saveArchive(newValue, forKey: constants.GridModel) }
    }
 
    var heldPiece: PieceModel? {
        get { return loadArchive(forKey: constants.HeldPiece, allowing: [PieceModel.self]) }
        set { saveArchive(newValue, forKey: constants.HeldPiece) }
    }
    
    var highestLevelClassicMode: Int {
        get {
            let value = defaults.integer(forKey: constants.HighestLevelClassicMode)
            return value > 0 ? value : 1
        }
        set {
            if newValue > highestLevelClassicMode {
                defaults.set(newValue, forKey: constants.HighestLevelClassicMode)
            }
        }
    }
    
    var highestLevelFireMode: Int {
        get {
            let value = defaults.integer(forKey: constants.HighestLevelFireMode)
            return value > 0 ? value : 1
        }
        set {
            if newValue > highestLevelFireMode {
                defaults.set(newValue, forKey: constants.HighestLevelFireMode)
            }
        }
    }
    
    var level: Int {
        get {
            let level = defaults.integer(forKey: constants.Level)
            return level > 0 ? level : 1
        }
        set {
            switch(gameMode) {
            case .classic:
                if newValue > highestLevelClassicMode {
                    highestLevelClassicMode = newValue
                }
            case .fire:
                if newValue > highestLevelFireMode {
                    highestLevelFireMode = newValue
                }
            }
            
            defaults.set(newValue, forKey: constants.Level)
        }
    }
    
    var sidePanelModel: SidePanelModel {
        // The panel holds an array of pieces, so that class must be allowed too.
        get { return loadArchive(forKey: constants.SidePanelModel, allowing: [SidePanelModel.self, PieceModel.self]) ?? SidePanelModel() }
        set { saveArchive(newValue, forKey: constants.SidePanelModel) }
    }
    
    var score: Int {
        get {
            return defaults.integer(forKey: constants.Score)
        }
        set {
            defaults.set(newValue, forKey: constants.Score)
        }
    }
    
    // store the inverse so it defaults to true
    var soundEffects: Bool {
        get {
            return !defaults.bool(forKey: constants.SoundEffectsOff)
        }
        set {
            defaults.set(!newValue, forKey: constants.SoundEffectsOff)
        }
    }
    
    var soundChoiceMade: Bool {
        get {
            return defaults.bool(forKey: constants.SoundChoiceMade)
        }
        set {
            defaults.set(newValue, forKey: constants.SoundChoiceMade)
        }
    }

    // New players pick sound on or off on the welcome screen before any music plays.
    // Anyone who already finished or skipped the tutorial (including 1.5 players) isn't asked.
    var needsSoundChoice: Bool {
        return !soundChoiceMade && !skipTutorial
    }

    func chooseSound(_ on: Bool) {
        backgroundMusic = on
        soundEffects = on
        soundChoiceMade = true
    }

    var skipTutorial: Bool {
        get {
            return defaults.bool(forKey: constants.SkipTutorial)
        }
        set {
            defaults.set(newValue, forKey: constants.SkipTutorial)
        }
    }
    
    var topScore: Int {
        get {
            return defaults.integer(forKey: constants.TopScore)
        }
        set {
            defaults.set(newValue, forKey: constants.TopScore)
        }
    }

    var versionNumber: String? {
        get {
            return defaults.string(forKey: constants.VersionNumber)
        }
        set {
            defaults.set(newValue, forKey: constants.VersionNumber)
        }
    }
    
    // store the inverse so it defaults to true
    var vibrate: Bool {
        get {
            return !defaults.bool(forKey: constants.VibrateOff)
        }
        set {
            defaults.set(!newValue, forKey: constants.VibrateOff)
        }
    }
    
    // Saves from 1.5 were archived without requiring secure coding, but the classes
    // support it, so they still decode here.
    private func loadArchive<T: NSObject>(forKey key: String, allowing classes: [AnyClass]) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: classes + [NSArray.self, NSNull.self], from: data) as? T
        } catch {
            print(error)
            return nil
        }
    }

    private func saveArchive(_ object: NSObject?, forKey key: String) {
        guard let object else {
            defaults.removeObject(forKey: key)
            return
        }
        do {
            defaults.set(try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true), forKey: key)
        } catch {
            print(error)
        }
    }

    func clearData() {
        activePiece = nil
        gridModel = GridModelFactory.emptyModel
        sidePanelModel = SidePanelModel()
        heldPiece = nil
        versionNumber = Bundle.main.versionNumber
    }
}
