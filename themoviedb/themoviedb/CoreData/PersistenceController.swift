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
    var context: NSManagedObjectContext
    var backgroundContext: NSManagedObjectContext
    init(context: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
        self.context = context
        self.backgroundContext = backgroundContext
    }
    
    //MARK: Genre
    func getGenreList() -> [GenreDetail]? {
        var genreList: [GenreDetail] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreDetail")
        request.returnsObjectsAsFaults = false
        let result = try? context.fetch(request)
        
        if let resultManaged = result as? [NSManagedObject] {
            for data in resultManaged{
                if let detail = data as? GenreDetail {
                    genreList.append(detail)
                }
            }
        }

        return genreList
    }
    
    func saveGenreDetail(genreDetail: GenreDetail) {
        do {
            let request : NSFetchRequest<GenreDetail> = GenreDetail.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d AND name == %@", genreDetail.id, genreDetail.name ?? "")
            let numberOfRecords = try context.count(for: request)
            if numberOfRecords == 1 {
                try context.save()
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    //MARK: Movie
    func save(movieResult: MoviesResult, page: Int32, results: NSOrderedSet) {
        movieResult.page = page
        movieResult.results = results
        
        backgroundContext.perform {
            do {
                let newResults: [MovieDetail] = MovieDetail.filterByNewMovies(in: results, with: self.context)
                
                if !newResults.isEmpty {
                    movieResult.page = page
                    movieResult.results = NSOrderedSet(array: newResults)
                    try self.backgroundContext.save()
                }
            } catch {
                print("Error saving context \(error)")
            }
        }
    }

    enum SearchMovie {
        case forPage(Int?)
        case forTitle(String)
    }
    
    @MainActor func getMovieResult(for searchCase: SearchMovie, currentPage: Int?) -> MoviesResult? {
        var movies: MoviesResult?
        switch searchCase {
        case .forTitle(let title):
            movies = filter(by: title, currentPage: currentPage)
        case .forPage(let page):
            movies = filter(by: page)
        }
        
        return movies
    }
    
    //MARK: - Movie Filter by Page
    private func filter(by page: Int?) -> MoviesResult? {
        var movies: MoviesResult?
        let result = try? MoviesResult.findForPage(in: context, page: page ?? 1)
        
        if movies == nil {
            movies = result?.first
        }
        
        if let movies = movies {
            let currentMovies = NSMutableOrderedSet()
            for pageMovie in result ?? [] {
                guard let results = pageMovie.results else { continue }
                currentMovies.addObjects(from: results.array)
            }
            
            movies.results = currentMovies
        }
        
        return movies
    }
    
    //MARK: - Movie Filter by title
    private func filter(by title: String?, currentPage: Int?) -> MoviesResult? {
        var movies: MoviesResult?
        guard let title = title else { return nil }
        let result = try? MovieDetail.findForTitle(in: context, text: title)
        movies = MoviesResult(context: context)
        movies?.results = NSOrderedSet(array: result ?? [])
        movies?.page = Int32(currentPage ?? 1)

        return movies
    }
}
