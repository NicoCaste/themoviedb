//
//  ViewModelHandleNextStepProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit

protocol ViewModelHandleTableViewDataSourceProtocol: BasicViewModel {
    func getDetailInfo(movie index: Int) -> BasicViewController?
    func savePrefetchCell(for tableView: UITableView, in indexPaths: [IndexPath])
}
