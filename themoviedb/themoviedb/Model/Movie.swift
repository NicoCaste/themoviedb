//
//  Movie.swift
//  themoviedb
//
//  Created by nicolas castello on 08/10/2023.
//

import Foundation

struct Movie: Decodable {
    var id: Int?
    var adult: Bool?
    var backdropPath: String?
    var genreIds: [Int]?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var voteAverage: Float?
    var voteCount: Int?
}
