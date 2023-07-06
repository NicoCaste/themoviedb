//
//  DetailViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

class DetailViewController: BasicViewController {
    var tableView: GenericTableView?
    let viewModel: DetailViewModel
    
    required init(viewModel: DetailViewModel) {
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
        tableView = GenericTableView(cellsTypeList: viewModel.allowedCells, delegate: self)
        guard let tableView  else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
}

extension DetailViewController: GenericTableViewDelegate {
    func numberOfRowInSection() -> Int {
        viewModel.getNumbersOfCells()
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let rowCase = DetailViewModel.DetailTableCases(rawValue: indexPath.row)
        return viewModel.getCell(for: tableView, in: rowCase)
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
