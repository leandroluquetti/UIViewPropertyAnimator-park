//
//  OtherViewController.swift
//  CustomViewControllerTransition
//
//  Created by manuel on 02/10/15.
//  Copyright © 2015 Blessing.co. All rights reserved.
//

import UIKit


class RocketViewController: UIViewController {
    

	var imageView : UIImageView?
    
    
    //MARK:- View life Cycle

	override func viewDidLoad(){
		super.viewDidLoad()
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        
		imageView = UIImageView(image: UIImage(named: "rocket.png"))

		imageView?.contentMode = .scaleAspectFill
		imageView?.clipsToBounds = true
		imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        
		view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
	
		view.addSubview(imageView!)
		view.addGestureRecognizer(tap)
        
        
        // Center title horizontally
        imageView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

	}


    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setToolbarHidden(true, animated: true)
        
    }
    
	// MARK:- Gesture handlers
	func dismissAction(){
       let _ =	navigationController?.popToRootViewController(animated: true)
	
	}
	
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        
    }
    
    
    
	//MARK:- de-init
	deinit {
		print("Deallocating instance",	self)
	}
	
    
    

	
}// END
