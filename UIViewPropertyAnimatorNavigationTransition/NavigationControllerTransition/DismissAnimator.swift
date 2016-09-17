//
//  DismissAnimator.swift
//  CustomViewControllerTransition
//
//  Created by manuel on 02/10/15.
//  Copyright © 2015 Blessing.co. All rights reserved.
//

import UIKit


class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
    let animator = UIViewPropertyAnimator(duration: 0.5 , timingParameters: UICubicTimingParameters(animationCurve: .easeOut))

	// set the transition duration
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
		return 1.5
	}
	
	
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        interruptibleAnimator(using: transitionContext).startAnimation()
        
    }
    
    
    
    // This is an optional method of UIViewControllerAnimatedTransitioning
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating{
        
        if  let  toVC   = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.to ) as? SpaceManViewController,
            let fromVC  = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.from ) as? RocketViewController{
            
            let offScreen = CGPoint(x: (toVC.imageView?.center.x)!, y: 800)
            
            // add the views to the container view
            let container = transitionContext.containerView
            container.addSubview(toVC.view)
            container.addSubview(fromVC.view)

            toVC.view.frame = (container.bounds)
            toVC.view.alpha = 1
            
            // add the animation
            animator.addAnimations {
                fromVC.imageView!.center = offScreen
                fromVC.view.alpha = 0
            }
            
            // add a complection block to the animator
            animator.addCompletion({   completion in
                
                transitionContext.completeTransition(true)
               
            })
        }
        
        return animator
        
    }
    

	
	
}// end
