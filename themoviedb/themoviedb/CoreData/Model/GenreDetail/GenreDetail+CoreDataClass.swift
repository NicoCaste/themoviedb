//
//  GenreDetail+CoreDataClass.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//
//

import Foundation
import CoreData
import UIKit

@objc(GenreDetail)
public class GenreDetail: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey { case name, id }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "GenreDetail", in: context)
        else {
            fatalError("Error: with managed object context!")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(Int64.self, forKey: .id)
        saveGenreDetail(id: id, name: name)
    }
    
    private func saveGenreDetail(id: Int64, name: String?) {
        guard let name else { return }
        DispatchQueue.main.async {
            PersistenceController.shared.saveGenreDetail(id: id, name: name)
        }
    }
}
