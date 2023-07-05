//
//  DetailViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import UIKit

class DetailViewModel: BasicViewModel {
    let movieInfo: MovieInfo
    var movieGenders: [GenresDetail] = []
    
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
    
    func getMovieImage(completion: @escaping(_ image: UIImage?) -> Void) {
        let imageHelper = LoaderImageHelper()
        let url = ApiUrlHelper.makeURL(for: .getImage, url: .image(path: movieInfo.posterPath))
        imageHelper.loadImage(with: url, completion: { image in
            completion(image)
        })
    }
    
    func setMovieGenders(genderList: [GenresDetail]?) {
        guard let genderList else { return }
        for genre in movieInfo.genreIds ?? [] {
            movieGenders += genderList.filter({$0.id == genre})
        }
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
            break
        case .categorie:
            break
        case .overview:
            break
        default:
            return nil
        }
        return cell
    }
    
    func getPosterImageCell(for tableView: UITableView) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
        let imagePath = getMovieImagePath()
        let imageSetting = MovieCoverTableViewCell.ImageSetting(imagePath: imagePath, width: 220, height: 300, corner: 18)
        cell?.populate(movieTitle: nil, imageSetting: imageSetting)
        return cell
    }
    
    func getMovieNameCell(for tableView: UITableView) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.centerTitleTableViewCell.rawValue) as? CenterTitleTableViewCell
        cell?.populate(title: movieInfo.originalTitle)
        return cell
    }
}
