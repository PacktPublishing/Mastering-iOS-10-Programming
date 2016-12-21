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
    
    func saveFamilyMember(withName name: String) {
        
        
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
    }

}

extension FamilyMembersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell")
            else { fatalError("Wrong cell identifier requested") }
        
        return cell
    }
}
