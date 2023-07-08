//
//  GenericTableViewDelegate.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit

@objc protocol GenericTableViewDelegate {
    @objc func numberOfRowInSection() -> Int
    @objc func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell?
    @objc optional func didSelectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func prefetchRowsAt(tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath])
    @objc optional func willDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)

}
