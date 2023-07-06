//
//  MoviesResult+CoreDataProperties.swift
//  themoviedb
//
//  Created by nicolas castello on 06/07/2023.
//
//

import Foundation
import CoreData


extension MoviesResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesResult> {
        return NSFetchRequest<MoviesResult>(entityName: "MoviesResult")
    }

    @NSManaged public var page: Int32
    @NSManaged public var totalResults: Int32
    @NSManaged public var results: NSOrderedSet?

}

// MARK: Generated accessors for results
extension MoviesResult {

    @objc(insertObject:inResultsAtIndex:)
    @NSManaged public func insertIntoResults(_ value: MovieDetail, at idx: Int)

    @objc(removeObjectFromResultsAtIndex:)
    @NSManaged public func removeFromResults(at idx: Int)

    @objc(insertResults:atIndexes:)
    @NSManaged public func insertIntoResults(_ values: [MovieDetail], at indexes: NSIndexSet)

    @objc(removeResultsAtIndexes:)
    @NSManaged public func removeFromResults(at indexes: NSIndexSet)

    @objc(replaceObjectInResultsAtIndex:withObject:)
    @NSManaged public func replaceResults(at idx: Int, with value: MovieDetail)

    @objc(replaceResultsAtIndexes:withResults:)
    @NSManaged public func replaceResults(at indexes: NSIndexSet, with values: [MovieDetail])

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: MovieDetail)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: MovieDetail)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSOrderedSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSOrderedSet)

}

extension MoviesResult : Identifiable {

}
