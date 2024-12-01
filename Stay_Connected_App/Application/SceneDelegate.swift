//
//  SceneDelegate.swift
//  Stay_Connected_App
//
//  Created by iliko on 12/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let isLoggedIn = true
        
        if isLoggedIn {
            window.rootViewController = UINavigationController(rootViewController: TabBarController())
        } else {
            window.rootViewController = UINavigationController(rootViewController: LoginVC())
        }

        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

