//
//  Movie.swift
//  FamilyMovies
//
//  Created by Donny Wals on 14/08/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import CoreData

extension Movie {
    static func find(byName name: String, orCreateIn moc: NSManagedObjectContext) -> Movie {
        let predicate = Predicate(format: "name ==[dc] %@", name)
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = predicate
        
        guard let result = try? moc.fetch(request)
            else { return Movie(context: moc) }
        
        return result.first ?? Movie(context: moc)
    }
}
