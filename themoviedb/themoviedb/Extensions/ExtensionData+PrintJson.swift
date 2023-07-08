//
//  ExtensionData+PrintJson.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

extension Data {
    @MainActor func decodedObject<T: Decodable>() throws -> T {
        let context = PersistenceController().context
        let decoder = JSONDecoder(context: context)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: self)
    }
}
