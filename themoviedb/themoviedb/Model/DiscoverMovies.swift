//
//  DiscoverMovies.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

struct DiscoverMovies: Codable {
    var page: Int?
    var totalResults: Int?
    var results: [MovieInfo]
}

struct MovieInfo: Codable {
    var id: Int?
    var genreIds: [Int]?
    var adult: Bool?
    var backdropPath: String?
    var originalTitle: String?
    var voteAverage: Float?
    var posterPath: String?
    var overview: String?
    var originalLanguage: String?
    var voteCount: Int?
    var releaseDate: String 
    var video: Bool?
}
