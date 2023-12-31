//
//  MoviesResult.swift
//  themoviedb
//
//  Created by nicolas castello on 08/10/2023.
//

import Foundation

struct MoviesResult: Decodable {
    var page: Int?
    var totalResults: Int?
    var results: [Movie]?
}
