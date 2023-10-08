//
//  MovieDetail+CoreDataProperties.swift
//  themoviedb
//
//  Created by nicolas castello on 08/10/2023.
//
//

import Foundation
import CoreData


extension MovieDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetail> {
        return NSFetchRequest<MovieDetail>(entityName: "MovieDetail")
    }

    @NSManaged public var id: Int64
    @NSManaged public var originalTitle: String?
    @NSManaged public var adult: Bool
    @NSManaged public var originalLanguage: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var genreIds: [Int]?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var voteAverage: Float
    @NSManaged public var voteCount: Int32

}

extension MovieDetail : Identifiable {

}
