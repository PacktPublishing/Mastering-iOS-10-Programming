//
//  MovieDBHelper.swift
//  FamilyMovies
//
//  Created by Donny Wals on 13/08/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Foundation

struct MovieDBHelper {
    typealias MovieDBCallback = (Double?) -> Void
    let apiKey = "d9103bb7a17c9edde4471a317d298d7e"
    
    func fetchRating(forMovie movie: String, callback: MovieDBCallback) {
        guard let searchUrl = url(forMovie: movie) else {
            callback(nil)
            return
        }
        
        let task = URLSession.shared().dataTask(with: searchUrl) { data, response, error in
            var rating: Double? = nil
            
            defer {
                callback(rating)
            }
            
            guard error == nil
                else { return }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let results = json["results"] as? [[String:AnyObject]],
                let popularity = results[0]["popularity"] as? Double
                else { return }
            
            rating = popularity
        }
        
        task.resume()
    }
    
    private func url(forMovie movie: String) -> URL? {
        var urlString = "https://api.themoviedb.org/3/search/movie/"
        urlString = urlString.appending("?api_key=\(apiKey)")
        urlString = urlString.appending("&query=\(movie)")
        
        return URL(string: urlString)
    }
}
