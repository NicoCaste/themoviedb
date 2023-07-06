//
//  PersistenceController.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import UIKit
import CoreData

class PersistenceController {
    @MainActor let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    static var shared = PersistenceController()
    
    private init() {}
    
    func getGenreList() -> [GenreDetail]? {
        var genreList: [GenreDetail] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreDetail")
        request.returnsObjectsAsFaults = false
        let result = try? context?.fetch(request)
        
        if let resultManaged = result as? [NSManagedObject] {
            for data in resultManaged{
                if let detail = data as? GenreDetail {
                    genreList.append(detail)
                }
            }
        }

        return genreList
    }
    
    func saveGenreDetail(id: Int64, name: String) {
        do {
            guard let context else { return }
            let request : NSFetchRequest<GenreDetail> = GenreDetail.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d AND name == %@", id, name)
            let numberOfRecords = try context.count(for: request)
            if numberOfRecords == 1 {
                try context.save()
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func save(movieResult: MoviesResult, page: Int32, results: NSOrderedSet) {
        do {
            guard let context  else { return }
            let newResults: [MovieDetail] = getOnlyNewMovies(from: results)
            
            if !newResults.isEmpty {
                movieResult.page = page
                movieResult.results = NSOrderedSet(array: newResults)
                try context.save()
            }
            
            movieResult.page = page
            movieResult.results = results
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func getOnlyNewMovies(from results: NSOrderedSet) -> [MovieDetail] {
        var newResults: [MovieDetail] = []
        let request : NSFetchRequest<MovieDetail> = MovieDetail.fetchRequest()

        for movie in results {
            guard let movie = movie as? MovieDetail else { return newResults }
            request.predicate = NSPredicate(format: "id == %i", movie.id)
            
            if request.predicate == nil {
                newResults.append(movie)
            } else {
                request.predicate = nil
            }
        }
        
        return newResults
    }
    
    func getMovieResult(pageNumber: Int) -> MoviesResult? {
        var movies: MoviesResult?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesResult")
        request.returnsObjectsAsFaults = false
        let result = try? self.context?.fetch(request)
        
        if let resultManaged = result as? [NSManagedObject] {
            for data in resultManaged {
                if let detail = data as? MoviesResult, detail.page == pageNumber, detail.results != nil || detail.results?.count ?? 0 > 0 {
                    movies = detail
                }
            }
        }
        
        return movies
    }
}
