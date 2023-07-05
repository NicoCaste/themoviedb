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
    
    func getDetailInfo(movie index: Int) -> BasicViewController? {
        guard let movie = discoverMovies?.results[index] else { return nil}
        let vieWModel = DetailViewModel(movieInfo: movie)
        return DetailViewController(viewModel: vieWModel)
    }

    func getMovies(for path: ApiUrlHelper.PathForMovies) async {
        do {
            let response = try await repository.getMovies(for: path, page: 3, includeVideo: true, includeAdult: false)
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
