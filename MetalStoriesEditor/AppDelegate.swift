//
//  AppDelegate.swift
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 29.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let vc = CompositionViewController()
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

