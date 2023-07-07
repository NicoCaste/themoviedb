//
//  GenericTableViewMock.swift
//  themoviedbTests
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
import UIKit
@testable import themoviedb

class GenericTableViewMock: UIView, GenericTableViewProtocol, GenericTableViewDelegate {
    var delegate: themoviedb.GenericTableViewDelegate
    var tableView: UITableView = UITableView()
    
    init(delegate: GenericTableViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTableView() {

    }
    
    func backToTop() {
        NotificationCenter.default.post(name: .callBacktoTheTop, object: nil, userInfo: ["backToTheTop": true])
    }
    
    func numberOfRowInSection() -> Int {
        return 1
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
}
