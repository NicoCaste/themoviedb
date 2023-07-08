//
//  MoviesResult+CoreDataClass.swift
//  themoviedb
//
//  Created by nicolas castello on 06/07/2023.
//
//

import Foundation
import CoreData

@objc(MoviesResult)
public class MoviesResult: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey {
        case page, totalResults, results
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "MoviesResult", in: context)
        else {
            fatalError("Error: with managed object context!")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodePage = try values.decode(Int32.self, forKey: .page)
        let decodeResults = NSOrderedSet(array: try values.decode([MovieDetail].self, forKey: .results))
        saveMoviesResult(page: decodePage, results: decodeResults)
    }
    
    private func saveMoviesResult(page: Int32?, results: NSOrderedSet?) {
        guard let page, let results else { return }
        DispatchQueue.main.async {
            PersistenceController().save(movieResult: self, page: page, results: results)
        }
    }
}

extension MoviesResult {
    static func findAll(in managedObjectContext: NSManagedObjectContext) throws -> [MoviesResult] {
        var moviesResults: [MoviesResult] = []
        let request: NSFetchRequest<MoviesResult> = MoviesResult.fetchRequest()
        request.returnsObjectsAsFaults = false
        moviesResults = try managedObjectContext.fetch(request)
        
        return  moviesResults
    }
    
    static func findForPage(in context: NSManagedObjectContext, page: Int) throws -> [MoviesResult] {
        var newResults: [MoviesResult] = []
        let request : NSFetchRequest<MoviesResult> = MoviesResult.fetchRequest()

        request.predicate = NSPredicate(format: "page ==  %i", page)

        newResults = try context.fetch(request)

        return newResults
    }
}
