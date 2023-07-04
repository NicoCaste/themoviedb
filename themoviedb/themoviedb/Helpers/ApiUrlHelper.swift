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

    static func makeURL(for baseUrl: CallerUrl, url: String) -> String {
        return baseUrl.rawValue + url
    }
}
