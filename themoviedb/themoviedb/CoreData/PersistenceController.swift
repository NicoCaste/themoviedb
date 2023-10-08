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
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.context = context
    }
//MARK: - Save
    func save(favMovie: Movie){
        context.performAndWait {
            guard let movieDetail = NSEntityDescription.insertNewObject(forEntityName: "MovieDetail", into: context) as? MovieDetail
            else { return }
            movieDetail.adult = favMovie.adult ?? false
            movieDetail.backdropPath = favMovie.backdropPath
            movieDetail.id = Int64(favMovie.id ?? 0)
            movieDetail.genreIds = favMovie.genreIds
            movieDetail.originalLanguage = favMovie.originalLanguage
            movieDetail.originalTitle = favMovie.originalTitle
            movieDetail.overview = favMovie.overview
            movieDetail.posterPath = favMovie.posterPath
            movieDetail.releaseDate = favMovie.releaseDate
            movieDetail.voteAverage = favMovie.voteAverage ?? 0
            movieDetail.voteCount = Int32(favMovie.voteCount ?? 0)
            
            try? context.save()
        }
    }
    
//MARK: - Delete
    func deleteMovie(from id: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let movieDetail = self.fetchMovieDetail(id: id)
            guard let objectID = movieDetail?.objectID else { return }
            self.context.performAndWait {
                if let movieInContext = try? self.context.existingObject(with: objectID) {
                    self.context.delete(movieInContext)
                    try? self.context.save()
                }
            }
        }
    }
    
//MARK: - FetchMovie
    @MainActor
    func fetchMovieDetail(id: Int) -> MovieDetail? {
        let fetchRequest = NSFetchRequest<MovieDetail>(entityName: "MovieDetail")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)

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
