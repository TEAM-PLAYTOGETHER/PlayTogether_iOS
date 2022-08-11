//
//  SceneDelegate.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
//        window?.rootViewController = TabBarController()
//        window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        window?.rootViewController = UINavigationController(rootViewController: SelfIntroduceViewController())
    }
}

