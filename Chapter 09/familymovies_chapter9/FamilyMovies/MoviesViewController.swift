//
//  MoviesViewController.swift
//  FamilyMovies
//
//  Created by Donny Wals on 30/07/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, AddMovieDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    func saveMovie(withName name: String) {
        print("should save movie with name: \(name)")
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")
            else { fatalError("Wrong cell identifier requested") }
        
        return cell
    }
}
