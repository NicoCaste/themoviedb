//
//  PersistenceController.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import UIKit
import CoreData

@MainActor
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
        guard let context  else { return [] }
        for movie in results {
            guard let movie = movie as? MovieDetail else { return newResults }
            request.predicate = NSPredicate(format: "id == %i", movie.id)
            
            let numberOfRecords = try? context.count(for: request)
            if numberOfRecords == 1 {
                newResults.append(movie)
            } else {
                request.predicate = nil
            }
        }
        
        return newResults
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
    
    private func filter(by page: Int?) -> MoviesResult? {
        var movies: MoviesResult?
        let result = try? MoviesResult.findForPage(in: context!, page: page ?? 1)
        if movies == nil {
            movies = result?.first
        }
        
        if let movies = movies {
            var currentMovies = NSMutableOrderedSet()
            for pageMovie in result ?? [] {
                guard let results = pageMovie.results else { continue }
                currentMovies.addObjects(from: results.array)
            }
            
            movies.results = currentMovies
        }
        
        return movies
    }
    
    private func filter(by title: String?, currentPage: Int?) -> MoviesResult? {
        var movies: MoviesResult?
        guard let context = context, let title = title else { return nil }
        let result = try? MoviesResult.findForTitle(in: context, text: title)
        if movies == nil {
            movies = MoviesResult(context: context)
            movies?.results = NSOrderedSet(array: result ?? [])
            movies?.page = Int32(currentPage ?? 1)
        } else {
            guard let moviesResults = movies?.results,
                  let currentMoviesResult = result
            else { return nil }
            
            let newList = NSMutableOrderedSet(array: moviesResults.array)
            newList.addObjects(from: currentMoviesResult)
            movies?.results = newList
        }
        return movies
    }
}
