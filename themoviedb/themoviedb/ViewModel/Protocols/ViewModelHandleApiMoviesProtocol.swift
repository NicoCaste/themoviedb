//
//  ViewModelHandleApiMoviesProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation

protocol ViewModelHandleApiMoviesProtocol: BasicViewModel {
    func getCurrentPage() -> Int
    func nextPage() -> Int
    func restarMovieList()
    func getMovies(for path: ApiUrlHelper.PathForMovies, with searchType: SearchMovie) async
}
