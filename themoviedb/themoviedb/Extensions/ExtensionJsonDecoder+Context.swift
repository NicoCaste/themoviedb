//
//  ExtensionJsonDecoder+Context.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}
