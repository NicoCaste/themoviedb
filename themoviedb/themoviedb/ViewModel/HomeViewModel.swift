//
//  HomeViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation
import UIKit

class HomeViewModel: BasicViewModel {
    var discoverMovies: DiscoverMovies?
    private var genders: Genre?
    private var getGendersPossibleRetries: Int = 3
    let allowedCells: [AllowedCells] =  [.movieCover]
    
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
                self.genders = try await data.decodedObject()
            case .failure(let error):
                print(error)
            }
        } catch {
            if getGendersPossibleRetries > 0 {
                getGendersPossibleRetries -= 1
                await getGenreList()
            } else {
                let gendreList = getGendreListFromCoreData()
                self.genders = Genre(genres: gendreList)
            }
        }
    }
    
    func getGendreListFromCoreData() -> [GenreDetail] {
        var list: [GenreDetail] = []
        DispatchQueue.main.sync {
            list = PersistenceController.shared.getGenreList() ?? []
        }
        return list
    }
    
    func getMovies(for path: ApiUrlHelper.PathForMovies) async {
        do {
            let response = try await repository.getDataFromMoviesApi(for: path, page: 3, includeVideo: true, includeAdult: false)
           switch response {
           case .success(let data):
               discoverMovies = try await data.decodedObject()
            case .failure(let error):
                print(error)
            }
        } catch {
            print(NetWorkingError.serverError)
        }
    }
    
    func getPathForUserInput(text: String) -> ApiUrlHelper.PathForMovies {
        let textUrlAllowed = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let path: ApiUrlHelper.PathForMovies = (textUrlAllowed?.isEmpty ?? true || text.isEmpty) ? .discover :  .search(forText: textUrlAllowed ?? text)
        return path 
    }
    
    func getCell(for tableView: UITableView, in row: Int) -> UITableViewCell? {
        guard let movie = discoverMovies?.results[row] else { return nil }
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
        let height: CGFloat? = 200
        let imageSetting = MovieCoverTableViewCell.ImageSetting(imagePath: movie.backdropPath, width: nil, height: height, corner: 10)
        
        cell?.populate(movieTitle: movie.originalTitle, imageSetting: imageSetting)
        return cell
    }
}
