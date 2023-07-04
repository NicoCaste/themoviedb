//
//  BasicViewModel.swift
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
