//
//  HomeViewModelMocks.swift
//  themoviedbTests
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit
@testable import themoviedb

class HomeViewModelMock: BasicViewModel, HomeViewModelProtocol {
    var allowedCells: [themoviedb.AllowedCells] = [.movieCover]
    var currentPage: Int = 1
    var numberOfRows = 10
    
    init() {
        super.init(repository: MovieRespositoryMock(responseType: .moviesResult))
    }
    
    func getCurrentPage() -> Int {
        currentPage
    }
    
    func restarMovieList() {
        numberOfRows = 0
    }
    
    func getMovies(for path: themoviedb.ApiUrlHelper.PathForMovies, with searchType: themoviedb.PersistenceController.SearchMovie) async {
        switch searchType {
        case .forPage(let page):
            guard let page = page else { return }
            NotificationCenter.default.post(name: .callGetMovies, object: nil, userInfo: ["page": page])
        case .forTitle(let title):
            NotificationCenter.default.post(name: .callGetMovies, object: nil, userInfo: ["infoMovie": title])
        }
       
    }
    
    func getCell(for tableView: UITableView, in row: Int) -> UITableViewCell? {
        return row == 1 ? UITableViewCell() : nil
    }
    
    func getNumberOfRows() -> Int {
        numberOfRows
    }
    
    func getDetailInfo(movie index: Int) -> themoviedb.BasicViewController? {
        let viewModel = DetailViewModelMock()
        allowedCells = viewModel.allowedCells
        return DetailViewController(viewModel: viewModel)
    }
    
    func getPathForUserInput(text: String) -> themoviedb.ApiUrlHelper.PathForMovies {
        return .search(forText: text )
    }
    
    func nextPage() -> Int {
        1
    }
    
    func savePrefetchCell(for tableView: UITableView, in indexPaths: [IndexPath]) {
        
    }
}
