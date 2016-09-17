//
//  TransitionAnimator.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 10/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//


import UIKit

class AssetTransitionController: NSObject {
    
    private var finished = false
    
    fileprivate  var transitionDriver: AssetTransitionDriver?
    
    internal var avatarImage = AvatarImage()
    internal var startInteractive = false
    internal weak var panGestureRecognizer: UIPanGestureRecognizer?
    internal var operation: UINavigationControllerOperation?
    
}// end



// Become the navigation controller delegate

extension AssetTransitionController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation
       
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
}// endExtension





// adopt to UIViewControllerInteractiveTransitioning

extension AssetTransitionController: UIViewControllerInteractiveTransitioning{
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if let panGesture = panGestureRecognizer {
            transitionDriver = AssetTransitionDriver(forOperation:self.operation!, inContext:transitionContext,  image: avatarImage ,gestureRecognizer:panGesture)
        }
        else{
            transitionDriver = AssetTransitionDriver(forOperation: operation!, inContext: transitionContext, image: avatarImage ,gestureRecognizer: nil)
        }
        transitionDriver?.avatar = avatarImage
    }
    
    var wantsInteractiveStart: Bool{
        return startInteractive
    }
    
}// endExtension




// adopt the UIViewControllerAnimatedTransitioning

extension AssetTransitionController: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return AssetTransitionDriver.animationDuration()
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    
    func animationEnded(_ transitionCompleted: Bool) {
        if transitionCompleted {   /* animation ended here - nothing to do for now */     }
    }
    
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return (transitionDriver?.transitionAnimator)!
    }
    
}// endExtension

