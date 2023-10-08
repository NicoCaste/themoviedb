//
//  ExtensionData+PrintJson.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

extension Data {
    @MainActor func decodedObject<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: self)
    }
}
