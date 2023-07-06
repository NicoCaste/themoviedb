//
//  ExtensionData+PrintJson.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

extension Data {
    @MainActor func decodedObject<T: Decodable>() throws -> T {
        guard let context = PersistenceController.shared.context
        else { throw NetWorkingError.unknowError }
        
        let decoder = JSONDecoder(context: context)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: self)
    }
}
