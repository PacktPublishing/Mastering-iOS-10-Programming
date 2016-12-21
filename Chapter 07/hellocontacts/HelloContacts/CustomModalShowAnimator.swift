//
//  CustomModalShowAnimator.swift
//  HelloContacts
//
//  Created by Donny Wals on 09-07-16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class CustomModalShowAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) else {
                return
        }
        
        let transitionContainer = transitionContext.containerView()
        
        var transform = CGAffineTransform.identity
        transform = transform.concat(CGAffineTransform(scaleX: 0.6, y: 0.6))
        transform = transform.concat(CGAffineTransform(translationX: 0, y: -200))
        
        toViewController.view.transform = transform
        toViewController.view.alpha = 0
        
        transitionContainer.addSubview(toViewController.view)
        
        let animationTiming = UISpringTimingParameters(
                dampingRatio: 0.8,
                initialVelocity: CGVector(dx: 1, dy: 0))

        let animator = UIViewPropertyAnimator(
                duration: transitionDuration(using: transitionContext),
                timingParameters: animationTiming)

        animator.addAnimations {
            toViewController.view.transform = CGAffineTransform.identity
            toViewController.view.alpha = 1
        }

        animator.addCompletion { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        animator.startAnimation()
    }
}
