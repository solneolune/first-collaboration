//
//  SceneDelegate.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        let navigation = UINavigationController(rootViewController: TabBarController())
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        navigation.setNavigationBarHidden(true, animated: false)
    }
}
