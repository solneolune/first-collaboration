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
        
        let AirQualityVM = AirQualityViewModel()
        let AirQualityVC = AirQualityViewController(viewModel: AirQualityVM)
        let nav = UINavigationController(rootViewController: AirQualityVC)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
