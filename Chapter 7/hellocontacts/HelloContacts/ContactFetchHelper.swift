//
//  ContactFetchHelper.swift
//  HelloContacts
//
//  Created by Donny Wals on 24-07-16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Contacts

struct ContactFetchHelper {
    typealias ContactFetchCallback = ([ContactDisplayable]) -> Void
    
    let store = CNContactStore()
    
    func fetch(withCallback callback: ContactFetchCallback) {
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: {authorized, error in
                if authorized {
                    self.retrieve(withCallback: callback)
                }
            })
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            retrieve(withCallback: callback)
        }
    }
    
    private func retrieve(withCallback callback: ContactFetchCallback) {
        let keysToFetch = [CNContactGivenNameKey,
                           CNContactFamilyNameKey,
                           CNContactImageDataKey,
                           CNContactImageDataAvailableKey,
                           CNContactEmailAddressesKey,
                           CNContactPhoneNumbersKey,
                           CNContactPostalAddressesKey]
        
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        
        let contacts: [ContactDisplayable] = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).map { contact in
            return HCContact(contact: contact)
        }
        
        callback(contacts)
    }
}
