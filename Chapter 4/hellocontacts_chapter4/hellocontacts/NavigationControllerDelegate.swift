//
//  NavigationControllerDelegate.swift
//  HelloContacts
//
//  Created by Donny Wals on 06-07-16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    let navigationController: UINavigationController
    var interactionController: UIPercentDrivenInteractiveTransition?

    init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        
        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                   action: #selector(self.pan(gestureRecognizer:)))
        navigationController.view.addGestureRecognizer(panRecognizer)
    }
    
    func pan(gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = self.navigationController.view
            else { return }
        
        switch gestureRecognizer.state {
        case .began:
            let location = gestureRecognizer.location(in: view)
            if location.x < view.bounds.midX &&
                navigationController.viewControllers.count > 1 {
                
                interactionController = UIPercentDrivenInteractiveTransition()
                navigationController.popViewController(animated: true)
            }
            break
        case .changed:
            let panTranslation = gestureRecognizer.translation(in: view)
            let animationProgress = fabs(panTranslation.x / view.bounds.width)
            interactionController?.update(animationProgress)
            break
        default:
            if gestureRecognizer.velocity(in: view).x > 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            
            interactionController = nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            return ContactsDetailHideAnimator()
        } else {
            return ContactDetailsShowAnimator()
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
