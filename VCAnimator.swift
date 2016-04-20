//
//  VCAnimator.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/19/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class VCAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        
        let appView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let registerView = presenting ? appView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        let initialFrame = presenting ? originFrame : registerView.frame
        let finalFrame = presenting ? registerView.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if presenting {
            registerView.transform = scaleTransform
            registerView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            registerView.clipsToBounds = true
        }
        
        containerView.addSubview(appView)
        containerView.bringSubviewToFront(registerView)
        
        UIView.animateWithDuration(duration, delay:0.0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                registerView.transform = self.presenting ?
                    CGAffineTransformIdentity : scaleTransform
                
                registerView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                    y: CGRectGetMidY(finalFrame))
                
            }, completion:{_ in
                transitionContext.completeTransition(true)
        })
    }
}
