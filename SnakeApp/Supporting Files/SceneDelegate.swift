//
//  SceneDelegate.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 25.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createInitialVC()
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Define the InitialVC
    
    private func createInitialVC() -> UINavigationController {
        let initialVC = MainViewController()
        return UINavigationController(rootViewController: initialVC)
    }
    
}
