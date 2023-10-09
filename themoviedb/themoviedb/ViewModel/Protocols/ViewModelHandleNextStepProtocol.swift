//
//  ViewModelHandleNextStepProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit

protocol ViewModelHandleTableViewDataSourceProtocol: BasicViewModel {
    func getDetailInfo(from index: Int) -> BasicViewController?
    func getDetailInfo(from movie: Movie) -> BasicViewController?
    func savePrefetchCell(for tableView: UITableView, in indexPaths: [IndexPath])
}
