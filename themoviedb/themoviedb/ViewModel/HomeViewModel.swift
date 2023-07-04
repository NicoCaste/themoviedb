//
//  HomeViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

class HomeViewModel: BasicViewModel {
    var discoverMovies: DiscoverMovies?
    
    func getNumberOfRows() -> Int {
        return discoverMovies?.results.count ?? 1
    }

    func getMovies(for path: TheMovieRepository.PathForMovies) async {
        do {
            let response = try await repository.getMovies(for: path, page: 3, includeVideo: true, includeAdult: true)
           switch response {
           case .success(let data):
                discoverMovies = try data.decodedObject()
            case .failure(let error):
                print(error)
            }
        } catch {
            print(NetWorkingError.serverError)
        }
    }
}
