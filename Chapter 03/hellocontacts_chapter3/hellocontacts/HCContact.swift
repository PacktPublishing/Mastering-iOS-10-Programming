//
//  HCContact.swift
//  HelloContacts
//
//  Created by Donny Wals on 17/06/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import Contacts

class HCContact {
    private let contact: CNContact
    var contactImage: UIImage?
    
    var givenName: String {
        return contact.givenName
    }
    
    var familyName: String {
        return contact.familyName
    }
    
    var emailAddress: String {
        return String(contact.emailAddresses.first?.value ?? "--")
    }
    
    var phoneNumber: String {
        return String(contact.phoneNumbers.first?.value.stringValue ?? "--")
    }
    
    var address: String {
        let street = String(contact.postalAddresses.first?.value.street ?? "--")
        let city = String(contact.postalAddresses.first?.value.city ?? "--")
        return "\(street), \(city)"
    }
    
    init(contact: CNContact) {
        self.contact = contact
    }
    
    func prefetchImageIfNeeded() {
        if let imageData = contact.imageData where contactImage == nil {
            contactImage = UIImage(data: imageData)
        }
    }
}
