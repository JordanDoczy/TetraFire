//
//  Enums.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/9/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

enum BlockType {
    
    case active(color: Color)
    case inactive(color: Color)
    case ghost(color: Color)
    case effect(effect: EffectType)
    
    var rawValue: [Int] {
        switch self {
        case .active(let color):
            return [0, color.rawValue]
        case .inactive(let color):
            return [1, color.rawValue]
        case .ghost(let color):
            return [2, color.rawValue]
        case .effect(let effect):
            return [3, effect.rawValue]
        }
    }
    
    init?(rawValue: [Int]) {
        guard rawValue.count == 2 else { return nil }
        
        let blockType = rawValue[0]
        let subType = rawValue[1]
        
        switch blockType {
        case 0:
            guard let color = Color(rawValue: subType) else { return nil }
            self = .active(color: color)
        case 1:
            guard let color = Color(rawValue: subType) else { return nil }
            self = .inactive(color: color)
        case 2:
            guard let color = Color(rawValue: subType) else { return nil }
            self = .ghost(color: color)
        case 3:
            guard let effect = EffectType(rawValue: subType) else { return nil }
            self = .effect(effect: effect)
        default:
            return nil
        }
    }

    var color: UIColor? {
        switch self {
        case .active(let color): return color.uiColor
        case .inactive(let color): return color.uiColor
        case .ghost(let color): return color.uiColor.asGhost
        case .effect(_): return nil
        }
    }
}

enum Color: Int {
    case purple
    case pink
    case red
    case green
    case orange
    case yellow
    case blue
    
    var uiColor: UIColor {
        switch self {
        case .purple: return .tetraPurple
        case .pink: return .tetraPink
        case .red: return .tetraRed
        case .green: return .tetraGreen
        case .orange: return .tetraOrange
        case .yellow: return .tetraYellow
        case .blue: return .tetraBlue
        }
    }
    
    static func getRandom() -> Color {
        let random = arc4random() % 7 + 1
        guard let color = Color(rawValue: Int(random)) else {
            return .purple
        }
        
        return color
    }
}

enum Direction: Int {
    case backward
    case forward
}

enum EffectType: Int {
    case dust = 1
    case explosion
    case fire
    case rain
    case smoke
    
    var fileName: String {
        switch(self){
        case .dust: return Assets.Effects.dust
        case .explosion: return Assets.Effects.explosion
        case .fire: return Assets.Effects.fire
        case .rain: return Assets.Effects.rain
        case .smoke: return Assets.Effects.smoke
        }
    }
}

enum GameMode: Int {
    case classic
    case fire
    
    func description() -> String {
        switch(self) {
        case .classic:
            return Strings.classicMode
        case .fire:
            return Strings.fireMode
        }
    }
}

enum GameState: Int {
    case gameOver
    case inPlay
    case newGame
    case paused
    case setPiece
    case tutorial
    case youWin
}

enum Orientation: Int {
    case up
    case down
    case left
    case right
}

enum TimerState: Int {
    case update
    case drop
    case hold
}
