//
//  HomeViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation
import UIKit

typealias HomeViewModelProtocol = ViewModelHandleInfoTableViewProtocol & ViewModelHandleApiMoviesProtocol & ViewModelHandleTextFieldProtocol & ViewModelHandleTableViewDataSourceProtocol

class HomeViewModel: BasicViewModel, HomeViewModelProtocol {
    var discoverMovies: MoviesResult?
    var prefetch: [Int: UITableViewCell] = [:]
    private(set) var genders: Genre?
    private var getGendersPossibleRetries: Int = 3
    private(set) var allowedCells: [AllowedCells] =  [.movieCover]
    var currentPage: Int = 1
    var persistence: PersistenceController?
    var movieList: [MovieDetail] = []
    
    override init(repository: TheMovieRepositoryProtocol) {
        super.init(repository: repository)
        Task.detached { [weak self] in
            await self?.getGenreList()
        }
        self.setPersistence()
    }
    
    func setPersistence() {
        DispatchQueue.main.async {
            self.persistence = PersistenceController()
        }
    }

    func getDetailInfo(movie index: Int) -> BasicViewController? {
        guard let movie = movieList[safe: index] else { return nil}
        let vieWModel = DetailViewModel(movieInfo: movie, gendersList: genders?.genres, repository: self.repository)
        return DetailViewController(viewModel: vieWModel)
    }
    
    func getGenreList() async {
        do {
            let response = try await repository.getDataFromMoviesApi(for: .genre, page: nil, includeVideo: nil, includeAdult: nil)
            switch response {
            case .success(let data):
                self.genders = try await data.decodedObject()
            case .failure(_):
                loadCoreDataList()
            }
        } catch {
            await doGenreListCatch()
        }
    }
    
    func restarMovieList() {
        discoverMovies = nil
        movieList = []
        prefetch = [:]
    }
    
    private func doGenreListCatch() async {
        if getGendersPossibleRetries > 0 {
            getGendersPossibleRetries -= 1
            await getGenreList()
        } else {
            loadCoreDataList()
        }
    }
    
    private func loadCoreDataList() {
        let gendreList = getGendreListFromCoreData()
        self.genders = Genre(genres: gendreList)
    }
    
    private func getGendreListFromCoreData() -> [GenreDetail] {
        DispatchQueue.main.sync {
            return persistence?.getGenreList() ?? []
        }
    }
    
    private func getMovieResultFromCoreData(for searchType: PersistenceController.SearchMovie) -> MoviesResult? {
        DispatchQueue.main.sync {
            return persistence?.getMovieResult(for: searchType, currentPage: currentPage)
        }
    }
    
    func getMovies(for path: ApiUrlHelper.PathForMovies, with searchType: PersistenceController.SearchMovie) async {
        do {
            let page: Int? = getPage(for: searchType)
            let response = try await repository.getDataFromMoviesApi(for: path, page: page, includeVideo: true, includeAdult: false)
           switch response {
           case .success(let data):
               discoverMovies = try await data.decodedObject()
               await setMovieList()
           case .failure(_):
               discoverMovies = getMovieResultFromCoreData(for: searchType)
               await setMovieList()
            }
        } catch {
            discoverMovies = getMovieResultFromCoreData(for: searchType)
            await setMovieList()
        }
    }
    
    @MainActor func setMovieList() {
        let discover = self.discoverMovies?.results?.array as? [MovieDetail] ?? []
        movieList.append(contentsOf: discover)
    }
    
    private func getPage(for searchType: PersistenceController.SearchMovie) -> Int? {
        switch searchType {
        case .forPage(let page):
            return page
        default:
            return nil
        }
    }
    
    func getCurrentPage() -> Int {
        currentPage
    }
    
    func nextPage() -> Int {
        currentPage += 1
        return currentPage
    }

    func getPathForUserInput(text: String) -> ApiUrlHelper.PathForMovies {
        let textUrlAllowed = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let path: ApiUrlHelper.PathForMovies = (textUrlAllowed?.isEmpty ?? true || text.isEmpty) ? .discover :  .search(forText: textUrlAllowed ?? text)
        return path 
    }
    
    func getNumberOfRows() -> Int {
        return movieList.count
    }
    
    func getCell(for tableView: UITableView, in row: Int) -> UITableViewCell? {
        let existPrefetch = prefetch.contains(where: {$0.key == row})
        
        if existPrefetch {
            return prefetch[row]
        } else {
            guard let movie = movieList[safe: row] else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
            let height: CGFloat? = 200
            let imageSetting = MovieCoverTableViewCell.ImageSetting(imagePath: movie.backdropPath, width: nil, height: height, corner: 10)
            
            cell?.populate(movieTitle: movie.originalTitle, imageSetting: imageSetting)
            return cell
        }
    }
    
    func savePrefetchCell(for tableView: UITableView, in indexPaths: [IndexPath]) {
        for path in indexPaths {
            if !prefetch.contains(where: {$0.key == path.row}) {
                let cell = getCell(for: tableView, in: path.row)
                prefetch[path.row] = cell
            }
        }
    }
}

extension Array {

    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }

}
