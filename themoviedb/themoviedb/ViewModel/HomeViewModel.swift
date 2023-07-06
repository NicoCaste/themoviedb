//
//  HomeViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation
import UIKit

class HomeViewModel: BasicViewModel {
    var discoverMovies: MoviesResult?
    private var genders: Genre?
    private var getGendersPossibleRetries: Int = 3
    let allowedCells: [AllowedCells] =  [.movieCover]
    var currentPage: Int = 1
    
    override init() {
        super.init()
        Task.detached { [weak self] in
            await self?.getGenreList()
        }
    }

    func getDetailInfo(movie index: Int) -> BasicViewController? {
        guard let movie = discoverMovies?.results?[index] as? MovieDetail else { return nil}
        let vieWModel = DetailViewModel(movieInfo: movie, gendersList: genders?.genres)
        return DetailViewController(viewModel: vieWModel)
    }
    
    private func getGenreList() async {
        do {
            let response = try await repository.getDataFromMoviesApi(for: .genre)
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
            return PersistenceController.shared.getGenreList() ?? []
        }
    }
    
    private func getMovieResultFromCoreData(for searchType: PersistenceController.SearchMovie) -> MoviesResult? {
        DispatchQueue.main.sync {
            return PersistenceController.shared.getMovieResult(for: searchType, currentPage: currentPage)
        }
    }
    
    func getMovies(for path: ApiUrlHelper.PathForMovies, with searchType: PersistenceController.SearchMovie) async {
        do {
            let page: Int? = getPage(for: searchType)
            let response = try await repository.getDataFromMoviesApi(for: path, page: page, includeVideo: true, includeAdult: false)
           switch response {
           case .success(let data):
               discoverMovies = try await data.decodedObject()
           case .failure(_):
               discoverMovies = getMovieResultFromCoreData(for: searchType)
            }
        } catch {
            discoverMovies = getMovieResultFromCoreData(for: searchType)
        }
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

    func getPathForUserInput(text: String) -> ApiUrlHelper.PathForMovies {
        let textUrlAllowed = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let path: ApiUrlHelper.PathForMovies = (textUrlAllowed?.isEmpty ?? true || text.isEmpty) ? .discover :  .search(forText: textUrlAllowed ?? text)
        return path 
    }
    
    func getNumberOfRows() -> Int {
        return discoverMovies?.results?.count ?? 0
    }
    
    func getCell(for tableView: UITableView, in row: Int) -> UITableViewCell? {
        guard let movie = discoverMovies?.results?[row] as? MovieDetail else { return nil }
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
        let height: CGFloat? = 200
        let imageSetting = MovieCoverTableViewCell.ImageSetting(imagePath: movie.backdropPath, width: nil, height: height, corner: 10)
        
        cell?.populate(movieTitle: movie.originalTitle, imageSetting: imageSetting)
        return cell
    }
}
