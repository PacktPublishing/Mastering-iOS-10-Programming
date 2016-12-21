//
//  Movie.swift
//  FamilyMovies
//
//  Created by Donny Wals on 14/08/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import CoreData

extension Movie {
    static func find(byName name: String, inContext moc: NSManagedObjectContext) -> Movie? {
        let predicate = NSPredicate(format: "name ==[dc] %@", name)
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = predicate
        
        guard let result = try? moc.fetch(request)
            else { return nil }
        
        return result.first
    }
    
    static func find(byName name: String, orCreateIn moc: NSManagedObjectContext) -> Movie {
        guard let movie = find(byName: name, inContext: moc)
            else { return Movie(context: moc) }
        
        return movie
    }
}
