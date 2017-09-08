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
        static let ActivePiece           = "ActivePiece"
        static let BackgroundMusicOff    = "BackgroundMusicOff"
        static let GameMode              = "GameMode"
        static let GridModel             = "GridModel"
        static let HeldPiece             = "HeldPiece"
        static let HighestLevelClassicMode      = "HighestLevelClassicMode"
        static let HighestLevelFireMode         = "HighestLevelFireMode"
        static let Level                 = "Level"
        static let Score                 = "Score"
        static let SidePanelModel        = "SidePanelModel"
        static let SoundEffectsOff       = "SoundEffectsOff"
        static let SkipTutorial          = "SkipTutorial"
        static let TopScore              = "TopScore"
        static let VersionNumber         = "VersionNumber"
        static let VibrateOff            = "VibrateOff"
    }
}

class UserData {
    let constants = Constants.UserData.self
    
    static var shared = UserData()

    var activePiece: PieceModel? {
        get {
            guard let versionNumber = versionNumber,
                versionNumber == Constants.currentVersion,
                let data = UserDefaults.standard.object(forKey: constants.ActivePiece) as? Data else {
                return nil
            }
            
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? PieceModel ?? nil
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: constants.ActivePiece)
                return
            }
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue),
                                      forKey: constants.ActivePiece)
        }
    }
    
    // store the inverse so it defaults to true
    var backgroundMusic: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: constants.BackgroundMusicOff)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: constants.BackgroundMusicOff)
        }
    }
    
    var gameMode: GameMode {
        get {
            return GameMode(rawValue:UserDefaults.standard.integer(forKey: constants.GameMode)) ?? .classic
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: constants.GameMode)
        }
    }
    
    var gridModel: GridModel {
        get {
            guard let versionNumber = versionNumber,
            versionNumber == Constants.currentVersion,
                let data = UserDefaults.standard.object(forKey: constants.GridModel) as? Data else {
                    clearData()
                    return GridModelFactory.emptyModel
            }
            
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? GridModel ?? GridModelFactory.emptyModel
        }
        set {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: constants.GridModel)
        }
    }
    
    var heldPiece: PieceModel? {
        get {
            guard let versionNumber = versionNumber,
                versionNumber == Constants.currentVersion,
                let data = UserDefaults.standard.object(forKey: constants.HeldPiece) as? Data else {
                    return nil
            }
            
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? PieceModel ?? nil
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: constants.HeldPiece)
                return
            }
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue),
                                      forKey: constants.HeldPiece)
        }
    }
    
    var highestLevelClassicMode: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: constants.HighestLevelClassicMode)
            return value > 0 ? value : 1
        }
        set {
            if newValue > highestLevelClassicMode {
                UserDefaults.standard.set(newValue, forKey: constants.HighestLevelClassicMode)
            }
        }
    }
    
    var highestLevelFireMode: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: constants.HighestLevelFireMode)
            return value > 0 ? value : 1
        }
        set {
            if newValue > highestLevelFireMode {
                UserDefaults.standard.set(newValue, forKey: constants.HighestLevelFireMode)
            }
        }
    }
    
    var level: Int {
        get {
            let level = UserDefaults.standard.integer(forKey: constants.Level)
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
            
            UserDefaults.standard.set(newValue, forKey: constants.Level)
        }
    }
    
    var sidePanelModel: SidePanelModel {
        get {
            guard let versionNumber = versionNumber,
            versionNumber == Constants.currentVersion,
                let data = UserDefaults.standard.object(forKey: constants.SidePanelModel) as? Data else {
                    return SidePanelModel()
            }
            
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? SidePanelModel ?? SidePanelModel()
        }
        set {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: constants.SidePanelModel)
        }
    }
    
    var score: Int {
        get {
            return UserDefaults.standard.integer(forKey: constants.Score)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: constants.Score)
        }
    }
    
    // store the inverse so it defaults to true
    var soundEffects: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: constants.SoundEffectsOff)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: constants.SoundEffectsOff)
        }
    }
    
    var skipTutorial: Bool {
        get {
            return UserDefaults.standard.bool(forKey: constants.SkipTutorial)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: constants.SkipTutorial)
        }
    }
    
    var topScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: constants.TopScore)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: constants.TopScore)
        }
    }

    var versionNumber: String? {
        get {
            return UserDefaults.standard.string(forKey: constants.VersionNumber)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: constants.VersionNumber)
        }
    }
    
    // store the inverse so it defaults to true
    var vibrate: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: constants.VibrateOff)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: constants.VibrateOff)
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
