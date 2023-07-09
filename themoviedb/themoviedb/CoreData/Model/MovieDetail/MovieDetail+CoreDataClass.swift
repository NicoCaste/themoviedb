//
//  MovieDetail+CoreDataClass.swift
//  themoviedb
//
//  Created by nicolas castello on 06/07/2023.
//
//

import Foundation
import CoreData

@objc(MovieDetail)
public class MovieDetail:  NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath
        case genreIds
        case originalLanguage
        case originalTitle
        case overview
        case posterPath
        case releaseDate
        case voteAverage
        case voteCount
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "MovieDetail", in: context)
        else {
            fatalError("Error: with managed object context!")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let idDecode = try? values.decode(Int32.self, forKey: .id)
        id = idDecode ?? 0
        adult = ((try? values.decode(Bool.self, forKey: .adult)) != nil)
        backdropPath = try? values.decode(String.self, forKey: .backdropPath)
        genreIds = try? values.decode([Int].self, forKey: .genreIds) as NSObject
        originalLanguage = try? values.decode(String.self, forKey: .originalLanguage)
        originalTitle = try? values.decode(String.self, forKey: .originalTitle)
        overview = try? values.decode(String.self, forKey: .overview)
        posterPath = try? values.decode(String.self, forKey: .posterPath)
        releaseDate = try? values.decode(String.self, forKey: .releaseDate)
        let setVote = try? values.decode(Float.self, forKey: .voteAverage)
        voteAverage = setVote ?? 0
        let setCount = try? values.decode(Int32.self, forKey: .voteCount)
        voteCount = setCount ?? 0
    }
}

extension MovieDetail {
    static func findForTitle(in context: NSManagedObjectContext, text: String) throws -> [MovieDetail] {
        var newResults: [MovieDetail] = []
        let request : NSFetchRequest<MovieDetail> = MovieDetail.fetchRequest()
        if !text.isEmpty {
            request.predicate = NSPredicate(format: "originalTitle CONTAINS[cd] %@", text)
        }

        newResults = try context.fetch(request)

        return newResults
    }
    
    static func filterByNewMovies(in results: NSOrderedSet, with context: NSManagedObjectContext? ) -> [MovieDetail] {
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
}
