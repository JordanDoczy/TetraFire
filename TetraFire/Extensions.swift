//
//  UIViewExtension.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/25/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

extension BlockType: Equatable {
    static func == (lhs: BlockType, rhs: BlockType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}

extension UIColor {
    static let tetraPurple = #colorLiteral(red: 0.6, green: 0.2823529412, blue: 0.9411764706, alpha: 0.8)
    static let tetraPink   = #colorLiteral(red: 0.7411764706, green: 0.1490196078, blue: 0.7098039216, alpha: 0.8)
    static let tetraRed    = #colorLiteral(red: 0.9490196078, green: 0.1450980392, blue: 0.5058823529, alpha: 0.8)
    static let tetraGreen  = #colorLiteral(red: 0.1882352941, green: 0.7490196078, blue: 0.5215686275, alpha: 0.8)
    static let tetraOrange = #colorLiteral(red: 0.9490196078, green: 0.6117647059, blue: 0.3333333333, alpha: 0.8)
    static let tetraYellow = #colorLiteral(red: 0.9568627451, green: 0.8431372549, blue: 0.3843137255, alpha: 0.8)
    static let tetraBlue   = #colorLiteral(red: 0.09411764706, green: 0.5921568627, blue: 0.9411764706, alpha: 0.8)
    
    static let black         = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let dark          = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    static let darkDisabled  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)
    static let extraDark     = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
    static let extraLight    = #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 0.25)
    static let glow          = #colorLiteral(red: 0.9991423488, green: 0.9807055593, blue: 0.5882352941, alpha: 1)
    static let light         = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    static let lightDisabled = #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 0.15)
    static let lightFocused  = #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 0.75)
    static let text          = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let textDisabled  = #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 0.5)
    static let white         = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var asGhost: UIColor {
        return self.withAlphaComponent(0.28)
    }
}

extension UIFont {
    static let hud = UIFont(name: "Nasalization Free", size: 12)
    static let gameOverTitle = UIFont(name: "Nasalization Free", size: 30)
    static let gameOverButton = UIFont(name: "Nasalization Free", size: 20)
    static let level = UIFont(name: "Nasalization Free", size: 20)
    static let menuButton = UIFont(name: "Nasalization Free", size: 15)
    static let menuTitle = UIFont(name: "Nasalization Free", size: 20)
    static let modal = UIFont(name: "Nasalization Free", size: 14)
}

extension Int {
    func isOdd() -> Bool {
        return self % 2 != 0
    }
    
    func isEven() -> Bool {
        return self % 2 == 0 && self > 0
    }
}

extension UIView {
    func hide(with delay: Delay = 0.0, completion: ((Bool)->Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
            delay: delay,
            options: .curveLinear,
            animations: { [weak self] in
                self?.alpha = 0
            },
            completion: completion
        )
    }
    
    func show(with delay: Delay = 0.0, completion: ((Bool)->Void)? = nil) {
        if isHidden {
            alpha = 0
            isHidden = false
        }
        
        UIView.animate(withDuration: 0.5,
            delay: delay,
            options: .curveLinear,
            animations: { [weak self] in
                self?.alpha = 1
            },
            completion: completion
        )
    }
}

extension Array {
    func indexesOf<T : Equatable>(_ object: T) -> [Int] {
        var result: [Int] = []
        for (index, obj) in enumerated() {
            if obj as? T == object {
                result.append(index)
            }
        }
        return result
    }
}
