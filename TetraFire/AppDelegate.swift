//
//  AppDelegate.swift
//  TetraFire
//
//  Created by Jordan Doczy on 9/5/17.
//  Copyright © 2017 Jordan Doczy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var particleScene: ParticleScene?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let window = window {
            particleScene = ParticleScene(size: window.frame.size)
            particleScene?.scaleMode = .aspectFill
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        particleScene?.removeAllChildren()

        if let gameViewController = window?.rootViewController as? GameViewController {
            gameViewController.saveState()
        }
    
    }
    
}
