//
//  GenericTableView.swift
//  themoviedb
//
//  Created by nicolas castello on 03/07/2023.
//

import Foundation
import UIKit

enum AllowedCells: String {
    case movieCover
    case centerTitleTableViewCell
    case titleAndDescriptionTableViewCell
}

class GenericTableView: UIView, GenericTableViewProtocol {
    private(set) lazy var tableView: UITableView = UITableView()
    private(set) var delegate: GenericTableViewDelegate
    
    init(cellsTypeList: [AllowedCells], delegate: GenericTableViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        tableView.backgroundColor = .white
        self.backgroundColor = .white
        setTableView(with: cellsTypeList)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableView
    private func setTableView(with cellsTypeList: [AllowedCells]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection =  delegate.didSelectRow != nil ? true : false
        cellsNeeded(with: cellsTypeList)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        layoutTableView()
    }
    
    private func cellsNeeded(with cellsType: [AllowedCells]) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyListGenericCell")
        
        for cell in cellsType {
            register(cell: cell)
        }
    }
    
    private func register(cell: AllowedCells) {
        switch cell {
        case .movieCover:
            tableView.register(MovieCoverTableViewCell.self, forCellReuseIdentifier: cell.rawValue)
        case .titleAndDescriptionTableViewCell:
            tableView.register(TitleAndDescriptionTableViewCell.self, forCellReuseIdentifier: cell.rawValue)
        case .centerTitleTableViewCell:
            tableView.register(CenterTitleTableViewCell.self, forCellReuseIdentifier: cell.rawValue)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func backToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
}

extension GenericTableView:  UITableViewDelegate, UITableViewDataSource {
    // MARK: - Number Of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.numberOfRowInSection()
    }
    
    // MARK: - Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return delegate.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    // MARK: - Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectRow?(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - Layout
extension GenericTableView {
    // MARK: - TableView
    func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
