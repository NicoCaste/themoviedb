//
//  DetailViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import UIKit

class DetailViewModel: BasicViewModel {
    private let movieInfo: MovieInfo
    private var movieGenders: String = ""
    private var basicFontSize: CGFloat = 16
    let allowedCells: [AllowedCells] =  [.movieCover, .centerTitleTableViewCell,  .titleAndDescriptionTableViewCell]
    
    enum DetailTableCases: Int, CaseIterable {
        case posterImage
        case movieName
        case categorie
        case voteAverage
        case overview
    }
    
    init(movieInfo: MovieInfo, gendersList: [GenresDetail]?) {
        self.movieInfo = movieInfo
        super.init()
        setMovieGenders(genderList: gendersList)
    }
    
    func getNumbersOfCells() -> Int {
        DetailTableCases.allCases.count
    }
    
    func setMovieGenders(genderList: [GenresDetail]?) {
        guard let genderList else { return }
        var newMovieGendersList: [GenresDetail] = []
        
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
    
    func getCell(for tableView: UITableView, in rowCase: DetailTableCases?) -> UITableViewCell? {
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
        let imageSetting = MovieCoverTableViewCell.ImageSetting(imagePath: imagePath, width: 220, height: 300, corner: 18)
        cell?.populate(movieTitle: nil, imageSetting: imageSetting)
        return cell
    }
    
    //MARK: - Title
    func getMovieNameCell(for tableView: UITableView) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.centerTitleTableViewCell.rawValue) as? CenterTitleTableViewCell
        cell?.populate(title: movieInfo.originalTitle)
        return cell
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
