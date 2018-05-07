//
//  AppDelegate.swift
//  TapTapGo
//
//  Created by Marcelo Gobetti on 5/6/18.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if NSClassFromString("XCTest") != nil {
            // Running tests, prevent UI from loading and concurring
            window?.rootViewController = UIViewController()
        } else {
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        window?.makeKeyAndVisible()
        
        return true
    }
}

