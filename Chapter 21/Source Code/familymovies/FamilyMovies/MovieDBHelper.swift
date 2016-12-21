//
//  MovieDBHelper.swift
//  FamilyMovies
//
//  Created by Donny Wals on 13/08/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Foundation

struct MovieDBHelper {
    typealias MovieDBCallback = (Int?, Double?) -> Void
    static let apiKey = "d9103bb7a17c9edde4471a317d298d7e"

    enum Endpoint {
        case search
        case movieById(Int64)
        
        var urlString: String {
            let baseUrl = "https://api.themoviedb.org/3/"

            switch self {
            case .search:
                var urlString = "\(baseUrl)search/movie/"
                urlString = urlString.appending("?api_key=\(MovieDBHelper.apiKey)")
                return urlString
            case let .movieById(movieId):
                var urlString = "\(baseUrl)movie/\(movieId)"
                urlString = urlString.appending("?api_key=\(MovieDBHelper.apiKey)")
                return urlString
            }
        }
    }

    func fetchRating(forMovie movie: String, callback: @escaping MovieDBCallback) {
        let searchUrl = url(forMovie: movie)
        let extractData: DataExtractionCallback = { json in
            guard let results = json["results"] as? [[String:AnyObject]],
                results.count > 0,
                let popularity = results[0]["popularity"] as? Double,
                let id = results[0]["id"] as? Int
                else { return (nil, nil) }
            
            return (id, popularity)
        }
        
        fetchRating(fromUrl: searchUrl, extractData: extractData, callback: callback)
    }

    func fetchRating(forMovieId id: Int64, callback: @escaping MovieDBCallback) {
        let movieUrl = url(forMovieId: id)
        let extractData: DataExtractionCallback = { json in
            guard let popularity = json["popularity"] as? Double,
                let id = json["id"] as? Int
                else { return (nil, nil) }
            
            return (id, popularity)
        }
        
        fetchRating(fromUrl: movieUrl, extractData: extractData, callback: callback)
    }
    
    typealias JSON = [String: Any]
    typealias IdAndRating = (id: Int?, rating: Double?)
    typealias DataExtractionCallback = (JSON) -> IdAndRating

    private func fetchRating(fromUrl url: URL?, extractData: @escaping DataExtractionCallback, callback: @escaping MovieDBCallback) {
        guard let url = url else {
            callback(nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var rating: Double? = nil
            var remoteId: Int? = nil
            
            defer {
                callback(remoteId, rating)
            }
            
            guard error == nil
                else { return }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                else { return }

            let resultingData = extractData(json as! [String: Any])
            rating = resultingData.rating
            remoteId = resultingData.id
        }
        
        task.resume()
    }
    
    

    func url(forMovie movie: String) -> URL? {
        guard let escapedMovie = movie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else { return nil }
        
        var urlString = Endpoint.search.urlString
        urlString = urlString.appending("&query=\(escapedMovie)")
        
        return URL(string: urlString)
    }

    func url(forMovieId id: Int64) -> URL? {
        let urlString = Endpoint.movieById(id).urlString
        return URL(string: urlString)
    }
}
