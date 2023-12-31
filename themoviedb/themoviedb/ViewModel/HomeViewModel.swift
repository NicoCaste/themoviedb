//
//  HomeViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation
import UIKit
import CoreData

enum FilmsSections: Int, CaseIterable {
    case SUBSCRIBED
    case MOVIELIST
}

typealias HomeViewModelProtocol = ViewModelHandleInfoTableViewProtocol & ViewModelHandleApiMoviesProtocol & ViewModelHandleTextFieldProtocol & ViewModelHandleTableViewDataSourceProtocol & ViewModelHandleSubscribedMovies

class HomeViewModel: BasicViewModel, HomeViewModelProtocol {
    private(set) var genders: Genre?
    private var getGendersPossibleRetries: Int = 3
    private(set) var allowedCells: [AllowedCells] =  [.movieCover, .centerTitleTableViewCell, .movieSubscribed]
    private var context: NSManagedObjectContext?
    
    var discoverMovies: MoviesResult?
    var prefetch: [Int: UITableViewCell] = [:]
    var startPage: Int = 1
    var persistence: PersistenceController?
    var movieList: [Movie] = []
    var subscribedMovies: [Movie] = []
    var _sections: Int = FilmsSections.MOVIELIST.rawValue
    var sections: Int {
        get {
            reloadSubscribedMovies()
            return _sections
        }
        
        set(newValue) {
            _sections = newValue
        }
    }
    
    required init(repository: TheMovieRepositoryProtocol, context: NSManagedObjectContext? = nil) {
        self.context = context
        super.init(repository: repository)
        Task.detached { [weak self] in
            await self?.getGenreList()
            await self?.setPersistence()
        }
    }

    func getDetailInfo(from index: Int) -> BasicViewController? {
        guard let movie = movieList[safe: index] else { return nil }
        let viewModel = DetailViewModel(movieInfo: movie, gendersList: genders?.genres, repository: self.repository)
        return getDetailViewController(with: viewModel)
    }
    
    func getDetailInfo(from movie: Movie?) -> BasicViewController? {
        guard let movie = movie else { return nil }
        let viewModel = DetailViewModel(movieInfo: movie, gendersList: genders?.genres, repository: self.repository)
        return getDetailViewController(with: viewModel)
    }
    
    func getDetailViewController(with viewModel: DetailViewModel) -> DetailViewController {
        DetailViewController(viewModel: viewModel)
    }
    
    func restarMovieList() {
        discoverMovies = nil
        movieList = []
        prefetch = [:]
    }
    
    func updateSubscribedMovies() {
        subscribedMovies = []
        persistence?.fetchMovieDetails()?.forEach({
            var movie = Movie()
            movie.id = Int($0.id)
            movie.adult = $0.adult
            movie.backdropPath = $0.backdropPath
            movie.genreIds = $0.genreIds
            movie.originalLanguage = $0.originalLanguage
            movie.originalTitle = $0.originalTitle
            movie.overview = $0.overview
            movie.posterPath = $0.posterPath
            movie.releaseDate = $0.releaseDate
            movie.voteAverage = $0.voteAverage
            movie.voteCount = Int($0.voteCount)
            subscribedMovies.append(movie)
        })
    }
    
    func reloadSubscribedMovies() {
        updateSubscribedMovies()
        updateSections()
    }
    
    func updateSections() {
        sections = subscribedMovies.isEmpty ? FilmsSections.MOVIELIST.rawValue : FilmsSections.allCases.count
    }
        
    @MainActor func setMovieList() {
        if let discover = self.discoverMovies?.results as? [Movie], !discover.isEmpty  {
            movieList += discover 
        } else {
            movieList = []
        }
    }

    //MARK: - Pagination
    func getCurrentPage() -> Int {
        return discoverMovies?.page != nil ? Int(discoverMovies?.page ?? 1) : startPage
    }
    
    func nextPage() -> Int {
        let currentPage = Int(discoverMovies?.page ?? 1)
        return  currentPage + 1
    }
}

