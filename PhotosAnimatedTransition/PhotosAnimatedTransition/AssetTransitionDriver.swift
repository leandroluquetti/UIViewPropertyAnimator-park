//
//  AssetTransitionDriver.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 10/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//



import UIKit

class AssetTransitionDriver {
    
    private static let assetTransitionDuration = 2.0
    
    fileprivate weak var panGestureRecognizer: UIPanGestureRecognizer?
    fileprivate weak var imageAnimator: UIViewPropertyAnimator?
    
    fileprivate var operation: UINavigationControllerOperation?
    fileprivate var context: UIViewControllerContextTransitioning
    
    internal var transitionAnimator: UIViewPropertyAnimator?
    internal var avatar: AvatarImage?
    
    
    init(forOperation: UINavigationControllerOperation, inContext: UIViewControllerContextTransitioning , image : AvatarImage,gestureRecognizer:UIPanGestureRecognizer?) {
        
        operation = forOperation
        context = inContext
    
        let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to)
    
        panGestureRecognizer = gestureRecognizer
        panGestureRecognizer?.addTarget(self, action: #selector(AssetTransitionDriver.updateInteraction(_:)))
       
        avatar = image
        
        context.containerView.addSubview((toVC?.view)!)
        // this color will have the effect of dimming the collection view on/off during the transition
        context.containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
      
        toVC?.view.alpha = 0.0
        
        setupTransitionAnimator({
            
            fromVC?.view.alpha = 0.0
            toVC?.view.alpha = 1.0

            }, transitionCompletion: { position in
                if position == .end{
                    fromVC?.view.removeFromSuperview()
                    toVC?.view.alpha = 1.0
                }
        })
        
            context.containerView.addSubview( (avatar?.imageView)! )
            avatar?.imageView?.frame = (avatar?.beginFrame)!
        
        
        if !context.isInteractive{
            animate(.end)
            transitionAnimator?.startAnimation()
        }
    }
    
    
    
    
    
    class func animationDuration() -> TimeInterval {
        return AssetTransitionDriver.propertyAnimator().duration
    }
    
    
    
    
    class func propertyAnimator(_ initialVelocity: CGVector = .zero) -> UIViewPropertyAnimator{
        let timingParameters = UISpringTimingParameters(mass: 2.5, stiffness: 1000, damping: 65, initialVelocity: initialVelocity)
        return UIViewPropertyAnimator(duration: assetTransitionDuration , timingParameters: timingParameters)
    }
    
    
    
    
   private func curveVelocity() -> CGVector {
        guard let point = panGestureRecognizer?.velocity(in: context.containerView) else { return .zero }
            return CGVector(dx: point.x, dy: point.y)
    
    }
    
    
    
    func setupTransitionAnimator(_ transitionAnimations: @escaping ()->(), transitionCompletion: @escaping (UIViewAnimatingPosition)->()){
        // The duration of the images jump animation, if uninterrupted.
        let transitionDuration = AssetTransitionDriver.animationDuration() / 2
        
        transitionAnimator = UIViewPropertyAnimator(duration: transitionDuration, curve: .easeOut, animations: transitionAnimations)
        transitionAnimator?.addAnimations(transitionAnimations)
        transitionAnimator?.addCompletion{ [unowned self] (position) in
            transitionCompletion(position)
            self.context.completeTransition( position == .end )
        }
    }
    
    
    
    dynamic func updateInteraction(_ fromGesture:UIPanGestureRecognizer){
        switch fromGesture.state {
        case .began,.changed:
            let translation = fromGesture.translation(in: context.containerView)
        
            let percentComplete = ( transitionAnimator?.fractionComplete)! + progress
            
            transitionAnimator?.fractionComplete = percentComplete
            
            context.updateInteractiveTransition( percentComplete )
            
            updateItemsForInteractive(translation)
            
            fromGesture.setTranslation(CGPoint.zero, in: self.context.containerView)
            
        case .ended, .cancelled: endInteraction()
        default: break
        }
    }
    
    

    
 
    func endInteraction(){
        guard self.context.isInteractive else { return }
        
        let completionPosition = self.completionPosition
        if completionPosition == .end {
            context.finishInteractiveTransition()
        }else{
            context.cancelInteractiveTransition()
        }
        
        animate(completionPosition)
    }
    
    
    
    
    func animate(_ toPosition: UIViewAnimatingPosition){
        let imageFrameAnimator = AssetTransitionDriver.propertyAnimator( curveVelocity() )
        imageFrameAnimator.addAnimations{
          
                self.avatar!.imageView?.frame = (toPosition == .end ? self.avatar!.endFrame : self.avatar!.beginFrame)
            
        }
        
        imageFrameAnimator.addCompletion {[unowned self] postion in
            if toPosition == .end{
                    let (b,e) = ( (self.avatar?.beginFrame)! , (self.avatar?.endFrame)! )
                    self.avatar?.beginFrame = e
                    self.avatar?.endFrame = b
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
    
    
    
    
    //MARK:- Private Convenience
    
    private var  distance: CGFloat{
        let ycenter = (avatar?.imageView?.center.y)! - context.containerView.center.y
        let xcenter = (avatar?.imageView?.center.x)! - context.containerView.center.x
        
        return sqrt(xcenter * xcenter + ycenter * ycenter)
    }
    
    
    
    private  var completionPosition: UIViewAnimatingPosition{
        return self.distance < 60.0 ?  .start : .end
    }
    
    
    private var progress: CGFloat {
        let percent = distance / 1000.0
        return percent
        
    }
    
    
    private func updateItemsForInteractive(_ translation:CGPoint){
        let yprogrs  = ((avatar?.endFrame.height)! - (avatar?.beginFrame.height)!) * progress
        let xprogrs = ((avatar?.endFrame.width)! - (avatar?.beginFrame.width)!) * progress
        
        avatar?.imageView?.center = CGPoint(x: (avatar?.imageView?.center.x)!  + translation.x,y: (avatar?.imageView?.center.y)! + translation.y)
        avatar?.imageView?.bounds.size = CGSize(width: xprogrs + (avatar?.beginFrame.width)!, height: yprogrs + (avatar?.beginFrame.height)!)
    }
    
    
}// end




