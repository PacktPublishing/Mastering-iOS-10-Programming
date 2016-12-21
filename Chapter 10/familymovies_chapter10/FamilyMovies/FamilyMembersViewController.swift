//
//  FamilyMembersViewController.swift
//  FamilyMovies
//
//  Created by Donny Wals on 30/07/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import CoreData

class FamilyMembersViewController: UIViewController, AddFamilyMemberDelegate, MOCViewControllerType {
    
    @IBOutlet var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<FamilyMember>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let h = MovieDBHelper()
        h.fetchRating(forMovie: "Snatch") {rating in
            print(rating)
        }
        
        guard let moc = managedObjectContext
            else { return }
        
        let fetchRequest: NSFetchRequest<FamilyMember> = FamilyMember.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)

        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }

    }
    
    func saveFamilyMember(withName name: String) {
        guard let moc = managedObjectContext
            else { return }
        
        moc.persist {
            let familyMember = FamilyMember(context: moc)
            familyMember.name = name
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navVC = segue.destinationViewController as? UINavigationController,
            let addFamilyMemberVC = navVC.viewControllers[0] as? AddFamilyMemberViewController {
            
            addFamilyMemberVC.delegate = self
        }
        
        guard let selectedIndex = tableView.indexPathForSelectedRow
            else { return }
        
        tableView.deselectRow(at: selectedIndex, animated: true)
        
        if let moviesVC = segue.destinationViewController as? MoviesViewController,
            let familyMember = fetchedResultsController?.object(at: selectedIndex) {
            moviesVC.managedObjectContext = managedObjectContext
            moviesVC.familyMember = familyMember
        }
    }

}

extension FamilyMembersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell")
            else { fatalError("Wrong cell identifier requested") }
        
        guard let familyMember = fetchedResultsController?.object(at: indexPath)
            else { return cell }
        
        cell.textLabel?.text = familyMember.name
        
        return cell
    }
}

extension FamilyMembersViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: AnyObject,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let insertIndex = newIndexPath
                else { return }
            tableView.insertRows(at: [insertIndex],
                                 with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath
                else { return }
            tableView.deleteRows(at: [deleteIndex],
                                 with: .automatic)
        case .move:
            guard let fromIndex = indexPath,
                let toIndex = newIndexPath
                else { return }
            tableView.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath
                else { return }
            tableView.reloadRows(at: [updateIndex], with: .automatic)
        }
    }

}
