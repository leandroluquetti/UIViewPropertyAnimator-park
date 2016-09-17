//
//  AppDelegate.swift
//  CustomNavigationAnimation
//
//  Created by manuel on 03/10/15.
//  Copyright © 2015 Blessing.co. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
   

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
        
        
     
        let initial = SpaceManViewController()
        
        let navigator = UINavigationController(rootViewController: initial )
        navigator.navigationBar.barStyle = .black
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigator
		window?.makeKeyAndVisible()
		
		
		return true
	}

	
}

