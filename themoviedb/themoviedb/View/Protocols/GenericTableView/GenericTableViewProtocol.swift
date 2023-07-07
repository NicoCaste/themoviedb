//
//  GenericTableViewProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit

protocol GenericTableViewProtocol: UIView {
    var delegate: GenericTableViewDelegate { get }
    var tableView: UITableView {get}
    func reloadTableView()
    func backToTop()
}
