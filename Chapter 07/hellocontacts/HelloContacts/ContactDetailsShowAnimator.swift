//
//  ContactDetailsShowAnimator.swift
//  HelloContacts
//
//  Created by Donny Wals on 12-07-16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class ContactDetailsShowAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(
                    forKey: UITransitionContextToViewControllerKey),
            let fromViewController = transitionContext.viewController(
                    forKey: UITransitionContextFromViewControllerKey),
            let overviewViewController = fromViewController as? ViewController,
            let selectedCell = overviewViewController.collectionView
                    .indexPathsForSelectedItems()?.first,
            let sourceCell = overviewViewController.collectionView
                    .cellForItem(at: selectedCell) as? ContactCollectionViewCell
        else {
            return
        }
        
        let transitionContainer = transitionContext.containerView()
        let toEndFrame = transitionContext.finalFrame(for: toViewController)
        
        let imageFrame = sourceCell.contactImage.frame
        
        let targetFrame = overviewViewController.view.convert(imageFrame,
                                                              from: sourceCell)
        
        toViewController.view.frame = targetFrame
        toViewController.view.layer.cornerRadius = sourceCell.frame.height / 2
        
        transitionContainer.addSubview(toViewController.view)
        
        let animationTiming = UICubicTimingParameters(
                                animationCurve: .easeInOut)
        
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            timingParameters: animationTiming)
        
        animator.addAnimations {
            toViewController.view.frame = toEndFrame
            toViewController.view.layer.cornerRadius = 0
        }
        
        animator.addCompletion { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        animator.startAnimation()
    }
}
