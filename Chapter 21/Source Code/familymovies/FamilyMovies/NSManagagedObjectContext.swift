//
//  NSManagagedObjectContext.swift
//  FamilyMovies
//
//  Created by Donny Wals on 06/08/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func persist(block: @escaping ()->Void) {
        perform {
            block()
            
            do {
                try self.save()
            } catch {
                self.rollback()
            }
        }
    }
}
