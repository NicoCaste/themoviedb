//
//  InfoViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 09/07/2023.
//

import Foundation
import UIKit

typealias InfoViewModelProtocol = ViewModelInfoHandleActions & ViewModelHandleInfoTableViewProtocol

protocol ViewModelInfoHandleActions: BasicViewModel {
    var delegate: InfoViewModelDelegate? { get set }
    func settingAction(index: Int)
}

protocol InfoViewModelDelegate {
    func open(url: URL?)
}

class InfoViewModel: BasicViewModel,InfoViewModelProtocol {
    var allowedCells: [AllowedCells] = [.titleAndDescriptionTableViewCell]
    let persistence: PersistenceController
    var delegate: InfoViewModelDelegate?
    let dbUrl = "https://www.themoviedb.org/"
    
    required init(repository: TheMovieRepositoryProtocol, persistence: PersistenceController = PersistenceController()) {
        self.persistence = persistence
        super.init(repository: repository)
    }
    
    enum SettingsRows: Int, CaseIterable {
        case aboutMovieDb
    }
    
    func getNumberOfRows() -> Int {
        return SettingsRows.allCases.count
    }
    
    func getCell(for tableView: UITableView, in row: Int) -> UITableViewCell? {
        switch SettingsRows(rawValue: row) {
        case .aboutMovieDb:
            let title = UILabel.TextValues(text: "About MovieDB", fontSize: 17, font: .NotoSansMyanmarBold, numberOfLines: 1, aligment: .left, textColor: .darkGray)
            return getTitleAndDescriptionRow(for: tableView, title: title, description: nil, position: .next)
        case .none:
            return nil
        }
    }
    
    func getTitleAndDescriptionRow(for tableView: UITableView, title: UILabel.TextValues, description: UILabel.TextValues?, position: TitleAndDescriptionTableViewCell.DescriptionPosition) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.titleAndDescriptionTableViewCell.rawValue) as? TitleAndDescriptionTableViewCell
        cell?.populate(title: title, description: description, descriptionPosition: position)
        return cell
    }
    
    func settingAction(index: Int) {
        switch SettingsRows(rawValue: index) {
        case .aboutMovieDb:
            self.getMovieDbUrl()
        default:
            break
        }
    }
    
    func getMovieDbUrl() {
        let url =  URL(string: dbUrl)
        delegate?.open(url: url)
    }
}
