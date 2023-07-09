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
    func getCell(for tableView: UITableView, in row: Int) -> UITableViewCell?
    func getNumberOfRows() -> Int
}
