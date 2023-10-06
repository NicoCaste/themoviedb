//
//  PersistenceController.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import UIKit
import CoreData

enum SearchMovie {
    case forPage(Int?)
    case forTitle(String)
}

class PersistenceController {
    var context: NSManagedObjectContext
    var backgroundContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
        self.context = context
        self.backgroundContext = backgroundContext
    }
//MARK: - Save
    func save(favMovie: MovieDetail){
        backgroundContext.performAndWait {
            let movieDetail = NSEntityDescription.insertNewObject(forEntityName: "MovieDetail", into: backgroundContext) as! MovieDetail
            movieDetail.adult = favMovie.adult
            movieDetail.backdropPath = favMovie.backdropPath
            movieDetail.id = favMovie.id
            movieDetail.genreIds = favMovie.genreIds
            movieDetail.originalLanguage = favMovie.originalLanguage
            movieDetail.originalTitle = favMovie.originalTitle
            movieDetail.overview = favMovie.overview
            movieDetail.posterPath = favMovie.posterPath
            movieDetail.releaseDate = favMovie.releaseDate
            movieDetail.voteAverage = favMovie.voteAverage
            movieDetail.voteCount = favMovie.voteCount
            
            try? backgroundContext.save()
        }
    }
    
//MARK: - Delete
    func delete(movieDetail: MovieDetail) {
        let objectID = movieDetail.objectID
        backgroundContext.performAndWait {
            if let movieInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(movieInContext)
                try? backgroundContext.save()
            }
        }
    }
    
//MARK: - FetchMovie
    func fetchMovieDetail(id: Int32) -> MovieDetail? {
        let fetchRequest = NSFetchRequest<MovieDetail>(entityName: "MovieDetail")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        var movieDetail: MovieDetail?
        
        context.performAndWait {
            do {
                let movies = try context.fetch(fetchRequest)
                movieDetail = movies.first
            } catch let error {
                print("Failed to fetch: \(error)")
            }
        }
        
        return movieDetail
    }
    
//MARK: - Fetch Movies
    func fetchMovieDetails() -> [MovieDetail]? {
        let fetchRequest = NSFetchRequest<MovieDetail>(entityName: "MovieDetail")
        
        var moviesDetail: [MovieDetail]?
        
        context.performAndWait {
            do {
                moviesDetail = try context.fetch(fetchRequest)
            } catch let error {
                print("Failed to fetch: \(error)")
            }
        }
        
        return moviesDetail
    }
}
