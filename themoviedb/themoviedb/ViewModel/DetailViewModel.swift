//
//  DetailViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import UIKit

typealias DetailViewModelProtocol = ViewModelHandleInfoTableViewProtocol

class DetailViewModel: BasicViewModel, DetailViewModelProtocol {
    var sections: Int = 1
    private let movieInfo: Movie
    private var movieGenders: String = ""
    private var basicFontSize: CGFloat = 16
    let persistenceController = PersistenceController()
    let allowedCells: [AllowedCells] =  [.movieCover, .centerTitleTableViewCell,  .titleAndDescriptionTableViewCell]
    
    enum DetailTableCases: Int, CaseIterable {
        case posterImage
        case movieName
        case categorie
        case voteAverage
        case overview
    }
    
    init(movieInfo: Movie, gendersList: [GenreDetail]?, repository: TheMovieRepositoryProtocol) {
        self.movieInfo = movieInfo
        super.init(repository: repository)
        self.setMovieGenders(genderList: gendersList)
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        DetailTableCases.allCases.count
    }
    
    func setMovieGenders(genderList: [GenreDetail]?) {
        guard let genderList else { return }
        var newMovieGendersList: [GenreDetail] = []
        
        for genre in movieInfo.genreIds ?? [] {
            newMovieGendersList += genderList.filter({$0.id == genre})
        }
        
        var index = 0
        newMovieGendersList.forEach({ gender in
            guard let name = gender.name else { return }
            movieGenders.append(name)
            index += 1
            if index < newMovieGendersList.count {
                movieGenders.append(", ")
            }
        })
    }
    
    func getMovieTitle() -> String {
        movieInfo.originalTitle ?? ""
    }
    
    func getMovieImagePath() -> String? {
        movieInfo.posterPath
    }
    
    @MainActor
    func getCell(for tableView: UITableView, in row: Int, for section: Int) -> UITableViewCell? {
        let rowCase = DetailViewModel.DetailTableCases(rawValue: row)
        var cell: UITableViewCell?
        switch rowCase {
        case .posterImage:
           cell = getPosterImageCell(for: tableView)
        case .movieName:
            cell = getMovieNameCell(for: tableView)
        case .voteAverage:
            cell = getVoteAverageCell(for: tableView)
        case .categorie:
            cell = getCategoryCell(for: tableView)
        case .overview:
            cell = getOverviewCell(for: tableView)
        default:
            return nil
        }
        return cell
    }
    
    //MARK: - Poster
    func getPosterImageCell(for tableView: UITableView) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
        let imagePath = getMovieImagePath()
        let imageSetting = ImageSetting(imagePath: imagePath, width: 220, height: 300, corner: 18)
        cell?.populate(movieTitle: nil, imageSetting: imageSetting)
        return cell
    }
    
    //MARK: - Title
    @MainActor
    func getMovieNameCell(for tableView: UITableView) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.centerTitleTableViewCell.rawValue) as? CenterTitleTableViewCell
        cell?.delegate = self
        cell?.populate(title: movieInfo.originalTitle, withLikeButton: true, startLiked: getMovieIsLiked())
        return cell
    }
    
    @MainActor
    func getMovieIsLiked() -> Bool {
        var isLiked = false
        guard let id = movieInfo.id else { return isLiked }
        let currentMovie = persistenceController.fetchMovieDetail(id: id)
        isLiked = currentMovie != nil
        return isLiked
    }
    
    //MARK: - Category
    private func getCategoryCell(for tableView: UITableView) -> UITableViewCell? {
        let title = UILabel.TextValues(text: "Categories: ", fontSize: basicFontSize, font: .NotoSansMyanmarBold, numberOfLines: 1, aligment: .left, textColor: .black)
        let description = UILabel.TextValues(text: movieGenders, fontSize: basicFontSize, font: .NotoSansMyanmar, numberOfLines: 0, aligment: .left, textColor: .black)
        return getTitleAndDescriptionRow(for: tableView, title: title, description: description, position: .next)
    }
    
    //MARK: Average
    private func getVoteAverageCell(for tableView: UITableView) -> UITableViewCell? {
        let title = UILabel.TextValues(text: "Vote average: ", fontSize: basicFontSize, font: .NotoSansMyanmarBold, numberOfLines: 1, aligment: .left, textColor: .black)
        let voteAverage = movieInfo.voteAverage ?? 0
        let description = UILabel.TextValues(text: String(voteAverage), fontSize: basicFontSize, font: .NotoSansMyanmar, numberOfLines: 1, aligment: .left, textColor: .black)
        return getTitleAndDescriptionRow(for: tableView, title: title, description: description, position: .next)
    }
    
    //MARK: Overview
    private func getOverviewCell(for tableView: UITableView) -> UITableViewCell? {
        let title = UILabel.TextValues(text: "Overview: ", fontSize: basicFontSize, font: .NotoSansMyanmarBold, numberOfLines: 1, aligment: .left, textColor: .black)
        let description = UILabel.TextValues(text: movieInfo.overview ?? "", fontSize: basicFontSize, font: .NotoSansMyanmar, numberOfLines: 0, aligment: .justified, textColor: .black)
        
        return getTitleAndDescriptionRow(for: tableView, title: title, description: description, position: .below)
    }
    
    func getTitleAndDescriptionRow(for tableView: UITableView, title: UILabel.TextValues, description: UILabel.TextValues, position: TitleAndDescriptionTableViewCell.DescriptionPosition) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.titleAndDescriptionTableViewCell.rawValue) as? TitleAndDescriptionTableViewCell
        cell?.populate(title: title, description: description, descriptionPosition: position)
        return cell
    }
}

//MARK: - LikedButton Delegate
extension DetailViewModel: CenterTitleLikeButtonDelegate {
    func heartButton(isLiked: Bool) {
        isLiked ? saveMovie(with: persistenceController) : removeMovie(with: persistenceController)
        NotificationCenter.default.post(name: NSNotification.Name.reloadMoviesSubscribed, object: nil)
    }
    
    func saveMovie(with controller: PersistenceController) {
        controller.save(favMovie: movieInfo)
    }
    
    func removeMovie(with controller: PersistenceController) {
        DispatchQueue.main.async { [weak self] in
            guard let id = self?.movieInfo.id else { return }
            controller.deleteMovie(from: id)
        }
    }
}
