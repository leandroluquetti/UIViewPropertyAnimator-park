//
//  Animator.swift
//  CustomViewControllerTransition
//
//  Created by manuel on 02/10/15.
//  Copyright © 2015 Blessing.co. All rights reserved.
//

import UIKit


class Animator: NSObject, UIViewControllerAnimatedTransitioning {
	
  
    let animator = UIViewPropertyAnimator(duration: 0.5 , timingParameters: UICubicTimingParameters(animationCurve: .easeOut))
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    

    
    // This is an optional method of UIViewControllerAnimatedTransitioning
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating{
       
        if   let  toVC   = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.to ) as? RocketViewController,
             let fromVC  = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.from ) as? SpaceManViewController{
            
            let container = transitionContext.containerView
            
            let offScreen = CGPoint(x: (toVC.imageView?.center.x)!, y: 800)
            
            container.addSubview(toVC.view)
            container.addSubview(fromVC.view)
            
            toVC.view.frame = (container.bounds)
            toVC.imageView?.center =  offScreen
            
            fromVC.view.alpha = 1
                
            animator.addAnimations {
                toVC.imageView!.center = toVC.view.center
                toVC.view.alpha = 1.0
                fromVC.view.alpha = 0
            }
        
            animator.addCompletion({   completion in
                let complete = completion == .end
                transitionContext.completeTransition(complete)
            })
        }
        return animator
        
    }

	
	
	
}// END
