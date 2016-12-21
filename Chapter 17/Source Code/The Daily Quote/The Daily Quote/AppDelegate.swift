//
//  AppDelegate.swift
//  The Daily Quote
//
//  Created by Donny Wals on 21-09-16.
//  Copyright © 2016 Donny Wals. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        let favoriteAction = UNNotificationAction(identifier: "addfavorite", title: "Favorite", options: [])
        let viewAction = UNNotificationAction(identifier: "view", title: "View in app", options: [.foreground])

        let quoteCategory = UNNotificationCategory(identifier: "quote", actions: [favoriteAction, viewAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([quoteCategory])
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let action = response.actionIdentifier
        
        let notificationTitle = notification.request.content.title
        let customAttributes = notification.request.content.userInfo
        
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("received device token: \(deviceToken)")
    }

}

