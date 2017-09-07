//
//  UserData.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/29/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import Foundation

class UserData {
    static var shared = UserData()

    struct Constants {
        static let ActivePiece:String           = "ActivePiece"
        static let BackgroundMusicOff:String    = "BackgroundMusicOff"
        static let GameMode:String              = "GameMode"
        static let GridModel:String             = "GridModel"
        static let HeldPiece:String             = "HeldPiece"
        static let HighestLevelClassicMode      = "HighestLevelClassicMode"
        static let HighestLevelFireMode         = "HighestLevelFireMode"
        static let Level:String                 = "Level"
        static let Score:String                 = "Score"
        static let SidePanelModel:String        = "SidePanelModel"
        static let SoundEffectsOff:String       = "SoundEffectsOff"
        static let SkipTutorial:String          = "SkipTutorial"
        static let TopScore:String              = "TopScore"
        static let VibrateOff:String            = "VibrateOff"
    }
    
    var activePiece: PieceModel? {
        get {
            guard let data = UserDefaults.standard.object(forKey: Constants.ActivePiece) as? Data else {
                return nil
            }
            
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? PieceModel ?? nil
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: Constants.ActivePiece)
                return
            }
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue),
                                      forKey: Constants.ActivePiece)
        }
    }
    
    // store the inverse so it defaults to true
    var backgroundMusic: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: Constants.BackgroundMusicOff)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: Constants.BackgroundMusicOff)
        }
    }
    
    var gameMode: GameMode {
        get {
            return GameMode(rawValue:UserDefaults.standard.integer(forKey: Constants.GameMode)) ?? .classic
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.GameMode)
        }
    }
    
    var gridModel: GridModel {
        get {
            if let data = UserDefaults.standard.object(forKey: Constants.GridModel) as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? GridModel ?? GridModelFactory.emptyModel
            }
            
            return GridModelFactory.emptyModel
        }
        set {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: Constants.GridModel)
        }
    }
    
    var heldPiece: PieceModel? {
        get {
            guard let data = UserDefaults.standard.object(forKey: Constants.HeldPiece) as? Data else {
                return nil
            }
            
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? PieceModel ?? nil
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: Constants.HeldPiece)
                return
            }
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue),
                                      forKey: Constants.HeldPiece)
        }
    }
    
    var highestLevelClassicMode: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: Constants.HighestLevelClassicMode)
            return value > 0 ? value : 1
        }
        set {
            if newValue > highestLevelClassicMode {
                UserDefaults.standard.set(newValue, forKey: Constants.HighestLevelClassicMode)
            }
        }
    }
    
    var highestLevelFireMode: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: Constants.HighestLevelFireMode)
            return value > 0 ? value : 1
        }
        set {
            if newValue > highestLevelFireMode {
                UserDefaults.standard.set(newValue, forKey: Constants.HighestLevelFireMode)
            }
        }
    }
    
    var level: Int {
        get {
            let level = UserDefaults.standard.integer(forKey: Constants.Level)
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
            
            UserDefaults.standard.set(newValue, forKey: Constants.Level)
        }
    }
    
    var sidePanelModel: SidePanelModel {
        get {
            if let data = UserDefaults.standard.object(forKey: Constants.SidePanelModel) as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? SidePanelModel ?? SidePanelModel()
            }
            
            return SidePanelModel()
        }
        set {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: Constants.SidePanelModel)
        }
    }
    
    var score: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Score)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.Score)
        }
    }
    
    // store the inverse so it defaults to true
    var soundEffects: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: Constants.SoundEffectsOff)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: Constants.SoundEffectsOff)
        }
    }
    
    var skipTutorial: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.SkipTutorial)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.SkipTutorial)
        }
    }
    
    var topScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.TopScore)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.TopScore)
        }
    }

    // store the inverse so it defaults to true
    var vibrate: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: Constants.VibrateOff)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: Constants.VibrateOff)
        }
    }
    
    func clearData() {
        gridModel = GridModelFactory.emptyModel
        sidePanelModel = SidePanelModel()
        score = 0
        heldPiece = nil
        level = 1
    }
}
