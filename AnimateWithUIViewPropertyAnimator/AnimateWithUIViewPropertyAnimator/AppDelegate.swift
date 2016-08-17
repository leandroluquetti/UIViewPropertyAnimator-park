//
//  AppDelegate.swift
//  IOSBasics
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
        
        let appBounds = UIScreen.main.bounds
        
        window = UIWindow(frame: appBounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }

}

