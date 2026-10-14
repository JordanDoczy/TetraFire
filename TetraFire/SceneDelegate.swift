//
//  SceneDelegate.swift
//  TetraFire
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // The window and root view controller come from the Main storyboard (UISceneStoryboardFile).
    // The particle scene must exist before the game view controller loads its view.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let particleScene = ParticleScene(size: windowScene.screen.bounds.size)
        particleScene.scaleMode = .aspectFill
        appDelegate.particleScene = particleScene
    }

    // Under the scene lifecycle, applicationWillResignActive is no longer called.
    func sceneWillResignActive(_ scene: UIScene) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.particleScene?.removeAllChildren()

        if let gameViewController = window?.rootViewController as? GameViewController {
            gameViewController.saveState()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        AudioManager.shared.pause()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        AudioManager.shared.resume()
    }

}
