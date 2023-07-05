//
//  ApiUrlHelper.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

class ApiUrlHelper {
    enum CallerUrl: String {
        case theMovieApi = "https://api.themoviedb.org/3/"
        case getImage = "https://image.tmdb.org/t/p/w500"
    }
    
    enum PathForMovies {
        case discover
        case genre
        case search(forText: String)
        case image(path: String?)
        
        var stringValue: String {
            switch self {
            case .discover: return "discover/movie?"
            case .search(forText: let query): return "search/movie?query=\(query)&"
            case .image(path: let path): return path ?? ""
            case .genre: return "genre/movie/list?"
            }
        }
    }

    static func makeURL(for baseUrl: CallerUrl, url: PathForMovies) -> String {
        return baseUrl.rawValue + url.stringValue
    }
}
