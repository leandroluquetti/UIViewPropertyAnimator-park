//
//  AssetTransitionDriver.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 10/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//



import UIKit

class AssetTransitionDriver {
    
    fileprivate weak var panGestureRecognizer: UIPanGestureRecognizer?
    fileprivate weak var imageAnimator: UIViewPropertyAnimator?
    
    fileprivate let operation: UINavigationControllerOperation
    fileprivate let context: UIViewControllerContextTransitioning
    
    internal let avatar: AvatarImage
    internal var transitionAnimator: UIViewPropertyAnimator?
    
    
    
    init(for operation: UINavigationControllerOperation, in context: UIViewControllerContextTransitioning , with image : AvatarImage,gesture gestureRecognizer: UIPanGestureRecognizer?) {
        self.operation = operation
        self.context = context
        
        avatar = image
        avatar.imageView?.frame = avatar.frameAt.start
        
        let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to)
    
        panGestureRecognizer = gestureRecognizer
        panGestureRecognizer?.addTarget( self, action: #selector(AssetTransitionDriver.updateInteraction(_:))  )
       
        context.containerView.addSubview((toVC?.view)!)
        // this backgroundColor will have the effect of dimming the collection view on/off during the transition
        context.containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        context.containerView.addSubview( (avatar.imageView)! )
      
        toVC?.view.alpha = 0.0
        
        setupTransitionAnimator({
            fromVC?.view.alpha = 0.0
            toVC?.view.alpha = 1.0

            }, transitionCompletion: { [unowned self] position in
                if position == .end{
                    fromVC?.view.removeFromSuperview()
                    self.avatar.imageView?.removeFromSuperview()
                    toVC?.view.alpha = 1.0
                }
        })

        if !context.isInteractive{
            animate(.end)
        }
    }
    
    
    
    
    // The duration of the animation based on the timing parameters of the UIViewPropertyAnimator object
    class func animationDuration() -> TimeInterval {
        return AssetTransitionDriver.propertyAnimator().duration
    }
    
    
    
    
    class func propertyAnimator( _ initialVelocity: CGVector = .zero) -> UIViewPropertyAnimator{
        let timingParameters = UISpringTimingParameters(mass: 2.5, stiffness: 1000, damping: 65, initialVelocity: initialVelocity)
        // The duration is irrelevante since it's determined by the timingParameters.
        return UIViewPropertyAnimator(duration: 0 , timingParameters: timingParameters)
    }
    
    
    
    func setupTransitionAnimator( _ transitionAnimations: @escaping ()->(), transitionCompletion: @escaping (UIViewAnimatingPosition)->()){
        
        /** This is the duration of the navigation controller transition animation.
         This value should be the same as the the duration of the image jump animation,
         so both animation finish in sync.
        */
        let transitionDuration = AssetTransitionDriver.animationDuration()
        
        transitionAnimator = UIViewPropertyAnimator(duration: transitionDuration, curve: .easeOut, animations: transitionAnimations)
        transitionAnimator?.addAnimations(transitionAnimations)
        transitionAnimator?.addCompletion{ [unowned self] (position) in
            transitionCompletion(position)
            self.context.completeTransition( position == .end )
        }
    }
    
    
    
    dynamic func updateInteraction( _ fromGesture: UIPanGestureRecognizer){
        switch fromGesture.state {
        case .began,.changed:
            let translation = fromGesture.translation(in: context.containerView)
            transitionAnimator?.fractionComplete = awayFromCenterPercent
            context.updateInteractiveTransition( awayFromCenterPercent )
            updateImageForInteractive(translation)
            fromGesture.setTranslation(CGPoint.zero, in: context.containerView)
            
        case .ended, .cancelled: endInteraction()
        default: break
        }
    }
    
    
 
    func endInteraction(){
        guard self.context.isInteractive else { return }
        
        if completionPosition == .end {
            context.finishInteractiveTransition()
        }else{
            context.cancelInteractiveTransition()
        }
        
        animate(completionPosition)
    }
    
    
    
    
    func animate( _ toPosition: UIViewAnimatingPosition){
        // A new timming parameter could be passed to this animator, for example a velocity CGVector,
        // which would give the image jump animation a different feel.
        let imageFrameAnimator = AssetTransitionDriver.propertyAnimator()
        imageFrameAnimator.addAnimations{
                self.avatar.imageView?.frame = (toPosition == .end ? self.avatar.frameAt.end : self.avatar.frameAt.start)
        }
        imageFrameAnimator.addCompletion {[unowned self] postion in
            if toPosition == .end{
                self.avatar.frameAt = (self.avatar.frameAt.end, self.avatar.frameAt.start)
            }
        }
        imageFrameAnimator.startAnimation()
        
        imageAnimator = imageFrameAnimator
        
        transitionAnimator?.isReversed = (toPosition == .start)
        
        if transitionAnimator?.state == .active{
            let timeSpan = CGFloat(imageFrameAnimator.duration / (transitionAnimator?.duration)!)
            transitionAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: timeSpan)
        }else{
           transitionAnimator?.startAnimation()
        }
    }
    
    
    
    func pauseAnimation(){
        imageAnimator?.stopAnimation(true)
        transitionAnimator?.pauseAnimation()
        context.pauseInteractiveTransition()
    }
    
    
    
    
    //MARK:- Private Convenience Methods and computed properties
    
    private var distance: CGFloat{
        let ycenter = (avatar.imageView?.center.y)! - context.containerView.center.y
        let xcenter = (avatar.imageView?.center.x)! - context.containerView.center.x

        return sqrt(xcenter * xcenter + ycenter * ycenter)
    }
    
    
    
    private  var completionPosition: UIViewAnimatingPosition{
        return distance < 60.0 ?  .start : .end
    }
    

    
    private var awayFromCenterPercent: CGFloat {
        return distance / 400.0
    }
    
    
    
    private func updateImageForInteractive( _ translation: CGPoint){
        let yprogrs = awayFromCenterPercent * ( avatar.frameAt.end.height - avatar.frameAt.start.height )
        let xprogrs = awayFromCenterPercent * ( avatar.frameAt.end.width - avatar.frameAt.start.width)
        
        avatar.position = CGPoint(x: (avatar.imageView?.center.x)!  + translation.x,y: (avatar.imageView?.center.y)! + translation.y)
        avatar.size = CGSize(width: xprogrs + avatar.frameAt.start.width, height: yprogrs + avatar.frameAt.start.height )
    }
    
    
    
}// end




