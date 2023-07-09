//
//  BasicViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

class BasicViewModel {
    var repository: TheMovieRepositoryProtocol
    
    init(repository: TheMovieRepositoryProtocol) {
        self.repository = repository
    }
}