//MARK: - TextField
extension HomeViewModel {
    func getPathForUserInput(text: String) -> ApiUrlHelper.PathForMovies {
        let textUrlAllowed = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let path: ApiUrlHelper.PathForMovies = (textUrlAllowed?.isEmpty ?? true || text.isEmpty) ? .discover :  .search(forText: textUrlAllowed ?? text)
        return path
    }
}

//MARK: TableView Data
extension HomeViewModel {
    
    //MARK: - Number Of Rows
    func getNumberOfRows(for section: Int) -> Int {
        if section == FilmsSections.SUBSCRIBED.rawValue && sections == FilmsSections.allCases.count {
            return 1
        } else {
            return movieList.count
        }
    }
    
    //MARK: GetCell
    func getCell(for tableView: UITableView, in row: Int, for section: Int) -> UITableViewCell? {
        reloadSubscribedMovies()
        if section == FilmsSections.SUBSCRIBED.rawValue && sections == FilmsSections.allCases.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieSubscribed.rawValue) as? MovieSubscribedTableViewCell
            cell?.populate(movies: subscribedMovies)
            return cell
        } else {
            return getMovieCoverCell(for: row, in: tableView)
        }
    }
    
    func getMovieCoverCell(for row: Int, in tableView: UITableView) -> UITableViewCell? {
        let existPrefetch = prefetch.contains(where: {$0.key == row})
        if existPrefetch {
            return getPrefetchCell(from: row)
        } else {
            return getMovieCell(from: row, in: tableView)
        }
    }
    
    func getPrefetchCell(from row: Int) -> UITableViewCell? {
        let cell = prefetch[row]
        prefetch[row] = nil
        return cell
    }
    
    func getMovieCell(from row: Int, in tableView: UITableView) -> UITableViewCell? {
        guard let movie = movieList[safe: row] else { return nil }
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
        let height: CGFloat? = 200
        let imageSetting = ImageSetting(imagePath: movie.backdropPath, width: nil, height: height, corner: 10)
        
        cell?.populate(movieTitle: movie.originalTitle, imageSetting: imageSetting)
        return cell
    }
    
    //MARK: Prefetch
    func savePrefetchCell(for tableView: UITableView, in indexPaths: [IndexPath]) {
        if movieList.isEmpty { return }
        DispatchQueue.main.async {
            for path in indexPaths {
                if !self.prefetch.contains(where: {$0.key == path.row}) {
                    let cell = self.getCell(for: tableView, in: path.row, for: path.section)
                    self.prefetch[path.row] = cell
                }
            }
        }
    }
}

//MARK: - Core Data
extension HomeViewModel {
    //MARK: - Set Persistence
    @MainActor
    func setPersistence() {
        self.persistence = self.context != nil ? PersistenceController(context: context!) : PersistenceController()
    }
}

//MARK: - Network
extension HomeViewModel {
    //MARK: - Genre List
    func getGenreList() async {
        do {
            let response = try await repository.getDataFromMoviesApi(for: .genre, page: nil, includeVideo: nil, includeAdult: nil)
            switch response {
            case .success(let data):
                self.genders = try await data.decodedObject()
            case .failure(_):
                break
            }
        } catch {
            await doGenreListCatch()
        }
    }
    
    //MARK: - Movie List Network
    func getMovies(for path: ApiUrlHelper.PathForMovies, with searchType: SearchMovie) async {
        do {
            let page: Int? = getPage(for: searchType)
            let response = try await repository.getDataFromMoviesApi(for: path, page: page, includeVideo: true, includeAdult: false)
           switch response {
           case .success(let data):
               discoverMovies = try await data.decodedObject()
               await setMovieList()
           case .failure(_):
               await setMovieList()
            }
        } catch {
            await setMovieList()
        }
    }
    
    private func getPage(for searchType: SearchMovie) -> Int? {
        switch searchType {
        case .forPage(let page):
            return page
        default:
            return nil
        }
    }
    
    private func doGenreListCatch() async {
        if getGendersPossibleRetries > 0 {
            getGendersPossibleRetries -= 1
            await getGenreList()
        }
    }
}
