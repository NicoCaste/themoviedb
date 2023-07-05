//
//  ExtensionDictionary+JsonPrint.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

extension Dictionary {
    func printAsJSON() {
        #if DEBUG
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("\(theJSONText)")
        }
        #endif
    }
}
