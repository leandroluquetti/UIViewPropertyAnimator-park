//
//  ImageViewController.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 10/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//
import UIKit

class PictureViewController: UIViewController {
    
    weak var image: UIImage?
    
    private var imageView: UIImageView?
    private var panGesture: UIPanGestureRecognizer?
    private var transitionBegan = false
    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "profile"
        imageView = UIImageView(image: image)
        
        // I will not ever forget to turn translatesAutoresizingMaskIntoConstraints to false!
        // I will not ever forget to turn translatesAutoresizingMaskIntoConstraints to false!
        //                        ...
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.alpha = 0
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(imageView!)
        
        imageView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        panGesture = UIPanGestureRecognizer()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let assetTransitionController = navigationController?.delegate as? AssetTransitionController{

            panGesture?.addTarget(self, action: #selector(PictureViewController.panGesture(_:)))
            panGesture?.minimumNumberOfTouches = 1
            
            imageView?.addGestureRecognizer(panGesture!)
            imageView?.isUserInteractionEnabled = true
            imageView?.alpha = 1
            
            assetTransitionController.startInteractive = false
            assetTransitionController.panGestureRecognizer = nil
        }
        
        transitionBegan = false
    }
    

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView?.alpha = 0
    }
    
    
    func panGesture(_ sender: UIPanGestureRecognizer) {

        if !transitionBegan && sender.state == .changed  {

            if let transitionController = navigationController?.delegate as? AssetTransitionController{
                transitionController.startInteractive = true
                transitionController.panGestureRecognizer = sender
                _ = navigationController?.popViewController(animated: true)
            }
            transitionBegan = true
        }
    }
    
    
    
}// end




