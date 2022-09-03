//
//  SceneDelegate.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let mainViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        setNavController(controller: navigationController)
        
        let tabbar = CustomBar()
        
        let cartVC = CartViewController()
        
        tabbar.addChild(navigationController)
        tabbar.addChild(cartVC)
        
        tabbar.selectedViewController = cartVC
        
        window.rootViewController = tabbar
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    deinit {
        UserDefaultsManager.shared?.saveSelf()
    }
    
    private func setNavController(controller: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        
        controller.navigationBar.prefersLargeTitles = false
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Fam: \(family) Font names = \(names)")
        }
        
        appearance.backgroundColor = Colors.shared.backgroundColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.shared.darkPirple, NSAttributedString.Key.font: UIFont(name: "Mark-Regular", size: 19)!]
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        controller.navigationBar.standardAppearance = appearance
        controller.navigationBar.scrollEdgeAppearance = appearance
        controller.navigationBar.standardAppearance.backgroundColor = Colors.shared.backgroundColor
        controller.navigationBar.scrollEdgeAppearance?.backgroundColor = Colors.shared.backgroundColor
        controller.navigationBar.barTintColor = Colors.shared.backgroundColor
    }

}

