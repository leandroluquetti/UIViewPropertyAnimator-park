//
//  NavigationDelegate.swift
//  CustomNavigationAnimation
//
//  Created by Manuel Lopes on 28/04/16.
//  Copyright © 2016 Blessing.co. All rights reserved.
//

import UIKit



// Custom UINavigationController Delegate

class NavigationDelegate: NSObject, UINavigationControllerDelegate{
    

    private let pushAnimator = Animator()
    private let popAnimator = DismissAnimator()
    let interactionController = InteractionTransitionController()
    
    
func navigationController(_ navigationController: UINavigationController,
                          animationControllerFor operation: UINavigationControllerOperation,
                          from fromVC: UIViewController,
                          to toVC: UIViewController)
     -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            interactionController.attachToViewController(toVC)
        }

        
        return operation == .push ?   pushAnimator : popAnimator
}

    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionController.transitionInProgress ? interactionController : nil
    }


    
    
}// End

