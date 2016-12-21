//
//  ContactDetailViewController.swift
//  HelloContacts
//
//  Created by Donny Wals on 28-06-16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet var contactImage: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var contactPhoneLabel: UILabel!
    @IBOutlet var contactEmailLabel: UILabel!
    @IBOutlet var contactAddressLabel: UILabel!
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var compactWidthConstraint: NSLayoutConstraint!
    var compactHeightConstraint: NSLayoutConstraint!
    
    var regularWidthConstraint: NSLayoutConstraint!
    var regularHeightConstraint: NSLayoutConstraint!
    
    var contact: HCContact?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let views = ["contactImage": contactImage,
                     "contactNameLabel": contactNameLabel]
        var allConstraints = [NSLayoutConstraint]()
        
        compactWidthConstraint = contactImage.widthAnchor.constraint(
            equalToConstant: 60)

        compactHeightConstraint = contactImage.heightAnchor.constraint(
            equalToConstant: 60)
        
        regularWidthConstraint = contactImage.widthAnchor.constraint(
            equalToConstant: 120)
        
        regularHeightConstraint = contactImage.heightAnchor.constraint(
            equalToConstant: 120)
        
        let verticalPositioningConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[contactImage]-[contactNameLabel]",
            options: [NSLayoutFormatOptions.alignAllCenterX],
            metrics: nil,
            views: views)
        
        allConstraints += verticalPositioningConstraints
        
        let centerXConstraint = contactImage.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor)
        
        allConstraints.append(centerXConstraint)
        
        if traitCollection.horizontalSizeClass == .regular &&
            traitCollection.verticalSizeClass == .regular {
            
            allConstraints.append(regularWidthConstraint)
            allConstraints.append(regularHeightConstraint)
        } else {
            allConstraints.append(compactWidthConstraint)
            allConstraints.append(compactHeightConstraint)
        }
        
        NSLayoutConstraint.activate(allConstraints)
        
        if var contact = self.contact {
            contact.prefetchImageIfNeeded()
            contactImage.image = contact.contactImage
            contactNameLabel.text = "\(contact.givenName) \(contact.familyName)"
            contactPhoneLabel.text = contact.phoneNumber
            contactEmailLabel.text = contact.emailAddress
            contactAddressLabel.text = contact.address
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(self.onKeyboardAppear(notification:)),
                                                 name: .UIKeyboardWillShow,
                                                 object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(self.onKeyboardHide(notification:)),
                                                 name: .UIKeyboardWillHide,
                                                 object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func onKeyboardAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }
        
        scrollViewBottomConstraint.constant = keyboardFrameValue.cgRectValue().size.height
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }

    func onKeyboardHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }
        
        scrollViewBottomConstraint.constant = 0
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard let previousTraits = previousTraitCollection where
                previousTraits.horizontalSizeClass != traitCollection.horizontalSizeClass ||
                previousTraits.verticalSizeClass != traitCollection.verticalSizeClass else {
                    
                    return
        }
        
        if traitCollection.horizontalSizeClass == .regular &&
            traitCollection.verticalSizeClass == .regular {
            
            NSLayoutConstraint.deactivate([compactHeightConstraint, compactWidthConstraint])
            NSLayoutConstraint.activate([regularHeightConstraint, regularWidthConstraint])
        } else {
            NSLayoutConstraint.deactivate([regularHeightConstraint, regularWidthConstraint])
            NSLayoutConstraint.activate([compactHeightConstraint, compactWidthConstraint])
        }
    }
}


