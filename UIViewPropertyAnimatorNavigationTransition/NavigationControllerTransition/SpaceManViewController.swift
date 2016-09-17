//
//  ViewController.swift
//  CustomViewControllerTransition
//
//  Created by manuel on 02/10/15.
//  Copyright © 2015 Blessing.co. All rights reserved.
//

import UIKit

class SpaceManViewController: UIViewController {

    //MARK:- Properties
	var imageView : UIImageView?
	 private let navDelegate = NavigationDelegate()
  
    
    
	
    //MARK:- View life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
        
        navigationController?.delegate = navDelegate
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SpaceManViewController.action(_:) ))
	
		imageView = UIImageView(image: UIImage(named: "me.jpg"))
		
		imageView?.contentMode = .scaleAspectFit
		imageView?.clipsToBounds = true
        imageView?.translatesAutoresizingMaskIntoConstraints = false
		
		
		
		view.addSubview(imageView!)
		view.addGestureRecognizer(tap)
	
        imageView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
	
    }
    
    
    
    

    // MARK:- Gesture handlers
    func action(_ gesture: UIGestureRecognizer){
		let other = RocketViewController()
		navigationController?.pushViewController(other, animated: true)
        print("gesture")
	}

    
    
	//MARK:- De-init
	deinit {
		print("Deallocating instance",	self)
	}
	

}// END

