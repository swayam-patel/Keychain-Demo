//
//  AppDelegate.swift
//  Keychain-Demo
//
//  Created by Swayam Patel on 23/01/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
                let navigationControl = UINavigationController(rootViewController: initialViewController)
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = navigationControl;
                self.window?.makeKeyAndVisible()

        return true
    }
    
    
}
