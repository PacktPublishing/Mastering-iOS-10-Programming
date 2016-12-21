//
//  AppDelegate.swift
//  FamilyMovies
//
//  Created by Donny Wals on 30/07/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FamilyMovies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error))")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        if let tabBarController = window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers {
            for viewController in viewControllers {
                guard let navVC = viewController as? UINavigationController,
                    var mocVC = navVC.viewControllers[0] as? MOCViewControllerType
                    else { continue }
                
                mocVC.managedObjectContext = persistentContainer.viewContext
            }
        }
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let pathComponents = url.pathComponents
        guard pathComponents.count == 3
            else { return false }
        
        switch(pathComponents[1], pathComponents[2]) {
        case ("familymember", let name):
            return handleOpenFamilyMemberDetail(withName: name)
        case ("movie", let name):
            return handleOpenMovieDetail(withName: name)
        default:
            return false
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String, userActivity.activityType == CSSearchableItemActionType {
            return handleCoreSpotlightActivity(withIdentifier: identifier)
        }
        
        guard let activityType = IndexingFactory.ActivityType(rawValue: userActivity.activityType)
            else { return false }
        
        switch activityType {
        case .openTab:
            if userActivity.title == "Family Members" {
                return handleOpenTab(withIndex: 0)
            } else if userActivity.title == "Movies" {
                return handleOpenTab(withIndex: 1)
            }
        case .movieDetailView:
            guard let activityName = userActivity.title
                else { return false }
            return handleOpenMovieDetail(withName: activityName)
        case .familyMemberDetailView:
            guard let activityName = userActivity.title
                else { return false }
            
            return handleOpenFamilyMemberDetail(withName: activityName)
        }

        return false
    }
    
    func handleCoreSpotlightActivity(withIdentifier identifier: String) -> Bool {
        guard let url = URL(string: identifier),
            let objectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url),
            let object = try? persistentContainer.viewContext.existingObject(with: objectID)
            else { return false }

        if let movie = object as? Movie {
            return handleOpenMovieDetail(withName: movie.name!)
        }
        
        if let familyMember = object as? FamilyMember {
            return handleOpenFamilyMemberDetail(withName: familyMember.name!)
        }
        
        return false
    }
    
    func handleOpenMovieDetail(withName name: String) -> Bool {
        guard let tabBar = window?.rootViewController as? UITabBarController,
            let navVC = tabBar.viewControllers?[1] as? UINavigationController
            else { return false }
        
        navVC.popToRootViewController(animated: false)
        tabBar.selectedIndex = 1
        
        guard let viewController = navVC.viewControllers[0] as? MoviesListViewController,
            let storyboard = viewController.storyboard
            else { return false }
        
        guard let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController,
            let movie = Movie.find(byName: name, inContext: persistentContainer.viewContext)
            else { return false }
        
        movieDetailViewController.movie = movie
        movieDetailViewController.managedObjectContext = persistentContainer.viewContext
        
        navVC.pushViewController(movieDetailViewController, animated: true)
        
        return true
    }
    
    func handleOpenFamilyMemberDetail(withName name: String) -> Bool {
        guard let tabBar = window?.rootViewController as? UITabBarController,
            let navVC = tabBar.viewControllers?[0] as? UINavigationController
            else { return false }
        
        navVC.popToRootViewController(animated: false)
        tabBar.selectedIndex = 0
        
        guard let viewController = navVC.viewControllers[0] as? FamilyMembersViewController,
            let storyboard = viewController.storyboard
            else { return false }
        
        guard let familyMemberDetailViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as? MoviesViewController,
            let familyMember = FamilyMember.find(byName: name, inContext: persistentContainer.viewContext)
            else { return false }
        
        familyMemberDetailViewController.familyMember = familyMember
        familyMemberDetailViewController.managedObjectContext = persistentContainer.viewContext
        
        navVC.pushViewController(familyMemberDetailViewController, animated: true)
        
        return true
    }
    
    func handleOpenTab(withIndex index: Int) -> Bool {
        guard let tabBar = window?.rootViewController as? UITabBarController,
            let navVC = tabBar.viewControllers?[index] as? UINavigationController
            else { return false }
        
        navVC.popToRootViewController(animated: false)
        tabBar.selectedIndex = index
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let managedObjectContext = persistentContainer.viewContext
        guard let allMovies = try? managedObjectContext.fetch(fetchRequest) else {
            completionHandler(.failed)
            return
        }
        
        let queue = DispatchQueue(label: "movieDBQueue")
        let group = DispatchGroup()
        let helper = MovieDBHelper()
        var dataChanged = false
        
        for movie in allMovies {
            queue.async(group: group) {
                group.enter()
                helper.fetchRating(forMovieId: movie.remoteId) { id, popularity in
                    guard let popularity = popularity
                        , popularity != movie.popularity else {
                        group.leave()
                        return
                    }
                    
                    dataChanged = true
                    
                    managedObjectContext.persist {
                        movie.popularity = popularity
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if dataChanged {
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        persistentContainer.saveContextIfNeeded()
    }


}

