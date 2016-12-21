//
//  ContactDisplayable.swift
//  HelloContacts
//
//  Created by Donny Wals on 27/07/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

protocol ContactDisplayable {
    var displayName: String { get }
    var contactImage: UIImage? { get set }
    
    mutating func prefetchImageIfNeeded()
}
