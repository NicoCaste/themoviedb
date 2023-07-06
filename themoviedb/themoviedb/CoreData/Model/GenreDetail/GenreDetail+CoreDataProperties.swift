//
//  GenreDetail+CoreDataProperties.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//
//

import Foundation
import CoreData


extension GenreDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreDetail> {
        return NSFetchRequest<GenreDetail>(entityName: "GenreDetail")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension GenreDetail : Identifiable {

}
