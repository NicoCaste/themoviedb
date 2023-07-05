//
//  HomeViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

class HomeViewModel: BasicViewModel {
    var discoverMovies: DiscoverMovies?
    private var genders: Genre?
    private var getGendersPossibleRetries: Int = 3
    
    override init() {
        super.init()
        Task.detached { [weak self] in
            await self?.getGenreList()
        }
    }
    
    func getNumberOfRows() -> Int {
        return discoverMovies?.results.count ?? 1
    }
    
    func getDetailInfo(movie index: Int) -> BasicViewController? {
        guard let movie = discoverMovies?.results[index] else { return nil}
        let vieWModel = DetailViewModel(movieInfo: movie, gendersList: genders?.genres)
        return DetailViewController(viewModel: vieWModel)
    }
    
    private func getGenreList() async {
        do {
            let response = try await repository.getDataFromMoviesApi(for: .genre)
            switch response {
            case .success(let data):
                self.genders = try data.decodedObject()
            case .failure(let error):
                print(error)
            }
        } catch {
            if getGendersPossibleRetries > 0 {
                getGendersPossibleRetries -= 1
                await getGenreList()
            }
        }
    }

    func getMovies(for path: ApiUrlHelper.PathForMovies) async {
        do {
            let response = try await repository.getDataFromMoviesApi(for: path, page: 3, includeVideo: true, includeAdult: false)
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