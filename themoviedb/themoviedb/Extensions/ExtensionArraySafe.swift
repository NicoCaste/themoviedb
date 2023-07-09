//
//  ExtensionArraySafe.swift
//  themoviedb
//
//  Created by nicolas castello on 09/07/2023.
//

import Foundation

extension Array {

    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}
