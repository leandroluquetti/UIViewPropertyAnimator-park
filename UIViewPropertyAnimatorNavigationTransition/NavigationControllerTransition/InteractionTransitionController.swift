//
//  InteractionTransitionController.swift
//  NavigationControllerTransition
//
//  Created by Manuel Lopes on 17/09/2016.
//  Copyright © 2016 Manuel Lopes. All rights reserved.
//


import UIKit

class InteractionTransitionController: UIPercentDrivenInteractiveTransition {
    
    
    
    var navigationController: UINavigationController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    var completionSeed: CGFloat {
        return 1 - percentComplete
    }
    private weak var poppedVC: UIViewController?
    
    func attachToViewController(_ viewController: UIViewController) {
        navigationController = viewController.navigationController
        setupGestureRecognizer(viewController.view)
    }
    
    fileprivate func setupGestureRecognizer(_ view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(InteractionTransitionController.handlePanGesture(_:))))
    }
    
    func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let viewTranslation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        switch gestureRecognizer.state {
        case .began:
            transitionInProgress = true
            poppedVC  =  navigationController.popViewController(animated: true)
            
        case .changed:
            let const = CGFloat(fminf(fmaxf(Float(viewTranslation.x / 200.0), 0.0), 1.0))
            shouldCompleteTransition = const > 0.5
            update(const)
        case .cancelled, .ended:
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                
                navigationController?.viewControllers.append(poppedVC!)
                update(0.0)
                cancel()
            } else {
                finish()
            }
        default:
            print("Swift switch must be exhaustive, thus the default")
        }
    }
}

