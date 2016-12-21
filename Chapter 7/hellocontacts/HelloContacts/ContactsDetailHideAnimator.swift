//
//  ContactsDetailHideAnimator.swift
//  HelloContacts
//
//  Created by Donny Wals on 12-07-16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class ContactsDetailHideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(
                    forKey: UITransitionContextToViewControllerKey),
            let fromViewController = transitionContext.viewController(
                    forKey: UITransitionContextFromViewControllerKey),
            let overviewViewController = toViewController as? ViewController,
            let selectedCell = overviewViewController.collectionView
                    .indexPathsForSelectedItems()?.first,
            let sourceCell = overviewViewController.collectionView
                    .cellForItem(at: selectedCell) as? ContactCollectionViewCell
            else {
                return
        }
        
        let transitionContainer = transitionContext.containerView()
        
        transitionContainer.addSubview(toViewController.view)
        transitionContainer.addSubview(fromViewController.view)
        
        let animationTiming = UICubicTimingParameters(
            animationCurve: .easeInOut)
        
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            timingParameters: animationTiming)
        
        animator.addAnimations {
            let imageFrame = sourceCell.contactImage.frame
            
            let targetFrame = overviewViewController.view.convert(imageFrame,
                                                                  from: sourceCell)

            fromViewController.view.frame = targetFrame
            fromViewController.view.layer.cornerRadius = sourceCell.contactImage.frame.height / 2
        }
        
        animator.addCompletion { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        animator.startAnimation()
    }
}
