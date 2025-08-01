//
//  SceneDelegate.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 23/01/25.
//

import nexus_sdk_iOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        NexusSDK.shared.initialise(with: "abcd", screenProvider: MyScreenProvider())
        window?.rootViewController = NexusSDK.shared.rootViewController()
        window?.makeKeyAndVisible()
    }

}

final class MyScreenProvider: ScreenProviding {
    func viewController(for screen: nexus_sdk_iOS.Screen) -> UIViewController? {
        ViewController()
    }
    
    
}

