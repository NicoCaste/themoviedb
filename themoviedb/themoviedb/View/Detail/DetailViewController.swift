//
//  DetailViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

class DetailViewController: BasicViewController {
    var tableView: GenericTableViewProtocol?
    let viewModel: DetailViewModelProtocol
    
    required init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    private func setTableView() {
        tableView = GenericTableView(cellsTypeList: viewModel.allowedCells, viewModel: viewModel)
        guard let tableView  else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
}

//MARK: Layout
extension DetailViewController {
    private func setTableViewLayout() {
        guard let tableView else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
