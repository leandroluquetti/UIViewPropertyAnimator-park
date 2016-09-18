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
        avatar.imageView?.frame = avatar.beginFrame
        
        let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to)
    
        panGestureRecognizer = gestureRecognizer
        panGestureRecognizer?.addTarget( self, action: #selector(AssetTransitionDriver.updateInteraction(_:))  )
       
        context.containerView.addSubview((toVC?.view)!)
        // this backgroundColor will have the effect of dimming the collection view on/off during the transition
        context.containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
        let imageFrameAnimator = AssetTransitionDriver.propertyAnimator( curveVelocity )
        imageFrameAnimator.addAnimations{
                self.avatar.imageView?.frame = (toPosition == .end ? self.avatar.endFrame : self.avatar.beginFrame)
        }
        imageFrameAnimator.addCompletion {[unowned self] postion in
            if toPosition == .end{
                    let (b,e) = ( (self.avatar.beginFrame) , (self.avatar.endFrame) )
                    self.avatar.beginFrame = e
                    self.avatar.endFrame = b
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
        let yprogrs = awayFromCenterPercent * ( avatar.endFrame.height - avatar.beginFrame.height )
        let xprogrs = awayFromCenterPercent * ( avatar.endFrame.width - avatar.beginFrame.width)
        
        avatar.imageView?.center = CGPoint(x: (avatar.imageView?.center.x)!  + translation.x,y: (avatar.imageView?.center.y)! + translation.y)
        print(avatar.imageView?.center)
        avatar.imageView?.bounds.size = CGSize(width: xprogrs + avatar.beginFrame.width, height: yprogrs + avatar.beginFrame.height )
    }
    
    
    // Determines the speed/ duration of the images fall back animation, measured in meters per second,
    // based on the distant of the image from the center when released from the pan gesture.
    // The further away from the center of the screen, the faster the image returns into place.
    private var curveVelocity: CGVector {
        guard let point = panGestureRecognizer?.velocity(in: context.containerView) else { return .zero }

        return CGVector(dx: point.x / 15, dy: point.y / 15)
    }
    
}// end




