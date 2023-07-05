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
    
    func printAsJSON() {
        #if DEBUG
        if let theJSONData = try? JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary {
            var swiftDict: [String: Any] = [:]
            for key in theJSONData.allKeys {
                let stringKey = key as? String
                if let key = stringKey, let keyValue = theJSONData.value(forKey: key) {
                    swiftDict[key] = keyValue
                }
            }
            swiftDict.printAsJSON()
        }
        #endif
    }
}
