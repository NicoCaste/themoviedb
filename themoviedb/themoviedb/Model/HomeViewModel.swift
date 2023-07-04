//
//  HomeViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

class BasicViewModel {
    var repository: TheMovieRepository
    
    init() {
        let webService = UrlSessionWebService()
        self.repository = TheMovieRepository(webService: webService)
    }
}

class HomeViewModel: BasicViewModel {
    
    func getNumberOfRows() -> Int {
        100
    }
    
    func handleUserInput(text: String) {
        print(text)
    }
    
    func getMovies() async {
        try? await repository.getMovies(page: 1, includeVideo: true, includeAdult: true)
    }
}
