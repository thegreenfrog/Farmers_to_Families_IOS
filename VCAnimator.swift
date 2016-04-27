//
//  VCAnimator.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/19/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class VCAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        let bounds = UIScreen.mainScreen().bounds
        toViewController.view.frame = CGRectOffset(finalFrameForVC, bounds.size.height, 0)
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .CurveLinear, animations: {
            fromViewController.view.alpha = 0.4
            toViewController.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
    }
}
