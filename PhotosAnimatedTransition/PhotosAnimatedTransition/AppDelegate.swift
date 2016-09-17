//
//  AppDelegate.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 09/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let smallLayout = UICollectionViewFlowLayout()
        smallLayout.itemSize = CGSize(width: 50, height: 50)
        
        let navigator = UINavigationController(rootViewController: CollectionViewController(collectionViewLayout: smallLayout))
        window?.rootViewController = navigator
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
}// end

