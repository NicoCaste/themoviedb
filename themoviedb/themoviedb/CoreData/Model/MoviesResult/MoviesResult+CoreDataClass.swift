//
//  MoviesResult+CoreDataClass.swift
//  themoviedb
//
//  Created by nicolas castello on 08/07/2023.
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
        self.page = decodePage
        self.results = decodeResults
    }
}
