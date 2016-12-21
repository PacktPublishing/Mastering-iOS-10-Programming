//
//  ViewEffectAnimatorType.swift
//  HelloContacts
//
//  Created by Donny Wals on 27/07/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

typealias ViewEffectAnimatorComplete = (UIViewAnimatingPosition) -> Void

protocol ViewEffectAnimatorType {
    
    var animator: UIViewPropertyAnimator { get }
    
    init(targetView: UIView, onComplete: ViewEffectAnimatorComplete)
    init(targetView: UIView, onComplete: ViewEffectAnimatorComplete, duration: TimeInterval)
    
    func startAnimation()
}

extension ViewEffectAnimatorType {
    func startAnimation() {
        animator.startAnimation()
    }
}
