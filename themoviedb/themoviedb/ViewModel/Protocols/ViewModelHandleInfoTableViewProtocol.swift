//
//  ViewModelHandleInfoTableViewProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit

protocol ViewModelHandleInfoTableViewProtocol: BasicViewModel {
    var allowedCells: [AllowedCells] { get }
    var sections: Int { get }
    func getCell(for tableView: UITableView, in row: Int, for section: Int) -> UITableViewCell?
    func getNumberOfRows(for section: Int) -> Int
}

protocol ViewModelHandleSubscribedMovies {
    func reloadSubscribedMovies()
}
