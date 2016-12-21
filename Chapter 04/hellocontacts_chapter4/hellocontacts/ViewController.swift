//
//  ViewController.swift
//  HelloContacts
//
//  Created by Donny Wals on 15/06/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var contacts = [HCContact]()
    @IBOutlet var collectionView: UICollectionView!
    var navigationDelegate: NavigationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController {
            navigationDelegate = NavigationControllerDelegate(withNavigationController: navigationController)
            navigationController.delegate = navigationDelegate
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = ContactsCollectionViewLayout()
        
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: {[weak self] authorized, error in
                if authorized {
                    self?.retrieveContacts(fromStore: store)
                }
            })
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            retrieveContacts(fromStore: store)
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.receivedLongPress(gestureRecognizer:)))
        collectionView.addGestureRecognizer(longPressRecognizer)
        
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        for visibleCell in collectionView.visibleCells() {
            guard let cell = visibleCell as? ContactCollectionViewCell else { continue }
            
            if editing {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                    cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                    cell.backgroundColor = UIColor.clear()
                }, completion: nil)
            }
        }
        
    }
    
    func receivedLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let tappedPoint = gestureRecognizer.location(in: collectionView)
        guard let tappedIndexPath = collectionView.indexPathForItem(at: tappedPoint),
            let tappedCell = collectionView.cellForItem(at: tappedIndexPath) else { return }
        
        if isEditing {
            reorderContact(withCell: tappedCell, atIndexPath: tappedIndexPath, gesture: gestureRecognizer)
        } else {
            deleteContact(withCell: tappedCell, atIndexPath: tappedIndexPath)
        }
    }
    
    func reorderContact(withCell cell: UICollectionViewCell, atIndexPath indexPath: IndexPath, gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: nil)
            break
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            break
        case .ended:
            collectionView.endInteractiveMovement()
            break
        default:
            collectionView.cancelInteractiveMovement()
            break
        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedContact = contacts.remove(at: sourceIndexPath.row)
        contacts.insert(movedContact, at: destinationIndexPath.row)
    }
    
    func deleteContact(withCell cell: UICollectionViewCell, atIndexPath indexPath: IndexPath) {
        let confirmDialog = UIAlertController(title: "Delete this contact?", message: "Are you sure you want to delete this contact?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.contacts.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        })
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        confirmDialog.addAction(deleteAction)
        confirmDialog.addAction(cancelAction)
        
        if let popOver = confirmDialog.popoverPresentationController {
            popOver.sourceView = cell
            
            if let cell = cell as? ContactCollectionViewCell {
                let imageFrame = cell.contactImage.frame
                
                let popOverX = imageFrame.origin.x + imageFrame.size.width / 2
                let popOverY = imageFrame.origin.y + imageFrame.size.height / 2
                
                popOver.sourceRect = CGRect(x: popOverX, y: popOverY, width: 0, height: 0)
            }
        }
        
        present(confirmDialog, animated: true, completion: nil)
    }
    
    func retrieveContacts(fromStore store: CNContactStore) {
        let keysToFetch = [CNContactGivenNameKey,
                           CNContactFamilyNameKey,
                           CNContactImageDataKey,
                           CNContactImageDataAvailableKey,
                           CNContactEmailAddressesKey,
                           CNContactPhoneNumbersKey,
                           CNContactPostalAddressesKey]

        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)

        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).map { contact in
            return HCContact(contact: contact)
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCell", for: indexPath) as! ContactCollectionViewCell
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"

        contact.prefetchImageIfNeeded()
        if let image = contact.contactImage {
            cell.contactImage.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor((collectionView.bounds.width - 2) / 3), height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellsPerRow: CGFloat = 3
        let widthRemainder = (collectionView.bounds.width - (cellsPerRow-1)).truncatingRemainder(dividingBy: cellsPerRow) / (cellsPerRow-1)
        return 1 + widthRemainder
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell else { return }
        
        let downAnimationTiming = UISpringTimingParameters(
                dampingRatio: 0.9,
                initialVelocity: CGVector(dx: 20, dy: 0))
        
        let downAnimator = UIViewPropertyAnimator(
                duration: 0.2,
                timingParameters: downAnimationTiming)
        
        downAnimator.addAnimations {
            cell.contactImage.transform =
                CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        downAnimator.addCompletion { finished in
            let upAnimationTiming = UISpringTimingParameters(
                    dampingRatio: 0.3,
                    initialVelocity: CGVector(dx: 20, dy: 0))
            
            let upAnimator = UIViewPropertyAnimator(
                    duration: 0.2,
                    timingParameters: upAnimationTiming)
            
            upAnimator.addAnimations {
                cell.contactImage.transform =
                    CGAffineTransform.identity
            }
            
            upAnimator.addCompletion { [weak self] finished in
                self?.performSegue(
                    withIdentifier: "contactDetailSegue",
                    sender: self)
            }
            
            upAnimator.startAnimation()
        }
        
        downAnimator.startAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let contactDetailVC = segue.destinationViewController as? ContactDetailViewController
            where segue.identifier == "contactDetailSegue",
            let selectedIndex = collectionView.indexPathsForSelectedItems()?.first {
            
            contactDetailVC.contact = contacts[selectedIndex.row]
        }
    }
}
