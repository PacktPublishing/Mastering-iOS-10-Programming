//
//  ContactTableViewCell.swift
//  HelloContacts
//
//  Created by Donny Wals on 15/06/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contactImage.image = nil
    }
}
