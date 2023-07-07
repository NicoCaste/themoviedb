//
//  DetailViewModelMock.swift
//  themoviedbTests
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit
@testable import themoviedb

class DetailViewModelMock: BasicViewModel, DetailViewModelProtocol {
    var allowedCells: [AllowedCells] = [.movieCover, .centerTitleTableViewCell,  .titleAndDescriptionTableViewCell]
    override init() {
        super.init()
    }
    
    func getCell(for tableView: UITableView, in row: Int) -> UITableViewCell? {
        return nil
    }
    
    func getNumberOfRows() -> Int {
        return 1
    }
}
