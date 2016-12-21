//
//  BounceAnimationHelper.swift
//  HelloContacts
//
//  Created by Donny Wals on 27/07/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

struct BounceAnimationHelper: ViewEffectAnimatorType {
    
    let animator: UIViewPropertyAnimator
    
    init(targetView: UIView, onComplete: ViewEffectAnimatorComplete) {
        self.init(targetView: targetView, onComplete: onComplete, duration: 0.4)
    }

    init(targetView: UIView, onComplete: ViewEffectAnimatorComplete, duration: TimeInterval) {
        let downAnimationTiming = UISpringTimingParameters(
            dampingRatio: 0.9,
            initialVelocity: CGVector(dx: 20, dy: 0))
        
        self.animator = UIViewPropertyAnimator(
            duration: duration/2,
            timingParameters: downAnimationTiming)
        
        self.animator.addAnimations {
            targetView.transform =
                CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        self.animator.addCompletion { position in
            let upAnimationTiming = UISpringTimingParameters(
                dampingRatio: 0.3,
                initialVelocity: CGVector(dx: 20, dy: 0))
            
            let upAnimator = UIViewPropertyAnimator(
                duration: duration/2,
                timingParameters: upAnimationTiming)
            
            upAnimator.addAnimations {
                targetView.transform =
                    CGAffineTransform.identity
            }
            
            upAnimator.addCompletion(onComplete)
            
            upAnimator.startAnimation()
        }
    }
}
