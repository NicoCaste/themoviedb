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
}
