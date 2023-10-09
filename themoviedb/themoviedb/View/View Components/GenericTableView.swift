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
    case movieSubscribed
}

class GenericTableView: UIView, GenericTableViewProtocol {
    private(set) lazy var tableView: UITableView = UITableView()
    private(set) weak var delegate: GenericTableViewDelegate?
    private(set) var viewModel: ViewModelHandleInfoTableViewProtocol
    private var numberOfRows: Int = 0
    
    init(cellsTypeList: [AllowedCells], delegate: GenericTableViewDelegate? = nil,  viewModel: ViewModelHandleInfoTableViewProtocol) {
        self.delegate = delegate
        self.viewModel = viewModel
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
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        cellsNeeded(with: cellsTypeList)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        layoutTableView()
    }
    
    private func cellsNeeded(with cellsType: [AllowedCells]) {
        //obligatory rows
        tableView.register(MovieCoverTableViewCell.self, forCellReuseIdentifier: AllowedCells.movieCover.rawValue)
        tableView.register(CenterTitleTableViewCell.self, forCellReuseIdentifier: AllowedCells.centerTitleTableViewCell.rawValue)
        
        for cell in cellsType {
            register(cell: cell)
        }
    }
    
    private func register(cell: AllowedCells) {
        switch cell {
        case .titleAndDescriptionTableViewCell:
            tableView.register(TitleAndDescriptionTableViewCell.self, forCellReuseIdentifier: cell.rawValue)
        case .movieSubscribed:
            tableView.register(MovieSubscribedTableViewCell.self, forCellReuseIdentifier: cell.rawValue)
        default:
            break
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
    
    private enum EmptyCaseCells: Int, CaseIterable {
        case image
        case title
    }
    
    private func getEmptyResultCell(for tableView: UITableView, in row: Int) -> UITableViewCell? {
        switch EmptyCaseCells(rawValue: row)  {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
            let height: CGFloat? = 200
            let image = UIImage(named: "sadLogo")
            let imageSetting = ImageSetting(imagePath: nil, width: nil, height: height, corner: 10, image: image)
            
            cell?.populate(movieTitle: nil, imageSetting: imageSetting)
            return cell
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.centerTitleTableViewCell.rawValue) as? CenterTitleTableViewCell
            
            cell?.populate(title: "Sorry, no results found", withLikeButton: false)
            return cell
        default:
            return nil
        }
        
    }
}

extension GenericTableView:  UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    //Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections
    }
    
    // MARK: - Number Of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows = viewModel.getNumberOfRows(for: section)
        let showRows = numberOfRows == 0 ? EmptyCaseCells.allCases.count : numberOfRows
        tableView.allowsSelection = !(numberOfRows == 0)
        return showRows
    }
    
    // MARK: - Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell()
        if numberOfRows == 0 {
            return getEmptyResultCell(for: tableView, in: indexPath.row) ?? emptyCell
        } else {
            let cell =  viewModel.getCell(for: tableView, in: indexPath.row, for: indexPath.section)  ?? emptyCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // MARK: - Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow?(tableView, didSelectRowAt: indexPath)
    }
    
    //MARK: - Prefetch
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        delegate?.prefetchRowsAt?(tableView: tableView, prefetchRowsAt: indexPaths)
    }
    
    //MARK: - Will Display
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.willDisplay?(tableView, willDisplay: cell, forRowAt: indexPath)
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
