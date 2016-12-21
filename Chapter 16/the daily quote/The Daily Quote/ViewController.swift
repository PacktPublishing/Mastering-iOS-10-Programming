//
//  ViewController.swift
//  The Daily Quote
//
//  Created by Donny Wals on 20-09-16.
//  Copyright © 2016 Donny Wals. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController {
    
    let notificationCenter = UNUserNotificationCenter.current()
    @IBOutlet var notificationSugestionLabel: UILabel!
    @IBOutlet var enableNotificationsButton: UIButton!
    
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var quoteCreator: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quote = Quote.current
        quoteLabel.text = quote.text
        quoteCreator.text = quote.creator
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notificationCenter.getNotificationSettings {[weak self] settings in
            let authorizationStatus = settings.authorizationStatus
            
            switch(authorizationStatus) {
            case .authorized:
                self?.hideNotificationsUI()
                self?.scheduleNotification()
                UIApplication.shared.registerForRemoteNotifications()
            case .denied:
                self?.showNotificationsUI()
            default: return
            }
        }
    }

    func hideNotificationsUI() {
        DispatchQueue.main.async { [weak self] in
            self?.notificationSugestionLabel.isHidden = true
            self?.enableNotificationsButton.isHidden = true
        }
    }

    func showNotificationsUI() {
        DispatchQueue.main.async { [weak self] in
            self?.notificationSugestionLabel.isHidden = true
            self?.enableNotificationsButton.isHidden = true
        }
    }
    
    func createNotification() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "New quote available"
        content.body = "A new quote is waiting for you in The Daily Quote"
        content.badge = 1
        
        content.categoryIdentifier = "quote"
        
        return content
    }
    
    @IBAction func enableNotificationsTapped() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            let authorizationStatus = settings.authorizationStatus
            
            switch(authorizationStatus) {
            case .notDetermined:
                self?.notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
                    guard error == nil, granted == true
                        else { return }
                    
                    self?.hideNotificationsUI()
                    self?.scheduleNotification()
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                UIApplication.shared.open(settingsUrl!,
                                          options: [:],
                                          completionHandler: nil)
            default: return
            }
        }
    }
    
    func scheduleNotification () {
        //var components = DateComponents()
        //components.hour = 8
        //let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "new-quote",
                                            content: createNotification(),
                                            trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: nil)
    }
}

