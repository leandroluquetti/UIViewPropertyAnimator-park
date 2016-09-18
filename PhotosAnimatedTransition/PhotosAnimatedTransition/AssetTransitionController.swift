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
    func navigationController( _ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // save the direction of the transition (.push or .pop)
        self.operation = operation
        
       // return ourselves as the animation controller for the transition
        return self
    }
    
    
    func navigationController( _ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // return ourselves as the animation controller for the transition
        return self
    }
    
    
    
    func navigationController( _ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // The cell that launchs the transition is hidden when is tapped.
        // Here we make it visible again, because the collection view is about to be shown again.
        if let collectionVC = viewController as? CollectionViewController{
            collectionVC.selecteCell?.isHidden = false
        }
    }
    

    
}// endExt





// adopt  UIViewControllerInteractiveTransitioning

extension AssetTransitionController: UIViewControllerInteractiveTransitioning{
    
    /** Determines whether the transition is interactive or not.
    - Return: true if the transition is interactive, false otherwise
    */
    var wantsInteractiveStart: Bool{
        return startInteractive
    }
    
    
    func startInteractiveTransition( _ transitionContext: UIViewControllerContextTransitioning) {
        
       // if we have a pan gesture then the transition is interactive
        if let panGesture = panGestureRecognizer {
            
            // create a helper object that will manage the transition in a given transitionContext
            transitionDriver = AssetTransitionDriver(for: operation!, in: transitionContext,  with: avatarImage, gesture: panGesture)
        }
        else{
            transitionDriver = AssetTransitionDriver(for: operation!, in: transitionContext, with: avatarImage , gesture: nil)
        }
    }
    
 
    
}// endExt




// adopt  UIViewControllerAnimatedTransitioning

extension AssetTransitionController: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // The method needs to be implemented because it's required by the protocol, but
        // this return value does NOT influence the duration of the animation in the
        // particular case of this sample's setup.
        return AssetTransitionDriver.animationDuration()
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // The method needs to be implemented because it's required by the protocol, but
        // the animation heavy lifting is done by the transitionDriver object in func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning)
        //        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    
    func animationEnded( _ transitionCompleted: Bool) {
        if transitionCompleted {   /* animation ended here - nothing to do for now */     }
    }
    
    
    func interruptibleAnimator( using transitionContext: UIViewControllerContextTransitioning ) -> UIViewImplicitlyAnimating {
        // The transitionDriver creates the UIViewPropertyAnimator (transitionAnimator) that drives the animations of the
        // navigation controller transitions.
        return (transitionDriver?.transitionAnimator)!
    }
    
}// endExt

