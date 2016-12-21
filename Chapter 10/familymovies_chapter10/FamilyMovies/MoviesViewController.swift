//
//  MoviesViewController.swift
//  FamilyMovies
//
//  Created by Donny Wals on 30/07/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import CoreData

class MoviesViewController: UIViewController, AddMovieDelegate, MOCViewControllerType {
    
    @IBOutlet var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext?
    var familyMember: FamilyMember?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NotificationCenter.default()
        center.addObserver(self,
                           selector: #selector(self.mangedObjectContextDidChange(notification:)),
                           name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                           object: nil)
    }
    
    deinit {
        let center = NotificationCenter.default()
        center.removeObserver(self)
    }
    
    func saveMovie(withName name: String) {
        guard let moc = managedObjectContext,
            let familyMember = self.familyMember
            else { return }
        
        moc.persist {
            let movie = Movie(context: moc)
            
            movie.name = name
            familyMember.favoriteMovies =
                familyMember.favoriteMovies?.adding(movie)
            
            let helper = MovieDBHelper()
            helper.fetchRating(forMovie: name) { rating in
                guard let rating = rating
                    else { return }
                
                moc.persist {
                    movie.popularity = rating
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navVC = segue.destinationViewController as? UINavigationController,
            let addMovieVC = navVC.viewControllers[0] as? AddMovieViewController {
            
            addMovieVC.delegate = self
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyMember?.favoriteMovies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell"),
            let movies = familyMember?.favoriteMovies
            else { fatalError("Wrong cell identifier requested") }
        
        let moviesArray = Array(movies as! Set<Movie>)
        let movie = moviesArray[indexPath.row]
        cell.textLabel?.text = movie.name
        cell.detailTextLabel?.text = "Rating: \(movie.popularity)"
        
        return cell
    }
}

extension MoviesViewController {
    func mangedObjectContextDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo
            else { return }
        
        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<FamilyMember>,
            let familyMember = self.familyMember where updatedObjects.contains(familyMember) {
            
            tableView.reloadData()
        }

        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<Movie> {
            for object in updatedObjects {
                if object.familyMember == familyMember {
                    tableView.reloadData()
                    break
                }
            }
        }
    }
}
