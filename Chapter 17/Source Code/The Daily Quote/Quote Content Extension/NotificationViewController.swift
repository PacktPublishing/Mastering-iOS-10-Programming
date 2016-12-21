//
//  NotificationViewController.swift
//  Quote Content Extension
//
//  Created by Donny Wals on 27/09/2016.
//  Copyright © 2016 Donny Wals. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var quoteCreator: UILabel!
    
    func didReceive(_ notification: UNNotification) {
        let quote = Quote.current
        quoteLabel.text = quote.text
        quoteCreator.text = quote.creator
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        print(response.actionIdentifier)
        
        completion(.dismissAndForwardAction)
    }

}
