//
//  CustomPresentedViewController.swift
//  HelloContacts
//
//  Created by Donny Wals on 09-07-16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class CustomPresentedViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var hideAnimator: CustomModalHideAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        hideAnimator = CustomModalHideAnimator(withViewController: self)
    }
    
    func interactionController(forDismissal animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return hideAnimator
    }
    
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomModalShowAnimator()
    }
    
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return hideAnimator
    }
    
    func onTap() {
        dismiss(animated: true, completion: nil)
    }

}
